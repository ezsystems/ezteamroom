<?php
//
// Created on: <2007-11-28 23:37:38 dis>
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

$Module     =  $Params['Module'];
$teamroomID = $Params['TeamroomID'];
$manageUrl  = '/teamroom/manage/' . $teamroomID;
$inviteUrl  = '/teamroom/invite/' . $teamroomID;
$messages   = array();
$errors     = array();

// get the teamroomObject and main_node
if ( !is_numeric( $teamroomID ) )
{
    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}

$classIdentifierMap = eZTeamroom::getClassIdentifierList();
$teamroomObject     = eZContentObject::fetch( (int) $teamroomID);
if ( !is_object( $teamroomObject ) ||  $teamroomObject->attribute( 'class_identifier' ) != $classIdentifierMap['teamroom'] )
{
    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}
$teamroomNode = $teamroomObject->attribute('main_node');
if ( !is_object( $teamroomNode ) || $teamroomNode->attribute( 'class_identifier' ) != $classIdentifierMap['teamroom'] )
{
    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}
$teamroomPath = $teamroomNode->attribute('path_string');

// check if currentUser is allowed to manage the current teamroom
if ( !eZTeamroom::checkTeamroomSubtreeAccess( 'teamroom', 'manage', false, false, $teamroomPath ) ){
    return $Module->handleError( eZError::KERNEL_ACCESS_DENIED, 'kernel' );
}

$http = eZHTTPTool::instance();

if ( $http->hasPostVariable( 'InviteButton' ) )
{
    return $Module->redirectTo( $inviteUrl );
}
elseif ( $http->hasPostVariable( 'RememberInviteButton' ) )
{
    $keys = array_keys ( $http->postVariable( 'RememberInviteButton' ) );
    $userContentObjectID = $keys[0];
    $receiverUserObject = eZUser::fetch( $userContentObjectID );

    if ( $receiverUserObject )
    {
        $hashKeyArray = eZDB::instance()->arrayQuery( 'SELECT hash_key FROM ezuser_accountkey WHERE user_id=' . $userContentObjectID );
        $hash = false;
        if ( is_array( $hashKeyArray ) && count( $hashKeyArray ) == 1 )
        {
            $hash = $hashKeyArray[0]['hash_key'];
        }
        eZTeamroom::sendSinlgeEmail( $receiverUserObject->attribute( 'email' ) , $teamroomNode->attribute( 'object' ), 'remind_member_invited', false, array( 'hash' => $hash ) );
        $messages[] = ezpI18n::tr( 'ezteamroom/membership', 'remind of invitation mail send to %1.', false, array ($receiverUserObject->attribute('email')));
    }
}
elseif ( $http->hasPostVariable( 'StoreRoleChangesButton' ) &&
         $http->hasPostVariable( 'UserRoleMatrix' ) &&
         $http->hasPostVariable( 'SelectedUserRoleMatrix' )   )
{
    $userRoleMatrix = $http->postVariable( 'UserRoleMatrix' );        //old roles
    $selectedMatrix = $http->postVariable( 'SelectedUserRoleMatrix' );//new roles
    $clearCache = false;
    $db   = eZDB::instance();

    foreach ( $userRoleMatrix as $userID => $roleIdList )
    {
        if ( eZTeamroom::assignUserPermissions( $userID, $roleIdList, $selectedMatrix[$userID], $teamroomNode->attribute( 'node_id' ) ) )
        {
            $clearCache = true;
        }
    }
    if ( $clearCache )
    {
        eZContentCacheManager::clearContentCacheIfNeeded( $teamroomID );
        eZUser::cleanupCache();
    }
    $messages[] = ezpI18n::tr( 'ezteamroom/membership', 'Changes have been stored.' );
}

elseif ( $http->hasPostVariable( 'MoveUser' ) )
{
    $keys = array_keys( $http->postVariable( 'MoveUser' ) );
    list( $moveUserID, $moveToGroupID ) = split( '_', $keys[0] );

    $moveUserNode = eZContentObjectTreeNode::fetch( (int)$moveUserID );
    $moveToNode   = eZContentObjectTreeNode::fetch( (int)$moveToGroupID );

    if ( !$moveUserNode || !$moveToNode ){
            $errors[] = ezpI18n::tr( 'ezteamroom/membership', 'Failed to move Member.' );
            eZDebug::writeError( "Failed to move node $moveUserID as child of parent node $moveToGroupID",'teamroom/manage' );
    }else{
        //move node
        if ( !eZContentObjectTreeNodeOperations::move( (int)$moveUserID, (int)$moveToGroupID ) )
        {
            eZDebug::writeError( "Failed to move node $moveUserID as child of parent node $moveToGroupID",'teamroom/manage' );
            $errors[] = ezpI18n::tr( 'ezteamroom/membership', 'Failed to move Member.' );
        }else{
            $messages[] = ezpI18n::tr( 'ezteamroom/membership', 'Selected users have been moved.' );
        }

    }
}

elseif ( $http->hasPostVariable( 'RemoveButton' ) &&
         $http->hasPostVariable( 'RemoveUser' )    )
{
    $removeUser = $http->postVariable( 'RemoveUser' );

    if( is_array( $removeUser ) )
    {
        foreach ( $removeUser as $nodeID )
        {
            $removeNode = eZContentObjectTreeNode::fetch( (int)$nodeID );
            if ( $removeNode )
            {
                $user = eZUser::fetch( $removeNode->attribute( 'contentobject_id' ) );

                eZTeamroom::removeMember( $removeNode , $teamroomNode );
                // send mail notification
                $owner = eZUser::fetch( $teamroomObject->attribute( 'owner_id' ) );
                $params = array( 'owner' => $owner );
                eZTeamroom::sendSinlgeEmail( $user->attribute( 'email' ), $teamroomObject, 'member_removed', false, $params );
            }
        }
        $messages[] = ezpI18n::tr( 'ezteamroom/membership', 'Selected users have been removed.' );
    }
}


$roleList        = eZTeamroom::getTeamroomRoleList();
$userInformation = eZTeamroom::getUserInformation( $teamroomNode, $teamroomPath );
$userList        = $userInformation['userGroupList'];
$userRoleList    = $userInformation['userRoleIDList'];

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// Template

include_once( 'kernel/common/template.php' );
$tpl = templateInit();

$tpl->setVariable( 'from_page', $manageUrl  );
$tpl->setVariable( 'messages', $messages );
$tpl->setVariable( 'errors', $errors );
$tpl->setVariable( 'teamroom', $teamroomNode );
$tpl->setVariable( 'roleList', $roleList );
$tpl->setVariable( 'userList', $userList );
$tpl->setVariable( 'userRoleList', $userRoleList );

$Result = array();
$Result['content'] = $tpl->fetch( 'design:teamroom/manage.tpl' );

$Result['path'] = array(
    array( 'text' => $teamroomNode->attribute( 'name' ),                    'url' => $teamroomNode->attribute( 'url_alias' ) ),
    array( 'text' => ezpI18n::tr( 'ezteamroom/membership', 'Manage Member' ),    'url' => $manageUrl ) );

?>
