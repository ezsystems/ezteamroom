<?php
//
// Created on: <2008-10-17 14:05:33 ab>
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
require_once( 'Base/src/base.php' );

/*function __autoload( $className )
{
    ezcBase::autoload( $className );
}*/
eZTeamroom::investigateMailAccounts();
return;

$pop3 = new ezcMailPop3Transport( 'pop.gmx.de', null, array() );
$pop3->authenticate( 'apost1@gmx.de', 'Yiezee5v' );

$parser = new ezcMailParser();
$messages = $pop3->listMessages();
foreach ( $messages as $messageNr => $size )
{
    $set     = new ezcMailVariableSet( $pop3->top( $messageNr ) );
    $mailSet = $parser->parseMail( $set );
    $mail    = $mailSet[0];
    if ( preg_match( "/.?Teamroom '([^']*)' \(([0-9]+)\)/", $mail->to[0], $treffer ) )
    {
        if ( isset( $treffer[2] ) ) // by ID
        {
        }
        else if ( isset( $treffer[1] ) ) // by name
        {
        }
        else
        {
            eZDebug::writeWarning( 'No teamroom name or ID found in receiver information ' .  $mail->to[0] );
        }
    }
    else
    {
        eZDebug::writeDebug( 'Skipped email with receiver ' . $mail->to[0] );
    }
}

$pop3->disconnect();

?>
