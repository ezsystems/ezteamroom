<?php
/**
 * File containing the filelist module definition
 *
 * @copyright Copyright (C) 1999-2010 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPL v2
 * @version //autogentag//
 * @package eZTeamroom
 */

$Module = array( 'name' => 'Object attribute changer',
                 'variable_params' => true );


$ViewList['set'] = array(
    'functions' => array( 'modify' ),
    'script' => 'setattribute.php',
    'params' => array( 'Object', 'Key', 'Value' ) );


$FunctionList = array( 'modify' => array() );

?>
