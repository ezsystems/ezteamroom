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

$Module     = $Params['Module'];
$teamroomID = $Params['TeamroomID'];

// get the teamroomObject and main_node
if ( !is_numeric( $teamroomID ) ){
    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}

$classIdentifierMap = eZTeamroom::getClassIdentifierList();
$teamroomObject     = eZContentObject::fetch( (int)$teamroomID );
if ( !is_object( $teamroomObject ) ||  $teamroomObject->attribute( 'class_identifier' ) != $classIdentifierMap['teamroom'] )
{
    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}
$teamroomNode       = $teamroomObject->attribute( 'main_node' );
if ( !is_object( $teamroomNode ) || $teamroomNode->attribute( 'class_identifier' ) != $classIdentifierMap['teamroom'] )
{
    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}
$teamroomPathString = $teamroomNode->attribute( 'path_string' );


//get the userNode assigned to teamroom
$currentUser = eZUser::currentUser();
$userContentObject = $currentUser->contentObject();

if ( !$userContentObject ){
    return $Module->handleError( eZError::KERNEL_MODULE_NOT_FOUND, 'kernel' );
}
$userNodeList = $userContentObject->attribute( 'assigned_nodes' );
$userNode = false;
foreach ( $userNodeList as $node )
{
    $pathString = $node->attribute( 'path_string' );
    if ( strpos( $pathString, $teamroomPathString) !== false )
    {
        $userNode = $node;
        break;
    }
}

$currentAction = $Module->currentAction();

if ( $currentAction == 'Cancel' )
{
    $Module->redirectTo( '/content/view/full/' . $teamroomNode->attribute( 'node_id' ) );
}
elseif ( $currentAction == 'Resign' )
{
    if ( $userNode )
    {
        eZTeamroom::removeMember( $userNode , $teamroomNode);

        // send mail notification
        $owner = eZUser::fetch( $teamroomObject->attribute( 'owner_id' ) );
        $params = array( 'member' => $currentUser, 'owner' => $owner );
        eZTeamroom::sendSinlgeEmail( $owner->attribute( 'email' ), $teamroomObject, 'member_resign', false, $params );
        eZTeamroom::sendSinlgeEmail( $currentUser->attribute( 'email' ), $teamroomObject, 'member_resign_done', false, $params );
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// Template


include_once( 'kernel/common/template.php' );
$tpl = templateInit();
$tpl->setVariable( 'teamroom', $teamroomNode );
$tpl->setVariable( 'from_page', '/teamroom/resign/'.$teamroomNode->attribute( 'contentobject_id').'/'.$userNode->attribute( 'contentobject_id' ));

$Result = array();
$tplfile = ( $currentAction == 'Resign' )? 'resign_done.tpl' : 'resign.tpl';
$Result['content'] = $tpl->fetch( 'design:teamroom/'.$tplfile );

$Result['path'] = array(
    array( 'text' => $teamroomNode->attribute( 'name' ),                    'url' => $teamroomNode->attribute( 'url_alias') ),
    array( 'text' => ezpI18n::tr( 'ezteamroom/membership', 'Resign' ),           'url' => 'teamroom/resign/'.$teamroomID  ) );

?>
