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

require_once( 'autoload.php');

class teamroomOperationCollection
{
    function addMember( $teamroomID, $userID )
    {
        eZDebug::writeDebug( "addMember( $teamroomID, $userID )", __FILE__.':'.__LINE__. ' ' . __METHOD__ );

        if ( eZTeamroom::addMember( $teamroomID, $userID ) )
        {
            return array( 'status' => eZModuleOperationInfo::STATUS_CONTINUE );
        }
        else
        {
            return array( 'status' => eZModuleOperationInfo::STATUS_CANCELLED );
        }
    }

    function sendEmail( $teamroomID, $userID )
    {
        eZDebug::writeDebug( "sendEmail( $teamroomID, $userID )", __FILE__.':'.__LINE__. ' ' . __METHOD__ );

        $userObject = eZUser::fetch( $userID );
        if ( !is_object( $userObject ) )
        {
            eZDebug::writeWarning( "Failed to fetch user. Can not send email.", __FILE__.':'.__LINE__. ' ' . __METHOD__ );
            return array( 'status' => eZModuleOperationInfo::STATUS_CONTINUE );
        }
        $classIdentifierMap = eZTeamroom::getClassIdentifierList();
        $teamroomObject     = eZContentObject::fetch( $teamroomID);
        if ( !is_object( $teamroomObject ) ||  $teamroomObject->attribute( 'class_identifier' ) != $classIdentifierMap['teamroom'] )
        {
            return array( 'status' => eZModuleOperationInfo::STATUS_CONTINUE );
        }

        eZTeamroom::sendSinlgeEmail( $userObject->attribute( 'email' ), $teamroomObject, 'memberregistration_approved' );

        return array( 'status' => eZModuleOperationInfo::STATUS_CONTINUE );
    }

}

?>
