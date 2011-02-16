<?php
//
// Created on: <2009-08-31 17:28:31 dn>
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

// Eventtype to create Collaboration Item for MemberRegistration

class eZApproveMemberRegistrationType extends eZWorkflowEventType
{
    const COLLABORATION_NOT_CREATED = 0;
    const COLLABORATION_CREATED = 1;

    function eZApproveMemberRegistrationType()
    {
        $this->eZWorkflowEventType( 'ezapprovememberregistration', ezpI18n::tr( 'ezteamroom/collaboration', 'Approve teamroom membership' ) );
        $this->setTriggerTypes( array( 'teamroom' => array( 'register' => array( 'before' ) ) ) );
    }

    function execute( $process, $event )
    {
        $parameters = $process->attribute( 'parameter_list' );
        eZDebug::writeDebug( $parameters,  __FILE__.':'.__LINE__ .'($process->attribute( \'parameter_list\' ))' );

        $teamroomID = $parameters['teamroom_id'];
        $userID     = $parameters['user_id'];

        // no approval needed for public teamrooms
        $classIdentifierMap = eZTeamroom::getClassIdentifierList();
        $teamroomObject     = eZContentObject::fetch( (int) $teamroomID);
        if ( !is_object( $teamroomObject ) ||  $teamroomObject->attribute( 'class_identifier' ) != $classIdentifierMap['teamroom'] )
        {
            return eZWorkflowType::STATUS_WORKFLOW_CANCELLED;
        }
        $data_map = $teamroomObject->attribute('data_map');
        $attributeContent = $data_map['access_type']->content();
        $accessValue      = $attributeContent[0];
        if ( $accessValue == 'public' )
        {
            $teamroomMainNode = $teamroomObject->attribute( 'main_node' );
            if ( is_object( $teamroomMainNode ) )
            {
                $teamroomMainNodeID = $teamroomMainNode->attribute( 'node_id' );
                $roleIDList    = eZTeamroom::getTeamroomRoleIDList();
                $oldRoleIdList = array();
                $newRoleIdList = array();
                foreach ( $roleIDList as $roleID )
                {
                    $oldRoleIdList[$roleID] = 'no';
                    $newRoleIdList[$roleID] = 'yes';
                }
                if ( eZTeamroom::assignUserPermissions( $userID, $oldRoleIdList, $newRoleIdList, $teamroomMainNodeID ) )
                {
                    eZContentCacheManager::clearContentCacheIfNeeded( $teamroomID );
                    eZUser::cleanupCache();
                }
            }
            else
            {
                eZDebug::writeWarning( 'Failed to fetch main node of teamroom with ID ' . $teamroomID, __METHOD__ );
            }
            return eZWorkflowType::STATUS_ACCEPTED;
        }

        // get collaborationID belongs to this workflow
        $collaborationID = false;
        $db = eZDb::instance();
        $taskResult = $db->arrayQuery( 'SELECT workflow_process_id, collaboration_id '.
                                       'FROM ezapprove_items '.
                                       'WHERE workflow_process_id = ' . $process->attribute( 'id' )  );
        if ( count( $taskResult ) > 0 )
        {
            $collaborationID = $taskResult[0]['collaboration_id'];
        }

        eZDebug::writeDebug($process->attribute( 'event_state') , __FILE__.':'.__LINE__.' $process->attribute( \'event_state\')' );

        // if no collaboration exists, create one, set eventstate=created and let the cronjob process wf again
        if ( $collaborationID === false )
        {
            $this->createApproveMemberRegistrationCollaboration( $process, $event, $teamroomID, $userID );
            $this->setInformation( "We are going to create member-registration-approval" );
            $process->setAttribute( 'event_state', eZApproveMemberRegistrationType::COLLABORATION_CREATED );
            $process->store();
            return eZWorkflowType::STATUS_DEFERRED_TO_CRON_REPEAT;
        }
        else if ( $process->attribute( 'event_state') == eZApproveMemberRegistrationType::COLLABORATION_NOT_CREATED )
        {
            eZApproveMemberRegistrationCollaborationHandler::activateApproval( $collaborationID );
            $process->setAttribute( 'event_state', eZApproveMemberRegistrationType::COLLABORATION_CREATED );
            $process->store();
            return eZWorkflowType::STATUS_DEFERRED_TO_CRON_REPEAT;
        }
        else //eZApproveMemberRegistrationType::COLLABORATION_CREATED
        {
            $this->setInformation( "we are checking approval now" );
            return $this->checkApproveMemberRegistrationCollaboration(  $process, $event, $collaborationID );
        }
    }

    function createApproveMemberRegistrationCollaboration( $process, $event, $teamroomID, $userID )
    {
        $collaborationItem = eZApproveMemberRegistrationCollaborationHandler::createApproval( $teamroomID, $userID );
        $db = eZDB::instance();
        $db->query( 'INSERT INTO ezapprove_items( workflow_process_id, collaboration_id )
                       VALUES(' . $process->attribute( 'id' ) . ',' . $collaborationItem->attribute( 'id' ) . ' ) ' );
    }

    function checkApproveMemberRegistrationCollaboration( $process, $event, $collaborationID )
    {
        $approvalStatus = eZApproveMemberRegistrationCollaborationHandler::checkApproval( $collaborationID );
        eZDebug::writeDebug( $approvalStatus, __FILE__.':'.__LINE__.' checkApproveMemberRegistrationCollaboration()...$approvalStatus' );

        if     ( $approvalStatus == eZApproveMemberRegistrationCollaborationHandler::STATUS_WAITING )
        {
            $status = eZWorkflowType::STATUS_DEFERRED_TO_CRON_REPEAT;
        }
        elseif ( $approvalStatus == eZApproveMemberRegistrationCollaborationHandler::STATUS_ACCEPTED )
        {
            $status = eZWorkflowType::STATUS_ACCEPTED;
        }
        elseif ( $approvalStatus == eZApproveMemberRegistrationCollaborationHandler::STATUS_DENIED )
        {
            $status = eZWorkflowType::STATUS_WORKFLOW_CANCELLED;
        }
        else
        {
            $status = eZWorkflowType::STATUS_WORKFLOW_CANCELLED;
        }

        if ( $approvalStatus != eZApproveMemberRegistrationCollaborationHandler::STATUS_WAITING )
        {
            $db = eZDB::instance();
            $db->query( 'DELETE FROM ezapprove_items WHERE workflow_process_id = ' . $process->attribute( 'id' )  );
        }
        return $status;
    }

}

eZWorkflowEventType::registerEventType( 'ezapprovememberregistration', 'eZApproveMemberRegistrationType' );

?>
