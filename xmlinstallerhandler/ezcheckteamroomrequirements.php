<?php
//
// Created on: <2008-06-06 14:50:48 dis>
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

class eZCheckTeamroomRequirements extends eZXMLInstallerHandler
{

    function eZCheckTeamroomRequirements( )
    {
    }

    function execute( $xmlNode )
    {
        // Check needed extensions
        $ini = eZINI::instance();
        $messages = array();
        $neededExtensionList = array( 'ezteamroom', 'ezlightbox', 'ezxmlinstaller', 'ezmultiupload', 'ezevent', 'ezjscore' );

        $activeExtensionList = $ini->variable( 'ExtensionSettings', 'ActiveExtensions' );

        foreach ( $neededExtensionList as $extension )
        {
            if ( !in_array( $extension, $activeExtensionList ) )
            {
                $messages[] = "Extension '$extension' is not activated.";
            }
        }

        $isDBConnected = eZDB::instance()->isConnected();

        if ( !$isDBConnected )
            $messages[] = "Database connection could not be etablished.";

        // Check if ezlightbox is installed correctly
        if ( $isDBConnected && !array_key_exists( 'ezlightbox', eZDB::instance()->eZTableList() ) )
            $messages[] = "ezlightbox is not installed correctly.";

        // Check parameter set by user
        $dataSource       = $xmlNode->getAttribute( 'data_source' );
        $teamroomRootNode = $xmlNode->getAttribute( 'teamroom_root_node' );
        $adminAccessName  = $xmlNode->getAttribute( 'admin_access_name' );
        $guestGroupID     = $xmlNode->getAttribute( 'guest_group_id' );
        $userGroupClassID = $xmlNode->getAttribute( 'user_group_class_id' );
        $folderClassID    = $xmlNode->getAttribute( 'folder_class_id' );
        $publicSectionID  = $xmlNode->getAttribute( 'public_section_id' );
        $usersSectionID   = $xmlNode->getAttribute( 'users_section_id' );

        if ( !file_exists( $dataSource ) )
        {
            $messages[] = "Data source '$dataSource' does not exist.";
        }

        $siteaccessList = $ini->variable( 'SiteAccessSettings', 'AvailableSiteAccessList' );
        if ( !in_array( $adminAccessName, $siteaccessList ) )
        {
            $messages[] = "Admin Siteaccess '$adminAccessName' does not exist.";
        }

        if ( $isDBConnected )
        {
            if ( !eZContentObjectTreeNode::fetch( $teamroomRootNode ) )
            {
                $messages[] = "Teamroom Node ID '$teamroomRootNode' does not exist.";
            }
            if ( !eZContentObject::fetch( $guestGroupID ) )
            {
                $messages[] = "Guest Group Object ID '$guestGroupID' does not exist.";
            }
            if ( !eZContentClass::fetch( $userGroupClassID ) )
            {
                $messages[] = "User group class ID '$userGroupClassID' does not exist.";
            }
            if ( !eZContentClass::fetch( $folderClassID ) )
            {
                $messages[] = "Folder class ID '$folderClassID' does not exist.";
            }
        }

        if ( $publicSectionID != 0 )
        {
            $sectionObject = eZSection::fetch( $publicSectionID );
            if ( !is_object( $sectionObject ) )
            {
                $messages[] = "Section with ID '$publicSectionID' for public teamroom section does not exist.";
            }
        }

        $sectionObject = eZSection::fetch( $usersSectionID );
        if ( !is_object( $sectionObject ) )
        {
            $messages[] = "Users section with ID '$usersSectionID' does not exist.";
        }

        if ( count( $messages ) )
        {
            foreach ( $messages as $message )
            {
                $this->writeMessage( "\tError: $message", 'error' );
            }
            $this->writeMessage( "Please fix the error(s) listed above and try to run the script again.", 'error' );
            $this->writeMessage( "", 'error' );
            eZExecution::cleanup();
            eZExecution::setCleanExit();
            exit();
        }

    }

    static public function handlerInfo()
    {
        return array( 'XMLName' => 'CheckTeamroomRequirements', 'Info' => 'check Teamroom requirements' );
    }
}

?>
