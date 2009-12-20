<?php
//
// Created on: <2007-11-28 12:49:09 dis>
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

class eZTeamroomOperators
{
    /*!
     Constructor
    */
    function eZTeamroomOperators()
    {
        $this->Operators = array( 'mytime', 'eztoc2', 'index_by_day', 'merge_events', 'teamroom_version', 'join_teamroom_in_progress', 'str_replace' );
    }

    /*!
     Returns the operators in this class.
    */
    function &operatorList()
    {
        return $this->Operators;
    }

    /*!
     See eZTemplateOperator::namedParameterList
    */
    function namedParameterList()
    {
        return array( 'eztoc2' => array( 'dom' => array( 'type' => 'object',
                                                         'required' => true,
                                                         'default' => 0 ) ),
                      'index_by_day' => array( 'calendar' => array( 'type' => 'array',
                                                                    'required' => true ) ),
                      'merge_events' => array( 'events' => array( 'type' => 'array',
                                                                                'required' => false,
                                                                                'default' => array() ),
                                               'milestones' => array( 'type' => 'array',
                                                                                'required' => false,
                                                                                'default' => array() ),
                                                'tasks' => array( 'type' => 'array',
                                                                                'required' => false,
                                                                                'default' => array() ) ),
                      'join_teamroom_in_progress' =>  array( 'teamroom' => array( 'type' => 'integer',
                                                                                'required' => true,
                                                                                'default' => 0 ),
                                                        'user_id' => array( 'type' => 'integer',
                                                                                'required' => false,
                                                                                'default' => 0 ) ),
                      'str_replace' =>  array( 'search' => array( 'type' => 'string',
                                                                                'required' => true,
                                                                                'default' => '' ),
                                               'replace' => array( 'type' => 'string',
                                                                                'required' => true,
                                                                                'default' => '' ),
                                               'subject' => array( 'type' => 'string',
                                                                                'required' => true,
                                                                                'default' => '' ) ) );
    }

    function namedParameterPerOperator()
    {
        return true;
    }

