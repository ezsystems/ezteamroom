<?php
//
// Created on: <2007-11-23 22:05:03 dis>
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

/* Module configuration */

$Module = array( 'name'            => 'Teamroom management',
                 'variable_params' => true
               );

/* View configuration */

$ViewList['manage'] = array(
    'functions'    => array( 'manage' ),
    'script'       => 'manage.php',
    'params'       => array( 'TeamroomID' )
);

$ViewList['invite'] = array(
    'functions'               => array( 'manage' ),
    'script'                  => 'invite.php',
    'default_navigation_part' => 'ezcontentnavigationpart',
    'params'                  => array( 'TeamroomID' ),
    'single_post_actions'     => array(
                                    'BrowseUsersButton'  		=> 'BrowseUsers',
                                    	'SelectInviteUsersButton'   => 'SelectInviteUsers',
                                    	'BrowseCancelButton'        => 'BrowseCancel',
                                    'InviteButton'              => 'Invite',
                                    'ClearInviteListButton'     => 'ClearInviteList',
                                    'SearchMailButton'          => 'SearchMail',
                                    'CancelButton'              => 'Cancel'   )
);

$ViewList['resign'] = array(
    'functions'           => array( 'resign' ),
    'script'              => 'resign.php',
    'params'              => array( 'TeamroomID' ),
    'single_post_actions' => array( 'ResignButton' => 'Resign',
                                    'CancelButton' => 'Cancel'
                                  )
);

$ViewList['register'] = array(
    'script'                  => 'register.php',
    'default_navigation_part' => 'ezcontentnavigationpart',
    'functions'               => array( 'register' ),
    'params'                  => array( 'TeamroomID' ),
    'single_post_actions'     => array( 'RegisterButton' => 'Register',
                                        'CancelButton'   => 'Cancel'
                                      )
);

$ViewList['bookmark'] = array(
    'functions' => array( 'bookmark' ),
    'script'    => 'bookmark.php',
    'params'    => array( )
);

$ViewList['messagecenter'] = array(
    'functions'               => array( 'messagecenter' ),
    'script'                  => 'messagecenter.php',
    'params'                  => array( 'TeamroomObjectID', 'ProcessName', 'ProcessID' ),
    'default_navigation_part' => 'ezteamroomnavigationpart',
    'ui_context'              => 'view'
);


/* Limitation configuration */
$SectionID = array(
    'name'      => 'Section',
    'values'    => array(),
    'path'      => 'classes/',
    'file'      => 'ezsection.php',
    'class'     => 'eZSection',
    'function'  => 'fetchList',
    'parameter' => array( false )
);

$FunctionList                  = array();
$FunctionList['messagecenter'] = array();
$FunctionList['manageroles']   = array();
$FunctionList['invite']        = array();
$FunctionList['manage']        = array();
$FunctionList['resign']        = array();
$FunctionList['bookmark']      = array();
$FunctionList['register']      = array( 'Section' => $SectionID );
$FunctionList['create']        = array( ); // Dummy, does not really check the access of the teamroom. Introduced by dis

?>
