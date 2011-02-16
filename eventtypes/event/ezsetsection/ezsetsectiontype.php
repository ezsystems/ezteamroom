<?php
//
// Created on: <2007-11-23 22:05:03 dis>
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

class eZSetSectionType extends eZWorkflowEventType
{
    function eZSetSectionType()
    {
        $this->eZWorkflowEventType( 'ezsetsection', ezpI18n::tr( 'ezteamroom/setsetction', 'Set Section of Object' ) );
        $this->setTriggerTypes( array( 'content' => array( 'publish' => array( 'after' ) ) ) );
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
        $object = eZContentObject::fetch( $parameters['object_id'] );
        $dataMap = $object->attribute( 'data_map' );

        if ( array_key_exists( 'access_type', $dataMap ) )
        {
            $ini = eZINI::instance( 'teamroom.ini' );
            $privateSectionID = $ini->variable( 'TeamroomSettings', 'PrivateSectionID' );
            $publicSectionID  = $ini->variable( 'TeamroomSettings', 'PublicSectionID' );

            $attributeContent = $dataMap['access_type']->content();
            $accessValue      = $attributeContent[0];
            $mainNode         = $object->attribute( 'main_node' );

            $visibilityList  = $ini->variable( 'TeamroomSettings', 'VisibilityList' );

            if ( $mainNode && in_array( $accessValue, $visibilityList ) )
            {
                $db = eZDB::instance();
                $db->begin();

                $mainNodeID = $mainNode->attribute( 'node_id' );

                $teamroomSection  = $ini->variable( 'VisibilitySettings_' . $accessValue , 'TeamroomSection' );
                $subTreeSection   = $ini->variable( 'VisibilitySettings_' . $accessValue , 'SubTreeSection' );


                if ( $teamroomSection == 'group_mapping' )
                {
                    $sectionMapping   = $ini->variable( 'VisibilitySettings_' . $accessValue , 'SectionGroupMapping' );
                    $teamroomSection = eZSetSectionType::getSectionByGroupMapping( $object, $sectionMapping );
                }
                if ( $subTreeSection == 'group_mapping' )
                {
                    $sectionMapping   = $ini->variable( 'VisibilitySettings_' . $accessValue , 'SectionGroupMapping' );
                    $subTreeSection = eZSetSectionType::getSectionByGroupMapping( $object, $sectionMapping );
                }

                if ( !$teamroomSection || $teamroomSection == 0 )
                {
                    $teamroomSection = $privateSectionID;
                }
                if ( !$subTreeSection || $subTreeSection == 0 )
                {
                    $subTreeSection = $publicSectionID;
                }

                if ( $subTreeSection && $teamroomSection )
                {
                    eZContentObjectTreeNode::assignSectionToSubTree( $mainNodeID, $subTreeSection );
                    $object->setAttribute( 'section_id', $teamroomSection );
                    $object->store();
                }

                $db->commit();
            }

            return eZWorkflowType::STATUS_ACCEPTED;
        }


        return eZWorkflowType::STATUS_ACCEPTED;
    }

    static private function getSectionByGroupMapping( $object, $sectionMapping )
    {
        $user = eZUser::fetch( $object->attribute( 'owner_id' ) );
        $groupList = array_flip( $user->attribute('groups' ) );
        $sectionID = false;

        if ( $user )
        {

            $mergedArray = array_intersect_key( $sectionMapping, $groupList );

            if ( count( $mergedArray ) == 1 )
            {
                $sectionID = current( $mergedArray );
            }
            elseif ( count( $mergedArray ) > 1 )
            {
                $sectionID = current( $mergedArray );
            }
            if ( !$sectionID )
            {
                $sectionID = $privateSectionID;
            }
        }
        return $sectionID;
    }

}

eZWorkflowEventType::registerEventType( 'ezsetsection', 'eZSetSectionType' );

?>
