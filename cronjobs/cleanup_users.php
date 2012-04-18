<?php
//
// ## BEGIN COPYRIGHT, LICENSE AND WARRANTY NOTICE ##
// SOFTWARE NAME: eZ XMP
// SOFTWARE RELEASE: 1.4.0
// COPYRIGHT NOTICE: Copyright (C) 1999-2012 eZ Systems AS.
// SOFTWARE LICENSE: eZ Business Use License Agreement Version 2.0
// NOTICE: >
//  This source file is part of the eZ Publish CMS and is
//  licensed under the terms and conditions of the eZ Business User
//  License v2.0 (eZ BUL).
//
//  A copy of the eZ BUL was included with the software. If the
//  license is missing, request a copy of the license via email
//  at license@ez.no or via postal mail at
// 	Attn: Licensing Dept. eZ Systems AS, Klostergata 30, N-3732 Skien, Norway
//
//  IMPORTANT: THE SOFTWARE IS LICENSED, NOT SOLD. ADDITIONALLY, THE
//  SOFTWARE IS LICENSED "AS IS," WITHOUT ANY WARRANTIES WHATSOEVER.
//  READ THE eZ BUL BEFORE USING, INSTALLING OR MODIFYING THE SOFTWARE.

// ## END COPYRIGHT, LICENSE AND WARRANTY NOTICE ##
//

require_once( 'autoload.php' );

define( 'LIMIT', 2 ); // limit in weeks 

$cli = eZCLI::instance();

$cli->output( "Removing old users" );

// PSEUDO:
// Cronjob: DELETE useres WHERE creation_date < n weeks from now AND activated no;

?>
