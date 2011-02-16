<?php
//
// Created on: <2007-11-28 16:16:21 dis>
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

class eZSetTeamroomType extends eZWorkflowEventType
{
    function eZSetTeamroomType()
    {
        $this->eZWorkflowEventType( 'ezsetteamroom', ezpI18n::tr( 'ezteamroom/setteamroom', 'Set the current Teamroom' ) );
        $this->setTriggerTypes( array( 'content' => array( 'read' => array( 'before' ) ) ) );
    }

    /*
     \reimp
    */
    function attributeDecoder( $event, $attr )
    {

    }

    /*
     \reimp
    */
    function typeFunctionalAttributes()
    {
        return array();
    }

    /*
     \reimp
    */
    function fetchHTTPInput( $http, $base, $event )
    {
    }

    /*
     \reimp
    */
    function customWorkflowEventHTTPAction( $http, $action, $workflowEvent )
    {

    }

    /*
     \reimp
    */
    function execute( $process, $event )
    {
        $parameters = $process->attribute( 'parameter_list' );
        $http = eZHTTPTool::instance();

        if ( !array_key_exists( 'node_id', $parameters ) )
        {
            return eZWorkflowType::STATUS_ACCEPTED;
        }

        // We are not in a teamroom.
        $node = eZContentObjectTreeNode::fetch( $parameters['node_id'], false, false );
        if ( $node['depth'] <= 2 )
        {
            return eZWorkflowType::STATUS_ACCEPTED;
        }

        // Teamroom is set in a ealier session
        if ( $http->hasSessionVariable( 'CurrentTeamroom' ) && $http->hasSessionVariable( 'CurrentTeamroomPath' ) )
        {
            $pathString = $node['path_string'];
            $teamroomPath = $http->sessionVariable( 'CurrentTeamroomPath' );
            if ( strpos( $pathString, $teamroomPath) !== false )
            {
                return eZWorkflowType::STATUS_ACCEPTED;
            }
        }
        $classIdentifierMap = eZTeamroom::getClassIdentifierList();
        // We need to go recursivly through the tree and check if the
        // current node is a teamroom
        do
        {
            if ( array_key_exists( 'class_identifier', $node ) && $node['class_identifier'] == $classIdentifierMap['teamroom'] )
            {
                $http->setSessionVariable( 'CurrentTeamroomPath', $node['path_string'] );
                $http->setSessionVariable( 'CurrentTeamroom',     $node['node_id'] );
                return eZWorkflowType::STATUS_ACCEPTED;
            }
            $node = eZContentObjectTreeNode::fetch( $node['parent_node_id'], false, false );
        } while ( $node['parent_node_id'] != 1 );

        return eZWorkflowType::STATUS_ACCEPTED;
    }

}

eZWorkflowEventType::registerEventType( 'ezsetteamroom', 'eZSetTeamroomType' );

?>
