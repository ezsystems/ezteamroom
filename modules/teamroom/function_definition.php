<?php
//
// Created on: <2008-10-13 08:55:00 dis>
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

$FunctionList = array();

$FunctionList['has_access_to'] = array( 'name' => 'has_access_to',
                                        'operation_types' => array(),
                                        'call_method' => array( 'class' => 'eZTeamroomFunctionCollection',
                                                                'method' => 'hasAccessTo' ),
                                        'parameter_type' => 'standard',
                                        'parameters' => array( array( 'name' => 'module',
                                                                      'type' => 'string',
                                                                      'required' => true ),
                                                               array( 'name' => 'function',
                                                                      'type' => 'string',
                                                                      'required' => true ),
                                                               array( 'name' => 'user_id',
                                                                      'type' => 'integer',
                                                                      'required' => false ),
                                                               array( 'name' => 'section',
                                                                      'type' => 'integer',
                                                                      'required' => false ),
                                                               array( 'name' => 'subtree',
                                                                      'type' => 'integer',
                                                                      'required' => false ) ) );

?>
