{* set-block scope=root variable=cache_ttl}400{/set-block *} {* ab: Commented out to find a better way if possible *}

{def $default_limit = 15}

{if ezpreference( 'teamroom_calendar_limit' )}

    {set $default_limit = ezpreference( 'teamroom_calendar_limit' )}

{/if}

{def $page_limit = first_set( $default_limit, 5 )}

{if and( is_set( $view_parameters.limit ), $view_parameters.limit|gt( 0 ) )}

    {set $page_limit = $view_parameters.limit}

{/if}

{def $frontpagestyle='leftcolumn rightcolumn'}

{* Event Calendar - Full Calendar view *}
{def $curr_ts     = currentdate()
     $curr_today  = $curr_ts|datetime( custom, '%j')
     $curr_year   = $curr_ts|datetime( custom, '%Y')
     $curr_month  = $curr_ts|datetime( custom, '%n')
     $selected_ts = cond( and( ne( $view_parameters.month, '' ),
                               ne( $view_parameters.year,  '' )
                             ),
                          makedate( $view_parameters.month,
                                    cond( ne( $view_parameters.day, '' ),
                                          $view_parameters.day,
                                          eq( $curr_month, $view_parameters.month ),
                                          $curr_today,
                                          1
                                        ),
                                    $view_parameters.year
                                  ),
                          currentdate()
                        )

    $selected_month = $selected_ts|datetime( custom, '%n')
    $selected_year  = $selected_ts|datetime( custom, '%Y')
    $selected_day   = $selected_ts|datetime( custom, '%j')

    $days = $selected_ts|datetime( custom, '%t' )

    $first_ts = makedate( $selected_month, 1, $selected_year )
    $last_ts  = makedate( $selected_month, $days, $selected_year )

    $dayone   = $first_ts|datetime( custom, '%w' )
    $span1    = $dayone
    $span2    = sub( 7, $last_ts|datetime( custom, '%w' ) )

    $dayofweek       = 0
    $day_array       = " "
    $mday_array      = " "
    $next_month      = sum( $selected_month, 1 )
    $prev_month      = sub( $selected_month, 1 )
    $next_year       = $selected_year
    $prev_year       = $selected_year
    $events          = array()
    $milestones      = array()
    $tasks           = array()
    $skip_events     = 0
    $skip_milestones = 0
    $skip_tasks      = 0

    $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}

{if ne( $selected_month, 12 )}

    {set $last_ts = makedate( $selected_month|sum( 1 ), 1, $selected_year )}

{else}

    {set $last_ts = makedate( 1, 1, $selected_year|sum( 1 ) )}

{/if}

{if is_set( $view_parameters.filter )}

    {if $view_parameters.filter|eq( 'events' )}

        {set $skip_milestones = 1
                  $skip_tasks = 1}

    {elseif $view_parameters.filter|eq( 'tasks' )}

        {set     $skip_events = 1
             $skip_milestones = 1}

    {elseif $view_parameters.filter|eq( 'milestones' )}

        {set  $skip_tasks = 1
             $skip_events = 1}

    {/if}

{/if}

{if $skip_events|eq( 0 )}

    {* This fetch return content object but not content nodes *}

    {set $events = fetch( 'event', 'list', hash( 'year',           $selected_year,
                                                 'month',          $selected_month,
                                                 'parent_node_id', $node.node_id
                                               )
                        )}

{/if}

{if $skip_milestones|eq( 0 )}

    {set $milestones = fetch( 'content', 'tree', hash( 'parent_node_id',     $node.parent.node_id,
                                                       'sort_by',            array( 'attribute', true(), concat( $class_identifier_map['milestone'], '/date' ) ),
                                                       'class_filter_type',  'include',
                                                       'class_filter_array', array( $class_identifier_map['milestone'] ),
                                                       'main_node_only',     true(),
                                                       'attribute_filter',   array( array( concat( $class_identifier_map['milestone'], '/date' ),
                                                                                           'between',
                                                                                           array( sum($first_ts,1), sub($last_ts,1) )
                                                                                         )
                                                                                  )
                                                     )
                            )}

{/if}

