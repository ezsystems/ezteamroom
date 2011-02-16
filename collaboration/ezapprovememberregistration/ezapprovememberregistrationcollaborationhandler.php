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

/*! \file ezapprovememberregistrationcollaborationhandler.php
  \class eZApproveMemberRegistrationCollaborationHandler
  \brief Handles member-registration-approval communication using the collaboration system

  - data_int1 - The teamroom content object ID
  - data_int2 - The user content object ID
  - data_int3 - The status of the approval, see defines.
*/

#include_once( 'kernel/common/i18n.php' );
require_once( 'autoload.php' );

class eZApproveMemberRegistrationCollaborationHandler extends eZCollaborationItemHandler
{
    const STATUS_WAITING = 0;  // Default status, no approval decision has been made
    const STATUS_ACCEPTED = 1; // The member registration was approved
    const STATUS_DENIED = 2;   // The member registration was denied

    const MESSAGE_TYPE_APPROVEMEMBERREGISTRATION = 1;

    function eZApproveMemberRegistrationCollaborationHandler()
    {
        $this->eZCollaborationItemHandler( 'ezapprovememberregistration',
                                           ezpI18n::tr( 'ezteamroom/teamroom', 'Approve teamroom membership' ),
                                           array( 'use-messages' => true,
                                                  'notification-types' => true,
                                                  'notification-collection-handling' => eZCollaborationItemHandler::NOTIFICATION_COLLECTION_PER_PARTICIPATION_ROLE ) );

    }

    function title( $collaborationItem )
    {
        return ezpI18n::tr( 'ezteamroom/teamroom', 'approve member registration' );
    }

    function content( $collaborationItem )
    {
        $content = array( 'teamroom_id'     => $collaborationItem->attribute( 'data_int1' ),
                          'user_id'         => $collaborationItem->attribute( 'data_int2' ),
                          'approval_status' => $collaborationItem->attribute( 'data_int3' ) );
        return $content;
    }

    function notificationParticipantTemplate( $participantRole )
    {
        if ( $participantRole == eZCollaborationItemParticipantLink::ROLE_APPROVER )
        {
            return 'approver.tpl';
        }
        else if ( $participantRole == eZCollaborationItemParticipantLink::ROLE_AUTHOR )
        {
            return 'author.tpl';
        }
        else
        {
            return false;
        }
    }

    /*
      \reimp
      Updates the last_read time of the participant link
    */
    function readItem( $collaborationItem, $viewMode = false )
    {
        $collaborationItem->setLastRead();
    }

    /*
     \reimp
     \return the number of messages for the approve item.
    */
    function messageCount( $collaborationItem )
    {
        return eZCollaborationItemMessageLink::fetchItemCount( array( 'item_id' => $collaborationItem->attribute( 'id' ) ) );
    }

    /*!
     \reimp
     \return the number of unread messages for the approve item.
    */
    function unreadMessageCount( $collaborationItem )
    {
        $lastRead = 0;
        $status = $collaborationItem->attribute( 'user_status' );
        if ( $status )
            $lastRead = $status->attribute( 'last_read' );
        return eZCollaborationItemMessageLink::fetchItemCount( array( 'item_id' => $collaborationItem->attribute( 'id' ),
                                                                      'conditions' => array( 'modified' => array( '>', $lastRead ) ) ) );
    }

    /*!
     \static
     \return the status of the approval collaboration item \a $approvalID.
    */
    static function checkApproval( $approvalID )
    {
        $collaborationItem = eZCollaborationItem::fetch( $approvalID );
        if ( $collaborationItem !== null )
        {
            return $collaborationItem->attribute( 'data_int3' );
        }
        return false;
    }

    /*!
     \static
     \return makes sure the approval item is activated for all participants \a $approvalID.
    */
    static function activateApproval( $approvalID )
    {
        $collaborationItem = eZCollaborationItem::fetch( $approvalID );
        if ( $collaborationItem !== null )
        {
            $collaborationItem->setAttribute( 'data_int3', self::STATUS_WAITING );
            $collaborationItem->setAttribute( 'status', eZCollaborationItem::STATUS_ACTIVE );
            $timestamp = time();
            $collaborationItem->setAttribute( 'modified', $timestamp );
            $collaborationItem->store();
            $participantList = eZCollaborationItemParticipantLink::fetchParticipantList( array( 'item_id' => $approvalID ) );
            foreach( $participantList as $participantLink )
            {
                $collaborationItem->setIsActive( true, $participantLink->attribute( 'participant_id' ) );
            }
            return true;
        }
        return false;
    }


