<?php
/**
 * File containing the filelist module definition
 *
 * @copyright Copyright (C) 1999-2011 eZ Systems AS. All rights reserved.
 * @license http://ez.no/eZPublish/Licenses/eZ-Business-Use-License-Agreement-eZ-BUL-Version-2.0 eZ Business Use License Agreement Version 2.0
 * @version 1.4.0
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