{if $skip_tasks|eq( 0 )}

    {set $tasks = fetch( 'content', 'tree', hash( 'parent_node_id',     $node.parent.node_id,
                                                  'sort_by',            array( 'attribute', true(), concat( $class_identifier_map['task'], '/planned_end_date' ) ),
                                                  'class_filter_type',  'include',
                                                  'class_filter_array', array( $class_identifier_map['task'] ),
                                                  'main_node_only',     true(),
                                                  'attribute_filter',   array( array( concat( $class_identifier_map['task'], '/planned_end_date' ),
                                                                                      'between',
                                                                                      array( sum($first_ts,1), sub($last_ts,1) )
                                                                                    )
                                                                             )
                                                )
                       )}

{/if}

{def $url_back        = concat( $node.url_alias, "/(month)/", sub( $selected_month, 1 ), "/(year)/", $selected_year )
     $url_forward     = concat( $node.url_alias, "/(month)/", sum( $selected_month, 1 ), "/(year)/", $selected_year )
     $merged_calendar = merge_events( $events, $milestones, $tasks )}

{if eq( $selected_month, 1 )}

    {set $url_back   = concat( $node.url_alias, "/(month)/", "12", "/(year)/", sub( $selected_year, 1 ), "/(object)/", $box_object_id )
         $prev_month = 12
         $prev_year  = $prev_year|dec()}

{elseif eq( $selected_month, 12 )}

    {set $url_forward = concat( $node.url_alias,  "/(month)/", "1", "/(year)/", sum($selected_year, 1), "/(object)/", $box_object_id )
         $next_month  = 1
         $next_year   = $next_year|inc()}

{/if}

{* Find all events / ... which happen at the currently selected day, and build
   an index of days in the month, flagged by the event types, which happen at
   that day.
*}
{def $day_of_month_events = index_by_day( $merged_calendar )}

<div class="content-view-full">
 <div class="class-event_calendar {$frontpagestyle}">
  <div class="attribute-header">
   <h1>{$node.name|wash()}</h1>
   <div class="calendar-heading-date">

{if and( eq( $curr_year,  $view_parameters.year  ),
         eq( $curr_month, $view_parameters.month )
       )}

    {if eq( $view_parameters.day, '' )}

    <h2>{"Events this month"|i18n('ezteamroom/events')|wash()}</h2>

    {elseif eq( $view_parameters.day, $curr_today )}

    <h2>{"Today's events"|i18n('ezteamroom/events')|wash()}</h2>

    {else}

    <h2>{"Events on %1"|i18n( 'ezteamroom/events', ,array( $selected_ts|l10n( 'date' ) ) )|wash()}</h2>

    {/if}

{else}

    {if or( eq( $view_parameters.year, ''  )
            eq( $view_parameters.month, '' ) )}

    <h2>{"Events this month"|i18n('ezteamroom/events' )|wash()}</h2>

    {elseif ne($view_parameters.day, '')}

    <h2>{"Events on"|i18n( 'ezteamroom/events' )} {$selected_ts|l10n( 'date' )|wash()}</h2>

    {else}

    <h2>{"Events in %1"|i18n( 'ezteamroom/events', ,array( $selected_ts|datetime( custom, '%F %Y' ) ) )|wash()}</h2>

    {/if}

{/if}

   </div>
  </div>

{if and( is_set( $node.object.data_map.description ), $node.object.data_map.description.has_content )}

  <div class="attribute-long">

    {attribute_view_gui attribute = $node.data_map.description}

  </div>

{/if}

  <div class="columns-frontpage float-break">
   <div class="left-column-position">
    <div class="left-column">
     <div id="ezagenda_calendar_container_full">
      <table cellspacing="0" cellpadding="0" border="0" summary="Event Calendar">
       <thead>
        <tr class="calendar_heading">
         <th class="calendar_heading_prev first_col" colspan="2">
          <a href={$url_back|ezurl} title=" {'Previous month'|i18n("ezteamroom/events")|wash()} ">

{if $curr_year|ne( $prev_year )}

    {mytime( 0, 0, 0, $prev_month, 15, $curr_year|int() )|datetime( custom, '%M' )|upfirst()}

    {$prev_year}

{else}

    {mytime( 0, 0, 0, $prev_month, 15, $curr_year|int() )|datetime( custom, '%F' )|upfirst()}

{/if}

          </a>
         </th>
         <th class="calendar_heading_date" colspan="3">

