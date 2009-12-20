<?php
//
// Created on: <2009-09-10 11:07:26 ab>
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

class eZKeywordList
{
    function eZKeywordList()
    {
    }

    function operatorList()
    {
        return array( 'ezkeywordlist' );
    }

    function namedParameterPerOperator()
    {
        return true;
    }

    function namedParameterList()
    {
        return array( 'ezkeywordlist' => array( 'class_identifier' => array( 'type' => 'string',
                                                               'required' => true,
                                                               'default' => '' ),
                                                'parent_node_id' => array( 'type' => 'integer',
                                                                'required' => true,
                                                                'default' => 0 ) ) );
    }

    function modify( $tpl, $operatorName, $operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters )
    {
        $classIdentifier = $namedParameters['class_identifier'];
        $parentNodeID = $namedParameters['parent_node_id'];

        switch ( $operatorName )
        {
            case 'ezkeywordlist':
            {
                include_once( 'lib/ezdb/classes/ezdb.php' );
                $db = eZDB::instance();
                
                if( $parentNodeID )
                {
                    $node = eZContentObjectTreeNode::fetch( $parentNodeID );
                    if ( $node )
                        $pathString = "AND ezcontentobject_tree.path_string like '" . $node->attribute( 'path_string' ) . "%'";
                    $parentNodeIDSQL = "AND ezcontentobject_tree.node_id != " . (int)$parentNodeID;
                }

                $showInvisibleNodesCond = eZContentObjectTreeNode::createShowInvisibleSQLString( true, false );
                $limitation = false;
                $limitationList = eZContentObjectTreeNode::getLimitationList( $limitation );
                $sqlPermissionChecking = eZContentObjectTreeNode::createPermissionCheckingSQL( $limitationList );

                $versionNameJoins = " AND ezcontentobject_tree.contentobject_id = ezcontentobject_name.contentobject_id AND
                                            ezcontentobject_tree.contentobject_version = ezcontentobject_name.content_version AND ";
                $languageFilter = " AND " . eZContentLanguage::languagesSQLFilter( 'ezcontentobject' );
                $versionNameJoins .= eZContentLanguage::sqlFilter( 'ezcontentobject_name', 'ezcontentobject' );

                $rs = $db->arrayQuery( "SELECT DISTINCT ezkeyword.keyword
                                            FROM ezkeyword_attribute_link,
                                                 ezkeyword,
                                                 ezcontentobject,
                                                 ezcontentobject_name,
                                                 ezcontentobject_attribute,
                                                 ezcontentobject_tree,
                                                 ezcontentclass
                                                 $sqlPermissionChecking[from]
                                            WHERE ezkeyword.id = ezkeyword_attribute_link.keyword_id
                                                AND ezkeyword_attribute_link.objectattribute_id = ezcontentobject_attribute.id
                                                AND ezcontentobject_tree.contentobject_id = ezcontentobject_attribute.contentobject_id
                                                AND ezkeyword.class_id = ezcontentclass.id
                                                AND ezcontentclass.identifier = '" . $classIdentifier . "'
                                                $pathString
                                                $parentNodeIDSQL
                                                $showInvisibleNodesCond
                                                $sqlPermissionChecking[where]
                                                $languageFilter
                                                $versionNameJoins
                                            ORDER BY ezkeyword.keyword ASC" );
                $operatorValue = $rs;
            } break;
        }
    }
}

?>
