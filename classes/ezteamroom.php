<?php
//
// Created on: <2008-09-15 16:13:42 ab>
//
// SOFTWARE NAME: eZ Teamroom extension for eZ Publish
// SOFTWARE RELEASE: 0.x
// COPYRIGHT NOTICE: Copyright (C) 1999-2010 eZ Systems AS
// SOFTWARE LICENSE: GNU General Public License v2.0
// NOTICE: >
//   This program is free software; you can redistribute it and/or
//   modify it under the terms of version 2.0  of the GNU General
//   Public License as published by the Free Software Foundation.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of version 2.0 of the GNU General
//   Public License along with this program; if not, write to the Free
//   Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
//   MA 02110-1301, USA.
//
//

require_once( 'autoload.php');
include_once( 'kernel/common/template.php' );

class eZTeamroom
{

    // There are only static functions in this class
    private function __construct()
    {
    }

    public static function sendSinlgeEmail( $receiverEmailAddress, $teamroomContentObject, $template, $emailSender = false, $params = false )
    {
        $siteIni      = eZINI::instance();
        $ezMailObject = new eZMail();
        $tpl          = templateInit();

        if ( !$emailSender )
        {
            $emailSender = $siteIni->variable( 'MailSettings', 'EmailSender' );
        }
        if ( !$emailSender )
        {
            $emailSender = $siteIni->variable( 'MailSettings', 'AdminEmail' );
        }

        $tpl->setVariable( 'teamroom', $teamroomContentObject );
        if ( $params && is_array( $params ) )
        {
            foreach ( $params as $key => $value )
            {
                $tpl->setVariable( $key, $value );
            }
        }

        $receiverUserObject = eZUser::fetchByEmail( $receiverEmailAddress );

        if ( !is_object( $receiverUserObject ) )
        {
            eZDebug::writeWarning( 'Failed to fetch object for user with email address ' . $receiverEmailAddress, 'eZTeamroom::sendSinlgeEmail()' );
            return false;
        }

        $tpl->setVariable( 'receiverUserObject', $receiverUserObject );

        $body    = $tpl->fetch( 'design:teamroom/mail/' . $template . '.tpl' );
        $subject = $tpl->variable( 'subject' );

        $ezMailObject->setReceiver( $receiverEmailAddress );
        $ezMailObject->setSender( $emailSender );
        $ezMailObject->setSubject( $subject );
        $ezMailObject->setBody( $body );

        $mailResult = eZMailTransport::send( $ezMailObject );
        return $mailResult;
    }

    // returns an array of all user-Objects which are Member of the given teamroom
    public static function getTeamroomMembers( $teamroomNode )
    {
        $subTreeParams = array( 'Depth'            => 0,
                                'Limitation'       => array(),
                                'SortBy'           => array( array( 'name', true ) ),
                                'ClassFilterType'  => 'include',
                                'ClassFilterArray' => array( 'user' )
                              );
        $memberNodeList = $teamroomNode->subTree( $subTreeParams );
        foreach (  $memberNodeList as $memberNode ){
            $userObjectList[] = $memberNode->attribute('object');
        }
        return $userObjectList;
    }

