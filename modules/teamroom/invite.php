<?php
//
// Created on: <2008-03-28 10:49:28 tw>
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

$Module     = $Params['Module'];
$teamroomID = $Params['TeamroomID'];
$actionType = $Module->currentAction();
$manageUrl  = '/teamroom/manage/' . $teamroomID;
$inviteUrl  = '/teamroom/invite/' . $teamroomID;
$errors   = array();
$messages = array();

// get the teamroomObject and main_node
if ( !is_numeric( $teamroomID ) ){
    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}

$classIdentifierMap = eZTeamroom::getClassIdentifierList();
$teamroomObject = eZContentObject::fetch( (int) $teamroomID);
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

// get post-variables
$inviteUserList = array();
$createUserList = array();

$http = eZHTTPTool::instance();

if( $http->hasPostVariable( 'inviteUserList' ) ){
    $inviteUserList = explode( ',' , $http->postVariable( 'inviteUserList' ) );
}
if( $http->hasPostVariable( 'createUserList' ) ){
    $createUserList = explode( ',' , $http->postVariable( 'createUserList' ) );
}

// show userList excluding members of current teamroom
if ( $actionType == 'BrowseUsers' )
{
    $teamroomMemberList = eZTeamroom::getTeamroomMembers($teamroomNode);
    foreach ( $teamroomMemberList as $teamroomMember )
    {
        $nodeList = $teamroomMember->attribute( 'assigned_nodes' );
        foreach ( $nodeList as $node )
        {
            $memberIDList[] = $node->attribute( 'node_id' );
        }
    }
    // redirect to content/browse
    eZContentBrowse::browse( array( 'action_name'           => 'SelectInviteUsers',
                                    'from_page'             => $inviteUrl,
                                    'description_template'  => 'design:teamroom/browse_invite.tpl',
                                    'ignore_nodes_select'   => $memberIDList,
                                    'inviteUserList'        => $inviteUserList,
                                    'inviteUserListString'  => implode( ',', $inviteUserList ),
                                    'createUserList'        => $createUserList,
                                    'createUserListString'  => implode( ',', $createUserList )  ),
                             $Module );
    return;
}
elseif ( $actionType == 'SelectInviteUsers' )
{   //get the result of previous browse operation
    $eZContentBrowseResult = eZContentBrowse::result( 'SelectInviteUsers' );
    eZDebug::writeDebug($eZContentBrowseResult,  __FILE__.':'.__LINE__ .'($eZContentBrowseResult)');
    $inviteUserList = array_merge( $eZContentBrowseResult, $inviteUserList );
    $messages[] = ezpI18n::tr( 'ezteamroom/membership', 'Users were successfully selected' );
}
elseif ( $actionType == 'SearchMail' && $http->hasPostVariable( 'MailAddressList' ) )
{
    // get  the teamrooms member-groups
    $subTreeParams = array( 'Depth'            => 1,
                            'DepthOperator'    => 'eq',
                            'Limitation'       => array(),
                            'ClassFilterType'  => 'include',
                            'ClassFilterArray' => array( 'user_group' )
                            );
    $userGroupList = $teamroomNode->subTree( $subTreeParams );
    if  ( !count($userGroupList) ){
        return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
    }

    $mailAdressList = explode( ',' , $http->postVariable( 'MailAddressList' ) );
    foreach ( $mailAdressList as $mailAddress ){
        $mailAddress = trim( $mailAddress );

        if( $mailAddress ){
            $userList = eZPersistentObject::fetchObjectList( eZUser::definition(),
                                                             null,
                                                             array( 'LOWER( email )' => strtolower( $mailAddress ) )
                                                           );
            if ( count( $userList ) > 0 )
            {
                foreach ( $userList as $user )
                {
                    $userContentObjectID = $user->ContentObjectID;
                    $userContentObject = $user->attribute('contentobject') ;

                    // check if user is already member
                    $parentNodeIDArray = eZTeamroom::parentNodeIDArray( $userContentObject );

                    $isMember = false;
                    foreach ( $userGroupList as $userGroup )
                    {
                        $memberGroupNodeID = $userGroup->attribute( 'node_id' );;
                        if( in_array( $memberGroupNodeID, $parentNodeIDArray ) )
                            $isMember = true;
                    }

                    if ( $isMember )
                    {
                        $errors[] = ezpI18n::tr( 'ezteamroom/membership', 'User is already Member: ' ) . $userContentObject->Name.' ('.$mailAddress.')';
                    }
                    elseif ( in_array ($userContentObjectID , $inviteUserList) )
                    {
                        $messages[] = ezpI18n::tr( 'ezteamroom/membership', 'User already selected: ' ) . $userContentObject->Name.' ('.$mailAddress.')';
                    }
                    else
                    {
                        $inviteUserList[] = $userContentObjectID;
                        $messages[] = ezpI18n::tr( 'ezteamroom/membership', 'User was successfully added: ' ) . $userContentObject->Name.' ('.$mailAddress.')';
                    }
                }
            }else{
                if( !eZMail::validate( $mailAddress ) ){
                    $errors[] = ezpI18n::tr( 'ezteamroom/membership', 'You entered an invalid mail address: ' ) . $mailAddress;
                }else{
                    $errors[] = ezpI18n::tr( 'ezteamroom/membership', 'There is no registered user with that email address: ' ) . $mailAddress .
                                ezpI18n::tr( 'ezteamroom/membership', ' A new account will be created.' ) ;
                    $createUserList[] = $mailAddress;
                }
            }
        }
    }
}
//cancel invitation
elseif ( $actionType == 'ClearInviteList' )
{
    if ( $http->hasPostVariable( 'SelectedExistingUsers' ) )
    {
        $selectedExistingUsers = $http->postVariable( 'SelectedExistingUsers' );
        if ( is_array( $selectedExistingUsers ) && count( $selectedExistingUsers ) > 0 )
        {
            $newInviteUserList = array();
            foreach ( $inviteUserList as $userID )
            {
                if ( !in_array( $userID, $selectedExistingUsers ) )
                {
                    $newInviteUserList[] = $userID;
                }
            }
            $inviteUserList = $newInviteUserList;
        }
    }
    if ( $http->hasPostVariable( 'SelectedInviteUsers' ) )
    {
        $selectedInviteUsers = $http->postVariable( 'SelectedInviteUsers' );
        if ( is_array( $selectedInviteUsers ) && count( $selectedInviteUsers ) > 0 )
        {
            $newCreateUserList = array();
            foreach ( $createUserList as $emailAddress )
            {
                if ( !in_array( $emailAddress, $selectedInviteUsers ) )
                {
                    $newCreateUserList[] = $emailAddress;
                }
            }
            $createUserList = $newCreateUserList;
        }
    }
}