    /*!
     Executes the needed operator(s).
     Checks operator names, and calls the appropriate functions.
    */
    function modify( &$tpl, &$operatorName, &$operatorParameters, &$rootNamespace,
                     &$currentNamespace, &$operatorValue, &$namedParameters, $placement )
    {

        switch ( $operatorName )
        {
            case 'mytime':
            {
                $hour   = ( count($operatorParameters) > 0 )
                                ? $tpl->elementValue( $operatorParameters[0], $rootNamespace, $currentNamespace, $placement ) 
                                : (int)date( 'g' );
                $minute = ( count($operatorParameters) > 1 )
                                ? $tpl->elementValue( $operatorParameters[1], $rootNamespace, $currentNamespace, $placement )
                                : (int)date( 'i' );
                $second = ( count($operatorParameters) > 2 )
                                ? $tpl->elementValue( $operatorParameters[2], $rootNamespace, $currentNamespace, $placement )
                                : (int)date( 's' );
                $month  = ( count($operatorParameters) > 3 )
                                ? $tpl->elementValue( $operatorParameters[3], $rootNamespace, $currentNamespace, $placement )
                                : (int)date( 'n' );
                $day    = ( count($operatorParameters) > 4 )
                                ? $tpl->elementValue( $operatorParameters[4], $rootNamespace, $currentNamespace, $placement )
                                : (int)date( 'j' );
                $year   = ( count($operatorParameters) > 5 )
                                ? $tpl->elementValue( $operatorParameters[5], $rootNamespace, $currentNamespace, $placement )
                                : (int)date( 'Y' );

                $operatorValue = mktime($hour, $minute, $second, $month, $day,$year );
            } break;

            // Index the eventy by the day of the month they are happening.
            // 
            // Returns an arrya for each day, in which the class identifiers of
            // the events taking place at the day can be found.
            case 'index_by_day':
                $dayEvents = array_fill( 1, 31, array() );
                foreach ( $namedParameters['calendar'] as $timestamp => $event )
                {
                    $day = (int) date( 'd', $timestamp );
                    if ( $event instanceof eZContentObjectTreeNode )
                    {
                        $event = $event->attribute( 'object' );
                    }

                    $dayEvents[$day][] = (string) $event->attribute( 'content_class' )->attribute( 'identifier' );
                }
                $operatorValue = $dayEvents;
                break;

            case 'merge_events':
            {
                $result = array();

                if( count( $namedParameters['events'] ) )
                {
                    $eventList = $namedParameters['events'];
                    foreach ( $eventList as $event )
                    {
                        $timestamp = $event->startDate;
                        do
                        {
                            $timestamp++;
                        } while ( array_key_exists( $timestamp, $result) );
                        $result[$timestamp] = $event;
                    }
                }
                if( count( $namedParameters['milestones'] ) )
                {
                    $eventList = $namedParameters['milestones'];
                    foreach ( $eventList as $event )
                    {
                        $dataMap = $event->attribute( 'data_map' );
                        $timestamp = $dataMap['date']->content()->timeStamp();
                        do
                        {
                            $timestamp++;
                        } while ( array_key_exists( $timestamp, $result) );
                        $result[$timestamp] = $event;
                    }
                }
                if( count( $namedParameters['tasks'] ) )
                {
                    $eventList = $namedParameters['tasks'];
                    foreach ( $eventList as $event )
                    {
                        $dataMap = $event->attribute( 'data_map' );
                        $timestamp = $dataMap['planned_end_date']->content()->timeStamp();
                        do
                        {
                            $timestamp++;
                        } while ( array_key_exists( $timestamp, $result) );
                        $result[$timestamp] = $event;
                    }
                }

                ksort( $result );
                $operatorValue = $result;

            } break;
            case 'eztoc2':
            {
                $dom = $namedParameters['dom'];
                $tocText = '';
                if ( $dom instanceof eZContentObjectAttribute )
                {
                    $this->ObjectAttributeId = $dom->attribute( 'id' );
                    $content = $dom->attribute( 'content' );
                    $xmlData = $content->attribute( 'xml_data' );

                    $domTree = new DOMDocument( '1.0', 'utf-8' );
                    $domTree->preserveWhiteSpace = false;
                    $success = $domTree->loadXML( $xmlData );

                    $tocText = '';
                    $tocArray = array();
                    if ( $success )
                    {
                        $this->HeaderCounter = array();

                        $rootNode = $domTree->documentElement;
                        $this->handleSection( $rootNode, $tocArray );

                    }
                    foreach ( $tocArray as $toc )
                    {
                        $tocText .= $this->handleTocElement( $toc );
                    }
                }
                $operatorValue = $tocText;
            } break;

            case 'teamroom_version':
            {
                if( class_exists('ezteamroomInfo') )
                {
                    $teamroominfo = ezteamroomInfo::info();
                    $operatorValue = isset( $teamroominfo['Version'] ) ?  $teamroominfo['Version'] : false;
                }
                else
                {
                    $operatorValue = false;
                }
            } break;

            case 'join_teamroom_in_progress':
            {
                $operatorValue = eZTeamroomOperators::joinTeamroomInProgress( $namedParameters['teamroom'], $namedParameters['user_id'] );
            } break;

            case 'str_replace':
            {
                $operatorValue = str_replace( $namedParameters['search'], $namedParameters['replace'], $namedParameters['subject'] );
            } break;

        }
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
                $i = 1;
                $headerAutoName = "";
                while ( $i <= $level )
                {
                    if ( $i > 1 )
                        $headerAutoName .= "_";

                    $headerAutoName .= $this->HeaderCounter[$i];
                    $i++;
                }
                $text = '<a href="#eztoc' . $this->ObjectAttributeId . '_' . $headerAutoName . '">' . $child->textContent . '</a>';
                $currentToc['text'] = $text;

            }
        }
        $tocArray[] = $currentToc;
        return true;
    }

    private function handleTocElement( $tocArray, $class="", $level = 0 )
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
            $text .= $tocArray['text'];
        }
        elseif ( $level != 0 )
        {
            $text .= '<a href="#">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>';
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
                $text .= $this->handleTocElement( $toc, $class, $level + 1 );
            }
            $text .= "</ul>\n";
        }
        $text .= "</li>\n";
        return $text;
    }
    static function joinTeamroomInProgress( $teamroomID, $userID = false )
    {
        $workflowEventList = eZWorkflowEvent::fetchFilteredList( array( 'workflow_type_string' => 'event_ezapprovemembership' ), false );

        if( !$userID )
        {
            $user = eZUser::currentUser();
            $userID = $user->attribute( 'contentobject_id' );
        }

        if ( count( $workflowEventList ) >= 1 )
        {
            $eventID = $workflowEventList[0]['id'];
            $processList = eZWorkflowProcess::fetchList( array( 'user_id' => $userID, 'event_id' => $eventID ) );
            $teamroomObject = eZContentObject::fetch( $teamroomID );
            foreach ( $processList  as $process )
            {
                $parameterList = $process->parameterList();
                if (  $parameterList['teamroom_id'] == $teamroomID )
                {
                    return true;
                }
            }
        }
        return false;
    }

    public $HeaderCounter = array();

    public $ObjectAttributeId;

    // \privatesection
    var $Operators;
}

?>