    public static function removeMember( $removeNode , $teamroomNode )
    {
        //get all nodeAssignments
        if ( $removeNode->attribute( 'class_identifier' ) != 'user' )
        {
            eZDebug::writeWarning( 'Member object is not a instance of user class.', __METHOD__ );
            return;
        }

        $userContentObject   = $removeNode->attribute( 'object' );
        $userContentObjectID = $removeNode->attribute( 'contentobject_id' );

        $allNodes      = $userContentObject->assignedNodes();
        $allNodesCount = count( $allNodes );
        if ( !is_array( $allNodes ) || $allNodesCount < 1 )
        {
            eZDebug::writeWarning( 'There seems to be a problem with the nodes of user with id ' . $userContentObjectID );
            return;
        }

        // The user only has one node and this node should be deleted
        // Therefore we add another location which will be used as the new main node later
        if ( $allNodesCount == 1 )
        {
            $siteINI              = eZINI::instance( 'site.ini' );
            $defaultUserPlacement = (int)$siteINI->variable( "UserSettings", "DefaultUserPlacement" );
            $newMainNode          = eZContentObjectTreeNode::fetch( $defaultUserPlacement );
            if ( $newMainNode instanceof eZContentObjectTreeNode )
            {
                $insertedNode = $userContentObject->addLocation( $defaultUserPlacement, true );
                $insertedNode->setAttribute( 'contentobject_is_published', 1 );
                $insertedNode->setAttribute( 'main_node_id', $removeNode->attribute( 'main_node_id' ) );
                $insertedNode->setAttribute( 'contentobject_version', $removeNode->attribute( 'contentobject_version' ) );
                $insertedNode->updateSubTreePath();
                $insertedNode->sync();
                unset( $insertedNode );
            }
            else
            {
                eZDebug::writeWarning( 'Can not add new main node for user with id ' . $userContentObjectID . ' with node id ' . $defaultUserPlacement );
                return;
            }
            unset( $siteINI, $newMainNode );
        }

        $nodeAssignmentList  = eZNodeAssignment::fetchForObject( $userContentObjectID, $userContentObject->attribute( 'current_version' ), 0, false );

        // get nodeAssignmentIDs to the teamroom-member-group
        $removeNodeAssignmentIDList = array();
        $db = eZDB::instance();
        $db->begin();
        foreach ( $nodeAssignmentList as $nodeAssignment )
        {
            if ( $nodeAssignment['parent_node'] == $removeNode->attribute( 'parent_node_id' ) )
            {
                $removeNodeAssignmentIDList[] = $nodeAssignment['id'];
            }
        }
        // check if node is main node
        $mainNodeChanged = false;
        if ( $removeNode->attribute( 'node_id' ) == $removeNode->attribute( 'main_node_id' ) )
        {
            $mainNodeChanged = true;
        }

        // delete nodeAssignment
        eZNodeAssignment::purgeByID( array_unique( $removeNodeAssignmentIDList ) );

        // remove removeNode
        $removeNode->removeThis();

        // set new mainNode if nessessary
        if ( $mainNodeChanged )
        {
            $allNodes = $userContentObject->assignedNodes();
            if ( is_array( $allNodes ) && count( $allNodes ) > 0 )
            {
                $mainNode = $allNodes[0];
                eZContentObjectTreeNode::updateMainNodeID( $mainNode->attribute( 'node_id' ), $userContentObjectID, false, $mainNode->attribute( 'parent_node_id' ) );
            }
            else
            {
                eZDebug::writeWarning( 'Failed to set new main node for user with id ' . $userContentObjectID );
            }
        }

        // remove teamroom roles
        $teamroomPath = $teamroomNode->attribute('path_string');
        $user = eZUser::fetch( $userContentObjectID );
        $roleList = $user->attribute( 'roles' );

        foreach( $roleList as $role  )
        {
            if ( $role->attribute( 'limit_value' ) == $teamroomPath )
            {
                $role->removeUserAssignmentByID( $role->attribute('user_role_id') );
            }
        }

        $db->commit();

        // clear Caches

        eZContentCacheManager::clearObjectViewCacheIfNeeded( $userContentObjectID );
        eZUser::cleanupCache();
        eZContentObject::clearCache( array( $teamroomNode->attribute( 'contentobject_id' ) ) );
    }