    static function createApproval( $teamroomID, $userID )
    {
        // create a collaboration item
        $collaborationItem = eZCollaborationItem::create( 'ezapprovememberregistration', $userID );
        $collaborationItem->setAttribute( 'data_int1', $teamroomID );
        $collaborationItem->setAttribute( 'data_int2', $userID );
        $collaborationItem->setAttribute( 'data_int3', false );
        $collaborationItem->store();
        $collaborationID = $collaborationItem->attribute( 'id' );

        $teamroomObject = eZContentObject::fetch( $teamroomID );
        $approverIDArray = array ( $teamroomObject->attribute( 'owner_id' ) );

        $participantList = array( array( 'id' => array( $userID ),
                                         'role' => eZCollaborationItemParticipantLink::ROLE_AUTHOR ),
                                  array( 'id' => $approverIDArray,
                                         'role' => eZCollaborationItemParticipantLink::ROLE_APPROVER ) );
        foreach ( $participantList as $participantItem )
        {
            foreach( $participantItem['id'] as $participantID )
            {
                $link = eZCollaborationItemParticipantLink::create( $collaborationID, $participantID,
                                                                    $participantItem['role'], eZCollaborationItemParticipantLink::TYPE_USER );
                $link->store();

                $profile = eZCollaborationProfile::instance( $participantID );
                eZCollaborationItemGroupLink::addItem( $profile->attribute( 'main_group' ), $collaborationID, $participantID );
            }
        }

        // Create the notification
        $collaborationItem->createNotificationEvent();
        return $collaborationItem;
    }


    /*!
     \reimp
     Adds a new comment, approves the membership or denies the membership.
    */
    function handleCustomAction( $module, $collaborationItem )
    {
        $redirectView = 'item';
        $redirectParameters = array( 'full', $collaborationItem->attribute( 'id' ) );
        $addComment = false;

        if ( $this->isCustomAction( 'Approve' ) or
             $this->isCustomAction( 'Deny' ) )
        {
            // check user's rights to approve
            $user = eZUser::currentUser();
            $userID = $user->attribute( 'contentobject_id' );
            $participantList = eZCollaborationItemParticipantLink::fetchParticipantList( array( 'item_id' => $collaborationItem->attribute( 'id' ) ) );

            $approveAllowed = false;
            foreach( $participantList as $participant )
            {
                if ( $participant->ParticipantID == $userID &&
                     $participant->ParticipantRole == eZCollaborationItemParticipantLink::ROLE_APPROVER )
                {
                    $approveAllowed = true;
                    break;
                }
            }
            if ( !$approveAllowed ){
                return $module->redirectToView( $redirectView, $redirectParameters );
            }
            // get teamroomObject
            $teamroomID         =  $collaborationItem->attribute( 'data_int1' );
            $classIdentifierMap = eZTeamroom::getClassIdentifierList();
            $teamroomObject     = eZContentObject::fetch( $teamroomID);
            if ( !is_object( $teamroomObject ) ||  $teamroomObject->attribute( 'class_identifier' ) != $classIdentifierMap['teamroom'] )
            {
                return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
            }
            // get registration user
            $regMemberID =  $collaborationItem->attribute( 'data_int2' );
            $regMember =  eZUser::fetch( $regMemberID );

            $status = eZApproveMemberRegistrationCollaborationHandler::STATUS_DENIED;
            if ( $this->isCustomAction( 'Deny' ) )
            {
                eZTeamroom::sendSinlgeEmail( $regMember->attribute( 'email' ) , $teamroomObject, 'memberregistration_denied' );
            }
            // assign selected roles and accept the registraion (workflow will continue)
            else if ( $this->isCustomAction( 'Approve' ) )
            {
                $teamroomNode = $teamroomObject->attribute('main_node');
                if ( !is_object( $teamroomNode ) || $teamroomNode->attribute( 'class_identifier' ) != $classIdentifierMap['teamroom'] )
                {
                    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
                }

                $selectedRoleIDList = $this->customInput( 'SelectedRoleList' );
                $ini  = eZINI::instance( 'teamroom.ini' );
                $roleIDList = $ini->variable( 'PermissionSettings', 'TeamroomRoleList' );

                $db   = eZDB::instance();
                foreach ( $selectedRoleIDList as $roleID => $value )
                {
                    if ( in_array( $roleID, $roleIDList ) )
                    {
                        $db->begin();
                        $role = eZRole::fetch( $roleID );
                        $role->assignToUser( $regMemberID, 'subtree', $teamroomNode->attribute( 'node_id' ) );
                        $db->commit();
                    }
                }
                eZContentCacheManager::clearContentCacheIfNeeded ($teamroomID);
                eZUser::cleanupCache();

                $message = ezpI18n::tr( 'ezteamroom/teamroom', 'Changes have been stored.' );

                $status = eZApproveMemberRegistrationCollaborationHandler::STATUS_ACCEPTED;
            }

            $collaborationItem->setAttribute( 'data_int3', $status );
            $collaborationItem->setAttribute( 'status', eZCollaborationItem::STATUS_INACTIVE );
            $collaborationItem->setAttribute( 'modified', time() );
            $collaborationItem->setIsActive( false );
            $redirectView = 'view';
            $redirectParameters = array( 'summary' );
            $addComment = true;
        }

        if ( $addComment or $this->isCustomAction( 'Comment' ) )
        {
            $messageText = $this->customInput( 'ApproveComment' );
            if ( trim( $messageText ) != '' )
            {
                $message = eZCollaborationSimpleMessage::create( 'ezapprovememberregistration_comment', $messageText );
                $message->store();
                eZCollaborationItemMessageLink::addMessage( $collaborationItem, $message, eZApproveMemberRegistrationCollaborationHandler::MESSAGE_TYPE_APPROVEMEMBERREGISTRATION );
            }
        }

        $collaborationItem->sync();
        return $module->redirectToView( $redirectView, $redirectParameters );
    }
}

?>