{$selected_ts|datetime( custom, '%F' )|upfirst()}&nbsp;{$selected_year}

         </th>
         <th class="calendar_heading_next last_col" colspan="2">
          <a href={$url_forward|ezurl} title=" {'Next Month'|i18n("ezteamroom/events")|wash()} ">

{if $curr_year|ne( $next_year )}

    {mytime( 0, 0, 0, $next_month, 15, $curr_year|int() )|datetime( custom, '%M' )|upfirst()}

    {$next_year}

{else}

    {mytime( 0, 0, 0, $next_month, 15, $curr_year|int() )|datetime( custom, '%F' )|upfirst()}

{/if}

          </a>
         </th>
        </tr>
        <tr class="calendar_heading_days">
         <th class="first_col">{"Mon"|i18n("ezteamroom/events")|wash()}</th>
         <th>{"Tue"|i18n("ezteamroom/events")|wash()}</th>
         <th>{"Wed"|i18n("ezteamroom/events")|wash()}</th>
         <th>{"Thu"|i18n("ezteamroom/events")|wash()}</th>
         <th>{"Fri"|i18n("ezteamroom/events")|wash()}</th>
         <th>{"Sat"|i18n("ezteamroom/events")|wash()}</th>
         <th class="last_col">{"Sun"|i18n("ezteamroom/events")|wash()}</th>
        </tr>
       </thead>
      <tbody>

{def  $day_of_month = 1
       $col_counter = 1
     $css_col_class = ''
           $col_end = 0}

{while le( $day_of_month, $days )}

    {set $dayofweek     = makedate( $selected_month, $day_of_month, $selected_year )|datetime( custom, '%w' )
         $css_col_class = ''
         $col_end       = or( eq( $dayofweek, 0 ), eq( $day_of_month, $days ) )}

    {if or( eq( $day_of_month, 1 ), eq( $dayofweek, 1 ) )}

       <tr class="days{if eq( $day_of_month, 1 )} first_row{elseif le( $days|sub( $day_of_month ), 7 )} last_row{/if}">

        {set $css_col_class = ' first_col'}

    {elseif and($col_end, not(and(eq( $day_of_month, $days ), $span2|gt( 0 ), $span2|ne(7))) )}

        {set $css_col_class = ' last_col'}

    {/if}

    {if and( $span1|gt( 1 ), eq( $day_of_month, 1 ) )}

        {set   $col_counter = 1
             $css_col_class = ''}

        {while ne( $col_counter, $span1 )}

        <td{if $col_counter|eq( 1 )} class="first_col"{/if}>&nbsp;</td>

            {set $col_counter = inc( $col_counter )}

        {/while}

    {elseif and( eq( $span1, 0 ), eq( $day_of_month, 1 ) )}

        {set $col_counter   = 1
             $css_col_class = ''}

        {while le( $col_counter, 6 )}

        <td{if $col_counter|eq( 1 )} class="first_col"{/if}>&nbsp;</td>

            {set $col_counter = inc( $col_counter )}

        {/while}

    {/if}

        <td class="{if eq($day_of_month, $selected_day)}ezagenda_selected{/if} {if and(eq($day_of_month, $curr_today), eq($curr_month, $selected_month))}ezagenda_current{/if}{$css_col_class}">
         <div class="cal_day">

    {if or( $day_array|contains(concat(' ', $day_of_month, ',')), $mday_array|contains(concat(' ', $day_of_month, ',')) )}

          <a href={concat( $node.url_alias, "/(day)/", $day_of_month, "/(month)/", $selected_month, "/(year)/", $selected_year)|ezurl}>{$day_of_month}</a>

    {else}

        {$day_of_month}

    {/if}

         </div>
         <div class="cal_entry float-break">

    {if $day_of_month_events[$day_of_month]|contains( $class_identifier_map['event'] )}

          <div class="cal_entry_event">&nbsp;</div>

    {/if}

    {if $day_of_month_events[$day_of_month]|contains( $class_identifier_map['milestone'] )}

          <div class="cal_entry_milestone">&nbsp;</div>

    {/if}

    {if $day_of_month_events[$day_of_month]|contains( $class_identifier_map['task'] )}

          <div class="cal_entry_task">&nbsp;</div>

    {/if}

         </div>
        </td>

    {if and( eq( $day_of_month, $days ), $span2|gt( 0 ), $span2|ne(7))}

        {set $col_counter = 1}

        {while le( $col_counter, $span2 )}

        <td{if $col_counter|eq( $span2 )} class="last_col"{/if}>&nbsp;</td>

            {set $col_counter = inc( $col_counter )}

        {/while}

    {/if}

    {if $col_end}

       </tr>

    {/if}

    {set $day_of_month = inc( $day_of_month )}