    public static function getUserInformation( $teamroomNodeObject, $teamroomPathString )
    {
        $subTreeParams = array( 'Depth'            => 0,
                                'Limitation'       => array(),
                                'SortBy'           => array( array( 'name', true ) ),
                                'ClassFilterType'  => 'include',
                                'ClassFilterArray' => array( 'user_group' )
                              );
        $usergroupNodeList = $teamroomNodeObject->subTree( $subTreeParams );
        $userGroupList     = array();
        $userRoleIDList    = array();
        $userNodeIDList    = array();
        foreach ( $usergroupNodeList as $groupNode )
        {
            $subTreeParams = array( 'Depth'            => 1,
                                    'Limitation'       => array(),
                                    'SortBy'           => array( array( 'name', true ) ),
                                    'ClassFilterType'  => 'include',
                                    'ClassFilterArray' => array( 'user' )
                                  );
            $userGroupList[ $groupNode->attribute('node_id') ] = array( 'node'             => $groupNode,
                                                                        'node_id'          => $groupNode->attribute('node_id'),
                                                                        'depth'            => $groupNode->attribute('depth'),
                                                                        'name'             => $groupNode->attribute('name'),
                                                                        'contentobject_id' => $groupNode->attribute('contentobject_id'),
                                                                        'user'             => $groupNode->subTree( $subTreeParams )
                                                                      );

            foreach ( $userGroupList[ $groupNode->attribute('node_id') ]['user'] as $userNodeObject )
            {
                $userObject = eZUser::fetch( $userNodeObject->attribute('contentobject_id') );
                if ( $userObject )
                {
                    $roleObjectList                                                   = $userObject->attribute( 'roles' );
                    $userRoleIDList[ $userNodeObject->attribute('contentobject_id') ] = array();
                    $userNodeIDList[]                                                 = $userNodeObject->attribute('main_node_id');

                    foreach ( $roleObjectList as $roleObject  )
                    {
                        if ( $teamroomPathString == $roleObject->attribute( 'limit_value' ) )
                        {
                            $userRoleIDList[ $userNodeObject->attribute('contentobject_id') ][] = $roleObject->attribute('id');
                        }
                    }
                }
                else
                {
                    eZDebug::writeWarning( 'Failed to fetch user with ID ' . $userNodeObject->attribute('contentobject_id'), 'eZTeamroom::getUserInformation()' );
                }
            }
        }
        return array( 'userGroupList'  => $userGroupList,
                      'userRoleIDList' => $userRoleIDList,
                      'userNodeIDList' => $userNodeIDList
                    );
    }

    public static function checkTeamroomSubtreeAccess( $module, $view, $userID = false, $sectionID = false, $pathString = false  )
    {
        if ( $userID )
        {
            $user = eZUser::fetch( $userID );
        }
        else
        {
            $user = eZUser::currentUser();
        }

        if ( is_object( $user ) )
        {
            $accessResult = $user->hasAccessTo( $module, $view );
            $accessWord   = $accessResult['accessWord'];
            if ( $accessWord == 'yes' )
            {
                return true;
            }
            else if ( $accessWord == 'no' )
            {
                return false;
            }
            else
            {
                $policies  = $accessResult['policies'];
                foreach ( $policies as $limitationArray  )
                {
                    $access = false;
                    foreach ( array_keys( $limitationArray ) as $key  )
                    {
                        switch ( $key )
                        {
                            case 'Section':
                            case 'User_Section':
                            {
                                if ( in_array( $sectionID, $limitationArray[$key]  ) )
                                {
                                    $access = true;
                                }
                                else
                                {
                                    $access = false;
                                }
                            } break;

                            case 'User_Subtree':
                            {
                                $subtreeArray = $limitationArray[$key];
                                foreach ( $subtreeArray as $subtreeString )
                                {
                                    if ( strstr( $pathString, $subtreeString ) )
                                    {
                                        $access = true;
                                    }
                                }
                            } break;

                            default:
                            {
                                eZDebug::writeWarning( 'Unknown limitation: ' . $key, 'eZTeamroom::checkTeamroomSubtreeAccess' );
                            }
                            break;
                        }

                        if ( !$access )
                        {
                            eZDebug::writeDebug( 'No access granted by the limitation: ' . $key, 'eZTeamroom::checkTeamroomSubtreeAccess()' );
                            break;
                        }

                    }

                    if ( $access )
                    {
                        break;
                    }
                }
            }
            return $access;
        }
        else
        {
            eZDebug::writeDebug( 'Failed to fetch user to check access restrictions.', 'eZTeamroom::checkTeamroomSubtreeAccess()' );
        }
        return false;
    }