//invite the selected users
elseif ( $actionType == 'Invite' )
{
    $inviteNewUserList = array(); //stores the new userIDs

    if ( count($createUserList) ){

        // Get default placement for new users and check if node exists
        $ini = eZINI::instance();
        $defaultUserPlacementNodeID = (int)$ini->variable( 'UserSettings', 'DefaultUserPlacement' );
        $defaultUserPlacementNode = eZNodeAssignment::fetchByID( $defaultUserPlacementNodeID );
        if (!$defaultUserPlacementNode){
            eZDebug::writeError( ezpI18n::tr( 'ezteamroom/membership', 'The node (%1) specified in [UserSettings].DefaultUserPlacement setting in site.ini does not exist!', null, array( $defaultUserPlacementNodeID ) ) );
            return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
        }
        // create user accounts
        eZDebug::writeDebug( 'start creating user accounts' ,  __FILE__.':'.__LINE__ );
        foreach ( $createUserList as $mailAddress )
        {
            // generate user data (firstname,lastname,password,username)
            $firstname      = ezpI18n::tr( 'ezteamroom/membership', 'New invited user' );
            $lastname       = '( ' . $mailAddress . ' )';
            $passwordLength = $ini->variable( 'UserSettings', 'GeneratePasswordLength' );
            $password       = eZUser::createPassword( $passwordLength );

            // Set username to local part of the mail address
            //$username = substr( $mailAddress, 0, strpos( $mailAddress, '@' ) );
            // Set username to email address to get more unique login names
            $username = $mailAddress;

            // If username exists create new user names by appending random numbers to the username.
            $endless_loop_protection = 0;
            while ( eZUser::fetchByName( $username ) != null
                    && $endless_loop_protection < 30
                  )
            {
                $username = $username . rand( 0, 9 );
                ++$endless_loop_protection;
            }
            if ( $endless_loop_protection == 30 )
            {
                return false;
            }

            // create user ContentObject
            // Get default settings for user creation
            $userCreatorID    = $ini->variable( 'UserSettings', 'UserCreatorID' );
            $defaultSectionID = $ini->variable( 'UserSettings', 'DefaultSectionID' );
            $userClassID      = $ini->variable( 'UserSettings', 'UserClassID' );

            // Initantiate new content class for the user
            $class = eZContentClass::fetch( $userClassID );
            $userContentObject = $class->instantiate( $userCreatorID, $defaultSectionID );

            // Set account information
            $userID = $userContentObject->attribute( 'id' );
            $user = eZUser::fetch( $userID );
            $user->setInformation( $userID, $username, $mailAddress, $password, $password );
            $user->store();

            // Set up attributes of the content class
            $dataMap = $userContentObject->dataMap();

            $firstnameAttribute =& $dataMap['first_name'];
            $firstnameAttribute->setContent( $firstname );
            $firstnameAttribute->setAttribute( 'data_text', $firstname );
            $firstnameAttribute->store();

            $lastnameAttribute =& $dataMap['last_name'];
            $lastnameAttribute->setContent( $lastname );
            $lastnameAttribute->setAttribute( 'data_text', $lastname );
            $lastnameAttribute->store();

            // inactivate user, create activation hash
            // Disable user account
            $userSetting = eZUserSetting::fetch( $userID );
            $userSetting->setAttribute( 'is_enabled', 0 );
            $userSetting->store();

            // Create enable account hash and send it to the newly registered user
            $hash = md5( time() . $userID );
            $UserAccountKey = eZUserAccountKey::createNew( $userID, $hash, time() );
            $UserAccountKey->store();

            // Create nodeAssignment for new user
            $nodeAssignment = eZNodeAssignment::create( array( 'contentobject_id' => $userID,
                                                               'contentobject_version' => 1,
                                                               'parent_node' => $defaultUserPlacementNodeID,
                                                               'is_main' => 1 ) );
            $nodeAssignment->store();

            // publish the new user
            $operationResult = eZOperationHandler::execute( 'content', 'publish', array( 'object_id' => $userID,
                                                                                         'version'   => 1 ) );

            eZDebug::writeDebug( $operationResult ,  __FILE__.':'.__LINE__ .'user created ('.$username.')');
            $inviteNewUserList[] = $userID;

            // send mail notification
            $params = array( 'password' => $password,
                             'hash'     => $hash       );
            eZTeamroom::sendSinlgeEmail( $mailAddress , $teamroomNode->attribute( 'object' ), 'new_user_member_invited' , false, $params );
        }
        $createUserList = array();
    }

    // get default Roles from ini-file
    $teamroomINI  = eZINI::instance( 'teamroom.ini' );
    $defaultRoleIDList = $teamroomINI->variable( 'PermissionSettings', 'TeamroomDefaultRoleList' );
    $roleIDList = $teamroomINI->variable( 'PermissionSettings', 'TeamroomRoleList' );

    //invite users
    eZDebug::writeDebug( 'start inviting' ,  __FILE__.':'.__LINE__ );

    $db = eZDB::instance();
    $invitationList = array_merge ( $inviteUserList, $inviteNewUserList );
    foreach( $invitationList as $userID )
    {
        // add new member to the teamrooms member-group
        eZTeamroom::addMember( $teamroomID , $userID );

        // assign default roles to the new user (limited to the teamroom)
        foreach ( $defaultRoleIDList as $roleID )
        {
            if ( in_array( $roleID, $roleIDList ) )
            {
                $db->begin();
                $role = eZRole::fetch( $roleID );
                $role->assignToUser( $userID, 'subtree', $teamroomNode->attribute( 'node_id' ) );
                $db->commit();
            }
        }
    }
    // send mail notification (already send to new users)
    foreach( $inviteUserList as $userID )
    {
        $receiverUserObject = eZUser::fetch( $userID );
        eZTeamroom::sendSinlgeEmail( $receiverUserObject->attribute( 'email' ), $teamroomNode->attribute( 'object' ), 'member_invited' );
        eZContentCacheManager::clearContentCacheIfNeeded($userID);
    }
    $inviteUserList = array();

    // clear cache eZContentCacheManager::clearContentCacheIfNeeded($userID);
    eZContentCacheManager::clearContentCacheIfNeeded($teamroomID);
    eZUser::cleanupCache();

    eZDebug::writeDebug( 'end inviting' ,  __FILE__.':'.__LINE__ );
    //$messages[] = ezpI18n::tr( 'ezteamroom/membership', 'Users invited.' );
    return $Module->redirectTo( $manageUrl );

}
elseif ( $actionType == 'Cancel' ){
    if ( $http->hasPostVariable( 'RedirectIfDiscarded' ) ){
        $Module->redirectTo( $http->postVariable( 'RedirectIfDiscarded' ) );
    }
    if ( $http->hasPostVariable( 'RedirectURIAfterPublish' ) ){
        $Module->redirectTo( $http->postVariable( 'RedirectURIAfterPublish' ) );
    }
    $Module->redirectTo( $manageUrl );
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// Template

include_once( 'kernel/common/template.php' );
$tpl = templateInit();

$tpl->setVariable( 'from_page', $inviteUrl );
$tpl->setVariable( 'errors'  , $errors );
$tpl->setVariable( 'messages', $messages );
$tpl->setVariable( 'inviteUserList', $inviteUserList );
$tpl->setVariable( 'inviteUserListString', implode( ',', $inviteUserList ) );
$tpl->setVariable( 'createUserList', $createUserList );
$tpl->setVariable( 'createUserListString', implode( ',', $createUserList ) );


$Result = array();
$Result['content'] = $tpl->fetch( 'design:teamroom/invite.tpl' );

$Result['path'] = array(
    array( 'text' => $teamroomNode->attribute( 'name' ),                    'url' => $teamroomNode->attribute( 'url_alias' ) ),
    array( 'text' => ezpI18n::tr( 'ezteamroom/membership', 'Manage Member' ),    'url' => $manageUrl ),
    array( 'text' => ezpI18n::tr( 'ezteamroom/membership', 'Invite' ),           'url' => $inviteUrl ) );

?>