{/while}

       <tr class="calendar_footer">
        <td colspan="7">
         <ul class="float-break">
          <li>{'Legend'|i18n('ezteamroom/events')|wash()}:</li>
          <li class="float-break">
           <div class="cal_entry_event"></div>
          </li>
          <li>{'Event'|i18n('ezteamroom/events')|wash()}</li>
          <li class="float-break">
           <div class="cal_entry_milestone"></div>
          </li>
          <li>{'Milestone'|i18n('ezteamroom/events')|wash()}</li>
          <li class="float-break">
           <div class="cal_entry_task"></div>
          </li>
          <li>{'Task'|i18n('ezteamroom/events')|wash()}</li>
         </ul>
        </td>
       </tr>
      </tbody>
     </table>
    </div>
   </div>
  </div>
  <div class="center-column-position">
   <div class="center-column float-break">
    <div class="overflow-fix">
     <div class="border-box">
      <div class="border-tl">
       <div class="border-tr">
        <div class="border-tc"></div>
       </div>
      </div>
      <div class="border-ml">
       <div class="border-mr">
        <div class="border-mc float-break">
         <div class="content-view-full">
          <div class="class-event-calendar event-calendar-calendarview">

{def    $show_date = true()
      $count_events = $merged_calendar|count()
          $day_from = 0
            $day_to = 0
       $day_current = 0}

{if eq( $merged_calendar|count(), 0)}

           <h3>{"No events found"|i18n('ezteamroom/events')}</h3>

{else}

    {def $event_object = false()
               $offset = 0}

    {if $view_parameters.offset}
        {set $offset = $view_parameters.offset}
    {/if}

    {foreach $merged_calendar as $key => $event max $page_limit offset $offset}

        {set $show_date = true()
             $event_object = false()}

        {switch match = $event|get_class()}
            {case match = 'ezcontentobject'}
                {set $event_object = $event}
            {/case}
            {case match = 'ezcontentobjecttreenode'}
                {set $event_object = $event.object}
            {/case}
            {case}
                {continue}
            {/case}
        {/switch}

        {if ne( $view_parameters.day, '' )}

            {set $day_current = $view_parameters.day|int()}

            {switch match = $event_object.class_identifier}

                {case match = $class_identifier_map['event']}

                    {* set first day *}
                    {if and( eq( $view_parameters.month|int(), $event_object.data_map.event_date.content.current_start.month )|int(),
                             eq( $view_parameters.year|int(),  $event_object.data_map.event_date.content.current_start.year|int() )
                           )}

                        {set $day_from = $event_object.data_map.event_date.content.current_start.day|int()}

                    {else}

                        {set $day_from = 0}

                    {/if}

                    {* set last day *}
                    {if $event_object.data_map.event_date.content.end_date|eq( 0 )}

                        {set $day_to = $day_from}

                    {else}

                        {if and( eq( $view_parameters.month|int(), $event_object.data_map.event_date.content.current_end.month|int() ),
                                 eq( $view_parameters.year|int(),  $event_object.data_map.event_date.content.current_end.year|int() )
                               )}

                            {set $day_to = $event_object.data_map.event_date.content.current_end.day|int()}

                        {else}

                            {set $day_to = 100}

                        {/if}

                    {/if}

                    {if and( $day_current|le( $day_to ), $day_current|ge( $day_from ) )|not()}

                        {set    $show_date = false()
                             $count_events = $count_events|dec()}

                    {/if}

                {/case}

                {case match = $class_identifier_map['task']}

                    {if eq( $event_object.data_map.planned_end_date.content.day|int(), $day_current )|not()}

                        {set    $show_date = false()
                             $count_events = $count_events|dec()}

                    {/if}

                {/case}

                {case match = $class_identifier_map['milestone']}

                {/case}

            {/switch}

        {/if}

        {if $show_date}

            {content_view_gui view = 'cal_line'
                              content_object = $event_object
                              event_date = $key
                              redirect = $node.url_alias}

        {/if}

    {/foreach}

    {undef $event_object}