    public static function parentNodeIDArray( $userObject )
    {
        $nodeAssignmentList = eZNodeAssignment::fetchForObject( $userObject->attribute( 'id' ), $userObject->attribute( 'current_version' ), 0, false );
        $assignedNodes      = $userObject->assignedNodes();
        $parentNodeIDArray  = array();

        foreach ( $assignedNodes as $assignedNode )
        {
            $append = false;
            foreach ( $nodeAssignmentList as $nodeAssignment )
            {
                if ( $nodeAssignment['parent_node'] == $assignedNode->attribute( 'parent_node_id' ) )
                {
                    $append = true;
                    break;
                }
            }
            if ( $append )
            {
                $parentNodeIDArray[] = $assignedNode->attribute( 'parent_node_id' );
            }
        }

        return $parentNodeIDArray;
    }

    public static function addMember( $teamroomID, $userID )
    {
        // get the teamroomObject and main_node
        $classIdentifierMap = eZTeamroom::getClassIdentifierList();
        $teamroomObject     = eZContentObject::fetch( (int) $teamroomID);
        if ( !is_object( $teamroomObject ) ||  $teamroomObject->attribute( 'class_identifier' ) != $classIdentifierMap['teamroom'] )
        {
            eZDebug::writeError( 'Failed to fetch object for $teamroomID ' . $teamroomID, 'ezteamroom::addMember()' );
            return false;
        }
        $teamroomNode = $teamroomObject->attribute('main_node');
        if ( !is_object( $teamroomNode ) || $teamroomNode->attribute( 'class_identifier' ) != $classIdentifierMap['teamroom'] )
        {
            eZDebug::writeError( 'Failed to fetch object for $teamroomID ' . $teamroomID, 'ezteamroom::addMember()' );
            return false;
        }

        // get the teamrooms member-group
        $subTreeParams = array( 'Depth'            => 1,
                                'DepthOperator'    => 'eq',
                                'Limitation'       => array(),
                                'ClassFilterType'  => 'include',
                                'ClassFilterArray' => array( 'user_group' )
                                );
        $userGroups = $teamroomNode->subTree( $subTreeParams );
        if  ( !count($userGroups) ){
            eZDebug::writeError( 'Failed to fetch member_group for $teamroomID ' . $teamroomID, 'ezteamroom::addMember()' );
            return false;
        }
        $memberGroupNodeID = $userGroups[0]->attribute( 'node_id' );

        $user = eZContentObject::fetch( $userID );
        if ( !is_object( $user ) ){
            eZDebug::writeError( 'Failed to fetch object for user ID ' . $userID, 'ezteamroom::addMember()' );
            return false;
        }
        $parentNodeIDArray = eZTeamroom::parentNodeIDArray( $user );

        if ( !in_array( $memberGroupNodeID, $parentNodeIDArray ) )
        {
            eZDebugSetting::writeDebug( 'teamroom', 'no location yet, adding one', 'ezteamroom::addMember' );

            $db = eZDB::instance();
            $db->begin();

            $insertedNode = $user->addLocation( $memberGroupNodeID, true );
            $insertedNode->setAttribute( 'contentobject_is_published', 1 );
            $insertedNode->setAttribute( 'main_node_id', $user->attribute( 'main_node_id' ) );
            $insertedNode->setAttribute( 'contentobject_version', $user->attribute( 'current_version' ) );
            $insertedNode->updateSubTreePath();
            $insertedNode->sync();

            $db->commit();

            eZUser::cleanupCache();
            eZContentCacheManager::clearContentCacheIfNeeded( $userID );
            eZContentObject::clearCache( array( $teamroomID ) );
        }
        return true;
    }

