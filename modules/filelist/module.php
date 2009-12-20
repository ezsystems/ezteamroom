<?php
//
// ## BEGIN COPYRIGHT, LICENSE AND WARRANTY NOTICE ##
// SOFTWARE NAME: eZ publish teamroom extension
// SOFTWARE RELEASE: 0.x
// COPYRIGHT NOTICE: Copyright (C) 2006-2007 Kristof Coomans <http://blog.kristofcoomans.be>
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
// ## END COPYRIGHT, LICENSE AND WARRANTY NOTICE ##
//

$Module = array( 'name' => 'File list management',
                 'variable_params' => true );


$ViewList['set'] = array(
    'functions' => array( 'modify' ),
    'script' => 'set.php',
    'params' => array( 'File', 'Key', 'Value' ) );


$FunctionList = array();
$FunctionList['modify'] = array();

?>
