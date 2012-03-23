<?php
//
// Created on: <2012-03-02 22:05:03 d.niedziella@circit.de>
//
// SOFTWARE NAME: eZ Teamroom extension for eZ Publish
// SOFTWARE RELEASE: 1.5.0
// COPYRIGHT NOTICE: Copyright (C) 1999-2011 eZ Systems AS
// SOFTWARE LICENSE: eZ Business Use License Agreement Version 2.0
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

$module = $Params['Module'];
$wikiNodeID  = $Params['wikiNodeID'];

$http = eZHTTPTool::instance();
#$db = eZDB::instance();

// class mapping
$class_identifier_map = array();
$TrINI = eZINI::instance( 'teamroom.ini' );
if( $TrINI AND
    $TrINI->hasVariable( 'TeamroomSettings', 'ClassIdentifiersMap' ) AND
    is_array( $TrINI->variable( 'TeamroomSettings', 'ClassIdentifiersMap' ) ) )
{
    $class_identifier_map = $TrINI->variable( 'TeamroomSettings', 'ClassIdentifiersMap' );
}
$wikiClassIdentifier = array_key_exists( 'wiki', $class_identifier_map )? $class_identifier_map['wiki'] : 'wiki';
$wikiPageClassIdentifier = array_key_exists( 'wiki_page', $class_identifier_map )? $class_identifier_map['wiki_page'] : 'wiki_page';



$wikiNode = eZContentObjectTreeNode::fetch( $wikiNodeID );
if ( !$wikiNode instanceof eZContentObjectTreeNode OR
      $wikiNode->attribute( 'class_identifier' ) != $wikiClassIdentifier )
{
    return $module->handleError( eZError::KERNEL_NOT_FOUND, 'kernel' );
}
if ( !$wikiNode->attribute('can_read') )
{
    return $module->handleError( eZError::KERNEL_ACCESS_DENIED, 'kernel' );
}


$childrenCount = $wikiNode->subTreeCount( array( 'ClassFilterType'  => 'include',
                                                 'ClassFilterArray' => array( $wikiPageClassIdentifier ) ) );
if ( !$childrenCount )
{
    return $module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}

$random_node = $wikiNode->subTree( array( 'ClassFilterType'  => 'include',
                                          'ClassFilterArray' => array( $wikiPageClassIdentifier ),
                                          'Offset'           => mt_rand( 0, $childrenCount-1 ),
                                          'Limit'            => 1 ) );

if ( is_array( $random_node ) AND count( $random_node ) == 1 )
{
    $random_node = $random_node[0];
}
else
{
    return $module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}

return $module->redirectTo( $random_node->attribute('url_alias') );

?>