    public static function investigateMailAccounts()
    {
        $teamroomIni = eZINI::instance( 'teamroom.ini' );
        if ( !is_object( $teamroomIni ) )
        {
            eZDebug::writeWarning( 'Failed to get instance for teamroom.ini', __METHOD__ );
            return false;
        }
        if ( $teamroomIni->hasGroup( 'DefaultMailServerSettings' ) &&
             $teamroomIni->hasGroup( 'TeamroomSettings' )
           )
        {
            return eZTeamroom::getMailsFromDefaultServer( $teamroomIni->group( 'DefaultMailServerSettings' ),
                                                          $teamroomIni->group( 'TeamroomSettings' )
                                                        );
        }
        else
        {
            eZDebug::writeWarning( 'Missing settings in teamroom.ini' );
        }
    }

    public static function getClassIdentifierList()
    {
        $teamroomIni = eZINI::instance( 'teamroom.ini' );
        if ( !is_object( $teamroomIni ) )
        {
            eZDebug::writeWarning( 'Failed to get instance for teamroom.ini', __METHOD__ );
            return array();
        }
        if ( $teamroomIni->hasVariable( 'TeamroomSettings', 'ClassIdentifiersMap' ) )
        {
            return $teamroomIni->variable( 'TeamroomSettings', 'ClassIdentifiersMap' );
        }
        else
        {
            eZDebug::writeWarning( 'No setting ClassIdentifiersMap in block TeamroomSettings of teamroom.ini', __METHOD__ );
        }
        return array();
    }

    public static function assignUserPermissions( $userID, $oldRoleIdList, $newRoleIdList, $teamroomNodeID )
    {
        $permissionsChanged = false;
        $db                 = eZDB::instance();
        $teamroomPath       = eZContentObjectTreeNode::fetch( $teamroomNodeID )->attribute('path_string');
        $roleList           = eZUser::fetch( $userID )->attribute( 'roles' );
        foreach ( $oldRoleIdList as $roleID => $wasSet )
        {
            if ( isset( $newRoleIdList[$roleID] ) )
            {
                $shouldBeSet = $newRoleIdList[$roleID];
            }
            else
            {
                $shouldBeSet = false;
            }

            // Was assigned, but has been unchecked.
            if ( $wasSet == 'yes' && !$shouldBeSet )
            {
                $db->begin();
                $roleObject = eZRole::fetch( $roleID );
                if ( is_object( $roleObject ) )
                {
                    foreach ( $roleList as $role  )
                    {
                        if ( $role->attribute( 'limit_value' ) == $teamroomPath && $role->attribute( 'id' ) == $roleID )
                        {
                            $role->removeUserAssignmentByID( $role->attribute('user_role_id') );
                        }
                    }
                    $db->commit();
                }
                else
                {
                    eZDebug::writeWarning( 'Failed to fetch teamroom role with ID ' . $roleID, __METHOD__ );
                    $db->rollback();
                }
                $permissionsChanged = true;
            }
            // Was not assigned, but has been checked.
            elseif ( $wasSet == 'no' && $shouldBeSet )
            {
                $db->begin();
                $roleObject = eZRole::fetch( $roleID );
                if ( is_object( $roleObject ) )
                {
                    $roleObject->assignToUser( $userID, 'subtree', $teamroomNodeID );
                    $roleObject->store();
                    $db->commit();
                }
                else
                {
                    eZDebug::writeWarning( 'Failed to fetch teamroom role with ID ' . $roleID, __METHOD__ );
                    $db->rollback();
                }
                $permissionsChanged = true;
            }
            else
            {
                eZDebug::writeDebug( 'Skip setting role ' . $roleID . ' ' . $wasSet . ' ' . $shouldBeSet, __METHOD__ );
            }
        }
        if ( $permissionsChanged )
        {
            eZContentCacheManager::clearContentCacheIfNeeded($userID);
            eZUser::cleanupCache();
        }
        return $permissionsChanged;
    }