{/if}

          </div>
         </div>
        </div>
       </div>
      </div>
      <div class="border-bl">
       <div class="border-br">
        <div class="border-bc"></div>
       </div>
      </div>
     </div>

{include name            = navigator
         uri             = 'design:navigator/google.tpl'
         page_uri        = $node.url_alias
         item_count      = $count_events
         view_parameters = $view_parameters
         item_limit      = $page_limit
         preference      = "teamroom_calendar_limit"}

    </div>
   </div>
  </div>
  <div class="right-column-position">
   <div class="right-column">
    <div class="border-box">
     <div class="border-tl">
      <div class="border-tr">
       <div class="border-tc"></div>
      </div>
     </div>
     <div class="border-ml">
      <div class="border-mr">
       <div class="border-mc float-break">

{def $can_create = fetch( 'content', 'access', hash( 'access', 'create',
                                                     'contentobject', $node,
                                                     'contentclass_id', $class_identifier_map['event']
                                                   )
                        )}

{if $can_create}

        <div class="create-task">
         <form method="post" action={"content/action/"|ezurl}>
          <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
          <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
          <input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
          <input type="hidden" name="RedirectURIAfterPublish" value="{$node.url_alias}" />
          <input type="hidden" name="RedirectIfDiscarded" value="{$node.url_alias}" />
          <input type="hidden" name="NodeID" value="{$node.node_id}" />
          <input type="hidden" name="ClassIdentifier" value="{$class_identifier_map['event']}" />
          <div class="submitimage">
           <div class="emptyButton">
            <input class="mousePointer emptyButton" type="submit" name="NewButton" value="{'Add new event'|i18n( 'ezteamroom/events' )}" />
           </div>
          </div>
         </form>
        </div>

{/if}

        <div class="create-task">
         <form method="post" action={"content/action/"|ezurl}>
          <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
          <div class="keepupdated">
           <div class="arrowWhiteButton">
            <input class="mousePointer arrowWhiteButton" type="submit" name="ActionAddToNotification" value="{'Keep me updated'|i18n( 'ezteamroom/keepmeupdated' )}"
                   title="{'Receive an email if anything changes in this area'|i18n( 'ezteamroom/keepmeupdated' )}" />
           </div>
          </div>
         </form>
        </div>

{if or( $merged_calendar|count()|gt( 0 ), is_set( $view_parameters.filter ) )}

        <div class="categories">
         <h3>{'Filter'|i18n('ezteamroom/events')}</h3>

    {def $selection = hash( 'events' ,     'Events'|i18n('ezteamroom/events'),
                            'tasks' ,      'Tasks'|i18n('ezteamroom/events'),
                            'milestones' , 'Milestones'|i18n('ezteamroom/events') )
         $sorting   = cond( is_set($sort_by_field), concat( "/(sortfield)/", $sort_by_field ) )}

         <div class="tags">
          <ul>

           <li {if is_set( $view_parameters.filter )|not()}class="selected"{/if}>
            <a href={concat( $node.url_alias, $sorting)|ezurl()} title="{'Show all'|i18n( 'ezteamroom/events')|wash()}">{'No filter'|i18n( 'ezteamroom/events')|wash()}</a>
           </li>

    {foreach $selection as $key => $keyword}

        {if and( is_set( $view_parameters.filter ), $view_parameters.filter|eq( $key ) )}

           <li class="selected">
            <a href={concat( $node.url_alias, $sorting)|ezurl()} title="{'Only "%1" are shown'|i18n( 'ezteamroom/events', , array( $keyword ) )|wash()}">{$keyword|wash()}</a>
           </li>

        {else}

           <li>
            <a href={concat( $node.url_alias, "/(filter)/", $key, $sorting )|ezurl()} title="{'Shown only "%1"'|i18n( 'ezteamroom/events', , array( $keyword ) )|wash()}">{$keyword|wash()}</a>
           </li>

        {/if}

    {/foreach}

          </ul>
         </div>
        </div>

{/if}

       </div>
      </div>
     </div>
     <div class="border-bl">
      <div class="border-br">
       <div class="border-bc"></div>
      </div>
     </div>
    </div>
   </div>
  </div>
 </div>
</div>
</div>

{undef $class_identifier_map}