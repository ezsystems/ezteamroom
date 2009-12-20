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

$OperationList = array();

$OperationList['register'] = array(
    'name'                => 'register',
    'default_call_method' => array( 'include_file' => 'extension/ezteamroom/modules/teamroom/teamroomoperationcollection.php',
                                    'class'        => 'teamroomOperationCollection'
                                  ),
    'parameter_type'      => 'standard',
    'parameters'          => array( array( 'name'     => 'teamroom_id',
                                           'type'     => 'integer',
                                           'required' => true
                                         ),
                                    array( 'name'     => 'user_id',
                                           'type'     => 'integer',
                                           'required' => true
                                         )
                                  ),
    'body'                => array( array( 'type' => 'trigger',
                                           'name' => 'pre_register',
                                           'keys' => array( 'teamroom_id', 'user_id' )
                                         ),
                                    array( 'type'      => 'method',
                                           'name'      => 'add-Member',
                                           'frequency' => 'once',
                                           'method'    => 'addMember'
                                         ),
                                    array( 'type'      => 'method',
                                           'name'      => 'send-Email',
                                           'frequency' => 'once',
                                           'method'    => 'sendEmail',
                                         ),
                                    array( 'type' => 'trigger',
                                           'name' => 'post_register',
                                           'keys' => array( 'teamroom_id', 'user_id' )
                                         )
                                  )
);

?>