    public static function getTeamroomRoleIDList()
    {
        $teamroomINI = eZINI::instance( 'teamroom.ini' );
        if ( is_object( $teamroomINI ) )
        {
            if ( $teamroomINI->hasVariable( 'PermissionSettings', 'TeamroomRoleList' ) )
            {
                return $teamroomINI->variable( 'PermissionSettings', 'TeamroomRoleList' );
            }
            else
            {
                eZDebug::writeWarning( 'No TeamroomRoleList settings below PermissionSettings in teamroom.ini found.', __METHOD__ );
            }
        }
        else
        {
            eZDebug::writeWarning( 'Failed to get instance of teamroom.ini', __METHOD__ );
        }
        return array();
    }

    public static function getTeamroomRoleList()
    {
        $roleIDList     = eZTeamroom::getTeamroomRoleIDList();
        $roleObjectList = array();
        foreach ( $roleIDList as $roleID )
        {
            $roleObject = eZRole::fetch( $roleID );
            if ( is_object( $roleObject ) )
            {
                $name = $roleObject->attribute( 'name' );
                $name = str_replace( 'Teamroom ', '', $name );
                $roleObject->setAttribute( 'name', $name );
                $roleObjectList[] = $roleObject;
            }
            else
            {
                eZDebug::writeWarning( 'Failed to fetch teamroom role with ID ' . $roleID, __METHOD__ );
            }
        }
        return $roleObjectList;
    }

    private static function getMailsFromDefaultServer( $defaultMailServerSettings, $teamroomSettings )
    {
        $poolNodeID = 2;
        $mailTransport = null;
        if ( isset( $defaultMailServerSettings['Server']['POP3'] )   && $defaultMailServerSettings['Server']['POP3']   != '' &&
             isset( $defaultMailServerSettings['Username']['POP3'] ) && $defaultMailServerSettings['Username']['POP3'] != '' &&
             isset( $defaultMailServerSettings['Password']['POP3'] ) && $defaultMailServerSettings['Password']['POP3'] != ''
           )
        {
            $port = null;
            if ( isset( $defaultMailServerSettings['Port']['POP3'] ) && $defaultMailServerSettings['Port']['POP3'] != '' )
            {
                $port = $defaultMailServerSettings['Port']['POP3'];
            }
            $mailTransport = new ezcMailPop3Transport( $defaultMailServerSettings['Server']['POP3'], $port, array() );
        }
        if ( isset( $defaultMailServerSettings['Server']['IMAP'] )   && $defaultMailServerSettings['Server']['IMAP']   != '' &&
             isset( $defaultMailServerSettings['Username']['IMAP'] ) && $defaultMailServerSettings['Username']['IMAP'] != '' &&
             isset( $defaultMailServerSettings['Password']['IMAP'] ) && $defaultMailServerSettings['Password']['IMAP'] != ''
           )
        {
            $port = null;
            if ( isset( $defaultMailServerSettings['Port']['IMAP'] ) && $defaultMailServerSettings['Port']['IMAP'] != '' )
            {
                $port = $defaultMailServerSettings['Port']['IMAP'];
            }
            $mailTransport = new ezcMailImapTransport( $defaultMailServerSettings['Server']['IMAP'], $port, array() );
        }
        if ( $mailTransport !== null )
        {
            if ( isset( $teamroomSettings['TeamroomPoolNodeID'] ) )
            {
                $poolNodeID = $teamroomSettings['TeamroomPoolNodeID'];
            }
//var_dump( $poolNodeID );
            $mailTransport->authenticate( $defaultMailServerSettings['Username']['POP3'], $defaultMailServerSettings['Password']['POP3'] );
            $messages = $mailTransport->listMessages();
            eZTeamroom::parseMailMessages( $messages, $mailTransport, $poolNodeID );
            $mailTransport->disconnect();
        }
        else
        {
            eZDebug::writeWarning( 'Failed to instantiate mail transport' );
        }
    }

