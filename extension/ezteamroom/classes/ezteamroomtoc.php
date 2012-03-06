<?php
//
// Created on: <2007-11-28 12:49:09 dis>
//
// SOFTWARE NAME: eZ Teamroom extension for eZ Publish
// SOFTWARE RELEASE: 1.4.0
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

class eZTeamroomTOC
{

    public $HeaderCounter = array();
    public $ObjectAttribute;
    public $ObjectAttributeId;
    private $tocArray = null;
    private $toc = null;
    private $validation_errors = array();

    public function __construct( eZContentObjectAttribute $dom )
    {
        $this->ObjectAttribute = $dom;
        $this->ObjectAttributeId = $dom->attribute( 'id' );
    }

    public function getHTML()
    {
        $toc = $this->getToc();
        return $toc['html'];
    }

    public function getHeaderArray()
    {
        $toc = $this->getToc();
        return $toc['header'];
    }

    public function getValidationErrors()
    {
        $toc = $this->getToc();
        return $toc['validation_errors'];
    }

    public function getToc()
    {
        if ( !$this->toc )
        {
            $tocText = '';
            $content = $this->ObjectAttribute->attribute( 'content' );
            $xmlData = $content->attribute( 'xml_data' );

            $domTree = new DOMDocument( '1.0', 'utf-8' );
            $domTree->preserveWhiteSpace = false;
            $success = $domTree->loadXML( $xmlData );

            $tocText = '';
            $tocArray = array();
            if ( $success )
            {
                $rootNode = $domTree->documentElement;
                $this->handleSection( $rootNode, $tocArray );
            }

            foreach ( $tocArray as $toc )
            {
                $tocText .= $this->handleTocElement( $toc );
            }
            $this->toc = array( 'html' => $tocText, 'header' => $tocArray, 'validation_errors' => $this->validation_errors );
        }

        return $this->toc;
    }

    private function handleSection( $sectionNode, &$tocArray, $level = 0 )
    {
        // Reset next level counter
        $this->HeaderCounter[$level + 1] = 0;

        $currentToc = array();
        $children = $sectionNode->childNodes;
        foreach ( $children as $key => $child )
        {
            if ( $child->nodeName == 'section' )
            {
                $childArray = array();
                $this->handleSection( $child, $childArray, $level + 1 );
                if ( count($childArray) )
                {
                    if ( !array_key_exists( 'children', $currentToc ) )
                        $currentToc['children'] = array();

                    $currentToc['children'] = array_merge( $currentToc['children'], $childArray );
                }
            }

            if ( $child->nodeName == 'header' )
            {
                $this->HeaderCounter[$level] += 1;
                $currentToc['text'] = $child->textContent;
            }
        }
        $tocArray[] = $currentToc;
        return true;
    }


    private function handleTocElement( $tocArray, $class="", $level = 0, $missing = array()  )
    {
        $text = '';
        if ( $level != 0 )
        {
            if ( $class != "" )
            {
                $text .= "<li class=\"".$class."\">\n";
            }
            else
            {
                $text .= "<li>\n";
            }
        }
        if ( array_key_exists( 'text', $tocArray )  )
        {
            $i = 1;
            $headerAutoName = "";
            while ( $i <= $level )
            {
                if ( $i > 1 )
                    $headerAutoName .= "_";

                $headerAutoName .= $this->HeaderCounter[$i];
                $i++;
            }
            $text .= '<a href="#eztoc' . $this->ObjectAttributeId . '_' . $headerAutoName . '">' . $tocArray['text'] . '</a>';

            if ( count( $missing ) )
            {
                $this->validation_errors[] = array( 'headline'           => $tocArray['text'], 
                                                    'level'              => ezpI18n::tr( 'design/standard/ezoe', 'Heading '.$level ), 
                                                    'missing_headlines'  => $missing );
            }
        }
        elseif ( $level != 0 )
        {
            $missing[] = ezpI18n::tr( 'design/standard/ezoe', 'Heading '.$level );

            $text .= '<a href="#">Headline '.$level.'</a>';
        }
        if ( array_key_exists( 'children', $tocArray ) )
        {
            $text .= "<ul class=\"level" . $level . "\">\n";
            $counter = 0;
            foreach ( $tocArray['children'] as $toc )
            {
                $counter++;
                $class = "";
                if ( $counter == 1 )
                {
                    $class .= ' firstelem';
                }
                if ( $counter == count( $tocArray['children'] ) )
                {
                    $class .= ' lastelem';
                }
                $text .= $this->handleTocElement( $toc, $class, $level + 1, $missing );
            }
            $text .= "</ul>\n";
        }
        $text .= "</li>\n";
        return $text;
    }

//     private function checkHeaderArray( $tocArray, &$errors = array(), $level = 0,  $missing = array() )
//     {
//         if ( !array_key_exists( 'text', $tocArray ) AND $level != 0 )
//         {
//             $missing[] = $level;
//         }
//         elseif ( count( $missing ) )
//         {
//             $errors[] = array( 'headers'  => $missing,
//                                'headline' => $tocArray['text']);
//         }
// 
// /*        if ( array_key_exists( 'children', $tocArray ) )
//         {
//             foreach ( $tocArray['children'] as $toc )
//             {
//                 $this->checkHeaderArray( $toc, $errors, $level + 1, $missing );
//             }
//         }*/
//         return $errors;
//     }


}