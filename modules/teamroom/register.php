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

$Module      = $Params['Module'];
$teamroomID  = $Params['TeamroomID'];
$actionType  = $Module->currentAction();
$registerUrl = 'teamroom/register/'.$teamroomID;

// get the teamroomObject and main_node
if ( !is_numeric( $teamroomID ) ){
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

// check if user is allowed to register
$teamroomSection = $teamroomObject->attribute( 'section_id' );
if ( !eZTeamroom::checkTeamroomSubtreeAccess( 'teamroom', 'register', false, $teamroomSection ) ){
    return $Module->handleError( eZError::KERNEL_ACCESS_DENIED, 'kernel' );
}

// check if user is already member
$user = eZUser::currentUser();
$userID = $user->attribute( 'contentobject_id' );
$userContentObject = $user->attribute('contentobject') ;

$subTreeParams = array( 'Depth'            => 0,
                        'DepthOperator'    => 'eq',
                        'Limitation'       => array(),
                        'ClassFilterType'  => 'include',
                        'ClassFilterArray' => array( 'user_group' )
                        );

$userGroupList = $teamroomNode->subTree( $subTreeParams );
if  ( !count($userGroupList) ){
    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}
$parentNodeIDArray = eZTeamroom::parentNodeIDArray( $userContentObject );
foreach ($userGroupList as $userGroup){
    $memberGroupNodeID = $userGroup->attribute( 'node_id' );;
    if( in_array( $memberGroupNodeID, $parentNodeIDArray ) )
        return $Module->handleError( eZError::KERNEL_ACCESS_DENIED, 'kernel' );
}

$tplfile = 'register.tpl';

if ( $actionType == 'Cancel' )
{
    $Module->redirectTo( $teamroomNode->attribute( 'url_alias') );
}
elseif ( $actionType == 'Register' )
{
    eZDebug::writeDebug( "eZOperationHandler::execute( 'teamroom', 'register', array(  'user_id' => $userID, 'teamroom_id' => $teamroomID, ) )",  __FILE__.':'.__LINE__  );

    $operationResult = eZOperationHandler::execute( 'teamroom', 'register', array(  'teamroom_id' => $teamroomID,
                                                                                        'user_id' => $userID ) );
    eZDebug::writeDebug( $operationResult,  __FILE__.':'.__LINE__.' $operationResult' );
    # STATUS_CONTINUE = 1
    # STATUS_CANCELLED = 2
    # STATUS_HALTED = 3   <-----

    if ( is_array( $operationResult ) && array_key_exists( 'status', $operationResult ) )
    {
        if ( $operationResult['status'] == eZModuleOperationInfo::STATUS_CONTINUE )
        {
            $tplfile = 'register_done.tpl';
        }
        elseif( $operationResult['status'] == eZModuleOperationInfo::STATUS_HALTED )
        {
            $tplfile = 'register_deferred.tpl';
        }
        elseif( $operationResult['status'] == eZModuleOperationInfo::STATUS_CANCELLED)
        {
            if ( isset( $operationResult['redirect_url'] ) )
            {
                return $Module->redirectTo( $operationResult['redirect_url'] );
            }
            else if ( isset( $operationResult['result'] ) )
            {
                $moduleResult = $operationResult['result'];
                $resultContent = false;
                if ( is_array( $moduleResult ) )
                {
                    if ( isset( $moduleResult['content'] ) )
                        $resultContent = $moduleResult['content'];
                }
                else
                {
                    $resultContent = $moduleResult;
                }
                if ( strpos( $resultContent, 'Deffered to cron' ) === 0 )
                {
                    $Result = null;
                }
                else
                {
                    $Result['content'] = $resultContent;
                }
            }
            else
            {
                return $Module->redirectTo( $teamroomNode->attribute( 'url_alias') );
            }
            return;
        }
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// Template
include_once( 'kernel/common/template.php' );

$tpl = templateInit();

$tpl->setVariable( 'from_page', $registerUrl );
$tpl->setVariable( 'teamroom', $teamroomNode );

if (!$Result){
    $Result = array();
    $Result['content'] = $tpl->fetch( 'design:teamroom/'.$tplfile );
}

$Result['path'] = array(
    array( 'text' => $teamroomNode->attribute( 'name') 			, 'url' => $teamroomNode->attribute( 'url_alias') ),
    array( 'text' => ezpI18n::tr( 'ezteamroom/teamroom', 'Register' ), 'url' => 'teamroom/register/' . $teamroomNode->attribute( 'contentobject_id')  ) );

?>