    private static function parseMailMessages( $messages, $mailTransport, $poolNodeID )
    {
        $parser = new ezcMailParser();
        foreach ( $messages as $messageNr => $size )
        {
            $set     = new ezcMailVariableSet( $mailTransport->top( $messageNr ) );
            $mailSet = $parser->parseMail( $set );
            if ( !isset( $mailSet[0] ) )
            {
                continue;
            }
            $mail = $mailSet[0];
            if ( !isset( $mail->to[0] ) )
            {
                continue;
            }
            if ( preg_match( "/.?Teamroom '([^']*)' \(([0-9]+)\)/", $mail->to[0], $treffer ) )
            {
                $teamroomNodeObject = null;
                // Fetch teamroom by node ID
                if ( isset( $treffer[2] ) )
                {
                    $teamroomNodeObject = eZContentObjectTreeNode::fetch( $treffer[2] );
                    if ( !is_object( $teamroomNodeObject ) )
                    {
                        $teamroomNodeObject = null;
                    }
                }
                // Fetch teamroom by name
                if ( $teamroomNodeObject == null && isset( $treffer[1] ) )
                {
                    $treeParameters = array( 'AttributeFilter'  => array( array( 'name', '=', $treffer[1] ) ),
                                             'ClassFilterType'  => 'include',
                                             'ClassFilterArray' => array( 'teamroom' ),
                                             'Limitation'       => false,
                                             'MainNodeOnly'     => true
                                           );
                    $children = eZContentObjectTreeNode::subTreeByNodeID( $treeParameters,
                                                                          $poolNodeID
                                                                        );
                    $children_count = count( $children );
                    if ( $children_count == 1 )
                    {
                        $teamroomNodeObject = $children[0];
                    }
                    else if ( $children_count < 1 )
                    {
                        eZDebug::writeWarning( 'No teamrooms found in ' .  $poolNodeID );
                        //var_dump( $treeParameters );
                    }
                    else
                    {
                        eZDebug::writeWarning( 'More than one teamroom found in ' .  $poolNodeID );
                        //var_dump( $treeParameters );
                    }
                    unset( $children );
                }
                if ( $teamroomNodeObject == null )
                {
                    eZDebug::writeWarning( 'No teamroom name or ID found in receiver information ' .  $mail->to[0] );
                    continue;
                }
                eZTeamroom::uploadFileFromMail( $mail, $teamroomNodeObject );
            }
            else
            {
                eZDebug::writeDebug( 'Skipped email with receiver ' . $mail->to[0] );
            }
        }
    }

    private static function uploadFileFromMail( $mail, $teamroomNodeObject )
    {
        $fileFolderNodeObjects = array();
        $childNodeObjects      = $teamroomNodeObject->attribute( 'children' );
        foreach ( $childNodeObjects as $childNodeObject )
        {
            $classIdentifierMap = eZTeamroom::getClassIdentifierList();
            if ( $childNodeObject->attribute( 'class_identifier' )  == $classIdentifierMap['file_folder'] )
            {
                $fileFolderNodeObjects[] = $childNodeObject;
            }
        }
        unset( $childNodeObjects );
        if ( count( $fileFolderNodeObjects ) < 1 )
        {
            eZDebug::writeWarning( 'No file folder found' );
            return false;
        }
        if ( count( $fileFolderNodeObjects ) > 1 )
        {
            eZDebug::writeWarning( 'More than one file folder found' );
            return false;
        }
//var_dump( 'Mail:' );
//var_dump( $mail );
        $files = $mail->fetchParts();
//var_dump( 'Files:' );
//var_dump( $files );
        if ( count( $files ) > 0 )
        {
//var_dump( 'Body 1:' );
//var_dump( $mail->body );
            foreach ( $files as $file )
            {
//var_dump( 'File:' );
//var_dump( $file );
                //eZTeamroom::publishFileFromMail( $fileFolderNodeObjects[0], $mail->messageId, $mail->subject, $mail->body, $file->fileName );
            }
        }
        else
        {
//var_dump( 'Body 2:' );
//var_dump( $mail->body );
            //eZTeamroom::publishFileFromMail( $fileFolderNodeObjects[0], $mail->messageId, $mail->subject, $mail->body, $file->fileName );
        }
    }

    private static function publishFileFromMail( $fileFolderNodeObject, $uniqueID, $name, $description, $fileName = null )
    {
    }

}

?>
