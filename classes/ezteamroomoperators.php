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

class eZTeamroomOperators
{
    /*!
     Constructor
    */
    function eZTeamroomOperators()
    {
        $this->Operators = array( 'mytime', 'eztoc2', 'index_by_day', 'merge_events', 'teamroom_version', 'join_teamroom_in_progress', 'str_replace', 'shorten_xml', 'array_sort' );
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
                                                                                'default' => '' ) ),
                      'shorten_xml' => array( 'chars_to_keep' => array( "type" => "integer",
                                                                             "required" => false,
                                                                             "default" => 80 ),
                                                   'str_to_append' => array( "type" => "string",
                                                                             "required" => false,
                                                                             "default" => "..." ),
                                                   'trim_type'     => array( "type" => "string",
                                                                             "required" => false,
                                                                             "default" => "right" ) ),
                      'array_sort' => array() );
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
                $tocCreator = new eZTeamroomTOC($namedParameters['dom']);
                $operatorValue = $tocCreator->getHTML();
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

            case 'array_sort':
            {
                sort($operatorValue);
            } break;

            case 'shorten_xml':
            {
                /* $operatorValue = preg_replace( "/<p.*?>/", "", $operatorValue); */
                $operatorValue = str_replace( "</p>", " ", $operatorValue);
                $operatorValue = strip_tags( $operatorValue );

                $strlenFunc = function_exists( 'mb_strlen' ) ? 'mb_strlen' : 'strlen';
                $substrFunc = function_exists( 'mb_substr' ) ? 'mb_substr' : 'substr';
                if ( $strlenFunc( $operatorValue ) > $namedParameters['chars_to_keep'] )
                {
                    $operatorLength = $strlenFunc( $operatorValue );

                    if ( $namedParameters['trim_type'] === 'middle' )
                    {
                        $appendedStrLen = $strlenFunc( $namedParameters['str_to_append'] );

                        if ( $namedParameters['chars_to_keep'] > $appendedStrLen )
                        {
                            $chop = $namedParameters['chars_to_keep'] - $appendedStrLen;

                            $middlePos = (int)($chop / 2);
                            $leftPartLength = $middlePos;
                            $rightPartLength = $chop - $middlePos;

                            $operatorValue = trim( $substrFunc( $operatorValue, 0, $leftPartLength ) . $namedParameters['str_to_append'] . $substrFunc( $operatorValue, $operatorLength - $rightPartLength, $rightPartLength ) );
                        }
                        else
                        {
                            $operatorValue = $namedParameters['str_to_append'];
                        }
                    }
                    else // default: trim_type === 'right'
                    {
                        $chop = $namedParameters['chars_to_keep'] - $strlenFunc( $namedParameters['str_to_append'] );
                        $operatorValue = $substrFunc( $operatorValue, 0, $chop );
                        $operatorValue = trim( $operatorValue );
                        if ( $operatorLength > $chop )
                            $operatorValue = $operatorValue.$namedParameters['str_to_append'];
                    }
                }
            } break;

        }
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

    // \privatesection
    var $Operators;
}

?>
