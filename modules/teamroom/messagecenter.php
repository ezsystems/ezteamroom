<?php
//
// Created on: <2009-05-13 10:06:19 ab>
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

require_once( 'autoload.php' );
require_once( 'kernel/common/template.php' );

$http             = eZHTTPTool::instance();
$tpl              = templateInit();
$template         = 'design:teamroom/messagecenter.tpl';
$navigationPart   = 'ezteamroomnavigationpart';
$uiContext        = 'view';
$scriptMode       = false;
$teamroomObjectID = -1;
$processName      = '';
$processID        = -1;
$showMemberList   = true;
$url              = '/teamroom/messagecenter';
$path             = array( array( 'text' => ezpI18n::tr( 'ezteamroom/messagecenter', 'Message Center' ),
                                  'url'  => null
                                )
                         );

// Are we executed by a javascript request using ajax?

if ( isset( $viewParameters['scriptmode'] ) && $viewParameters['scriptmode'] == 1 )
{
    $scriptMode = true;
}

// Check input parameters and access rights

if ( isset( $Params['TeamroomObjectID'] ) && is_numeric( $teamroomObjectID ) )
{
    $teamroomObjectID = $Params['TeamroomObjectID'];
}

$teamroomContentObject = eZContentObject::fetch( (int)$teamroomObjectID );
$teamroomNodeObject    = $teamroomContentObject->attribute( 'main_node' );
$teamroomPathString    = $teamroomNodeObject->attribute('path_string');

if ( !$teamroomContentObject || !$teamroomNodeObject )
{
    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}

if ( !eZTeamroom::checkTeamroomSubtreeAccess( 'teamroom', 'messagecenter', false, false, $teamroomPathString ) )
{
    return $Module->handleError( eZError::KERNEL_ACCESS_DENIED, 'kernel' );
}

$url .= '/' . $teamroomObjectID;

if ( isset( $Params['ProcessName'] ) )
{
    $processName = $Params['ProcessName'];
    $url .= '/' . $processName;
}

if ( isset( $Params['ProcessID'] ) )
{
    $processID = $Params['ProcessID'];
    $url .= '/' . $processID;
}

$userInformation = eZTeamroom::getUserInformation( $teamroomNodeObject, $teamroomPathString );

for ( $i = 19000; $i < 19500; ++$i )
{
    if ( $i < 19200 )
    {
    $userInformation['userGroupList']['192']['user'][] = $userInformation['userGroupList']['192']['user'][0];
    }
    $userInformation['userGroupList']['191']['user'][] = $userInformation['userGroupList']['191']['user'][0];
}
$tpl->setVariable( 'user_information', $userInformation );
$tpl->setVariable( 'url',              $url );
$tpl->setVariable( 'process_name',     $processName );
$tpl->setVariable( 'process_id',       $processID );

switch ( $processName ) // We action has been requested?
{
    case 'send':
    {
        if ( $processID > 0 )
        {
            $showMemberList = false;
        }
        if ( $http->hasPostVariable( 'SendMessageButton' ) )
        {
            $receiverEmailList = array();
            $groupIDList       = array_keys( $userInformation['userGroupList'] );
            foreach ( $groupIDList as $groupID )
            {
                if ( $http->hasPostVariable( 'userlist_' . $groupID ) )
                {
                    $receiverEmailList = array_merge( $http->postVariable( 'userlist_' . $groupID ), $receiverEmailList );
                }
            }
            if ( $http->hasPostVariable( 'subject' ) &&
                 $http->hasPostVariable( 'body' )
               )
            {
                $parameters = array( 'subject' => trim( $http->postVariable( 'subject' ) ),
                                     'body'    => trim( $http->postVariable( 'body' ) )
                                   );
                foreach ( $receiverEmailList as $receiverEmail )
                {
                    if ( !eZTeamroom::sendSinlgeEmail( $receiverEmail, $teamroomContentObject, 'messagecenter', false, $parameters ) )
                    {
                        eZDebug::writeDebug( 'Failed to send email to ' . $receiverEmail, '/teamroom/messagecenter' );
                    }
                }

            }
        }
    }
    break;
    case '':
    {
    }
    break;
    default:
    {
        return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
    }
    break;
}

$tpl->setVariable( 'show_member_list', $showMemberList );

$res = eZTemplateDesignResource::instance();
$res->setKeys( array( array( 'navigation_part_identifier', $navigationPart ),
                      array( 'ui_context',                 $uiContext ),
                      array( 'scriptmode',                 $scriptMode ),
                      array( 'module',                     'teamroom' )
                    )
             );

$Result            = array();
$Result['content'] = $tpl->fetch( $template );

if ( $scriptMode )
{
    echo $Result['content'];
    eZDB::checkTransactionCounter();
    eZExecution::cleanExit();
}
else
{
    $Result['pagelayout']    = true;
}

$Result['navigation_part'] = $navigationPart;
$Result['ui_context']      = $uiContext;
$Result['pagelayout']      = true;
$Result['path']            = $path;

?>
