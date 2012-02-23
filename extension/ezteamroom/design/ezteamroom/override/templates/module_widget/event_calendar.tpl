{def $hasPFBox = false()}

{if is_set( $view_parameters.pfbox )}

    {if $view_parameters.pfbox|eq( '1' )}

        {set $hasPFBox = true()}

<!--PFBOXCONTENT-->
<div class="pf_box">

    {/if}

{/if}

 <div class="content-view-embed">
  <div class="class-event-calendar">

{def $curr_ts    = currentdate()
     $curr_today = $curr_ts|datetime( custom, '%j')
     $curr_year  = $curr_ts|datetime( custom, '%Y')
     $curr_month = $curr_ts|datetime( custom, '%n')
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
     $selected_today = $selected_ts|datetime( custom, '%j')

     $days = $selected_ts|datetime( custom, '%t')

     $first_ts = makedate($selected_month, 1, $selected_year)
     $last_ts  = makedate($selected_month, $days, $selected_year)
     $daylast  = $last_ts|datetime( custom, '%w' )

     $span1 = $first_ts|datetime( custom, '%w' )
     $span2 = sub( 7, $daylast )

     $dayofweek    = 0
     $day_array    = " "
     $loop_dayone  = 1
     $loop_daylast = 1
     $day_events   = array()
     $next_month   = sum( $selected_month, 1 )
     $prev_month   = sub( $selected_month, 1 )
     $next_year    = $selected_year
     $prev_year    = $selected_year

     $box_object_id = $view_parameters.object}

{if ne( $selected_month, 12 )}

    {set $last_ts = makedate( $selected_month|sum( 1 ), 1, $selected_year )}

{else}

    {set $last_ts = makedate( 1, 1, $selected_year|sum( 1 ) )}

{/if}

{def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
     $events               = fetch( 'event', 'list', hash( 'year',           $selected_year,
                                                           'month',          $selected_month,
                                                           'parent_node_id', $node.node_id
                                                         )
                                  )
     $merged_calendar      = merge_events( $events )
     $next_events          = array()
     $url_back    = concat( 'content/view/module_widget/', $node.node_id, "/(month)/", sub( $selected_month, 1 ), "/(year)/", $selected_year, "/(object)/", $box_object_id )
     $url_forward = concat( 'content/view/module_widget/', $node.node_id, "/(month)/", sum( $selected_month, 1 ), "/(year)/", $selected_year, "/(object)/", $box_object_id )
}

{undef $class_identifier_map}

{if eq( $selected_month, 1 )}

    {set   $url_back = concat( 'content/view/module_widget/', $node.node_id,  "/(month)/", "12", "/(year)/", sub( $selected_year, 1 ), "/(object)/", $box_object_id )
         $prev_month = 12
          $prev_year = $prev_year|dec()}

{elseif eq($selected_month, 12)}

    {set $url_forward = concat( 'content/view/module_widget/',$node.node_id,  "/(month)/", "1", "/(year)/", sum( $selected_year, 1 ), "/(object)/", $box_object_id )
          $next_month = 1
           $next_year = $next_year|inc}

{/if}

{foreach $merged_calendar as $date => $event}

    {* Add to list of today events, if mit matches *}
    {if and( eq( $selected_year|int(),  $date|datetime( 'custom', '%Y' )|int() )
             eq( $selected_month|int(), $date|datetime( 'custom', '%n' )|int() )
             eq( $selected_today|int(), $date|datetime( 'custom', '%j' )|int() )
           )}

        {set $day_events = $day_events|append( $event )}

    {else}

        {set $next_events = $next_events|append( $event )}

    {/if}

{/foreach}

   <div id="ezagenda_calendar_container">
    <table cellspacing="0" cellpadding="0" border="0" summary="Event Calendar">
     <thead>
      <tr class="calendar_heading">
       <th class="calendar_heading_prev first_col" colspan="2">
        <a href="#" title=" Previous month " onclick="javascript:addModuleWidget( {$box_object_id}, '{$url_back}' ); LoadModule( '{$box_object_id}', '(pfbox)/1' ); return false;">

{if $curr_year|ne( $prev_year )}

    {mytime( 0, 0, 0, $prev_month, 15, $curr_year|int() )|datetime( custom, '%M' )|upfirst()}

    {$prev_year}

{else}

    {mytime( 0, 0, 0, $prev_month, 15, $curr_year|int() )|datetime( custom, '%F' )|upfirst()}

{/if}

        </a>
       </th>
       <th class="calendar_heading_date" colspan="3">

{if $curr_year|ne( $selected_year )}

    {$selected_ts|datetime( custom, '%M' )|upfirst()}

    {$selected_year}

{else}

    {$selected_ts|datetime( custom, '%F' )|upfirst()}

{/if}

       </th>
       <th class="calendar_heading_next last_col" colspan="2">
        <a href="#" title=" Next Month " onclick="javascript:addModuleWidget( {$box_object_id}, '{$url_forward}' ); LoadModule( '{$box_object_id}', '(pfbox)/1' ); return false;">

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
       <th class="first_col">{"Mon"|i18n( "ezteamroom/events" )|wash()}</th>
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

       <td class="{if eq( $day_of_month, $selected_today )}ezagenda_selected{/if} {if and( eq( $day_of_month, $curr_today ), eq( $curr_month, $selected_month ) )}ezagenda_current{/if}{$css_col_class}">

    {if $day_array|contains(concat(' ', $day_of_month, ',')) }

        <a href={concat( $node.url_alias, "/(day)/", $day_of_month, "/(month)/", $selected_month, "/(year)/", $selected_year )|ezurl()}>{$day_of_month|wash()}</a>

    {else}

        {$day_of_month}

    {/if}

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

     </tbody>
    </table>
    <div class="block">
     <div id="sidebar_calendar_today">
      <h5>{"Today"|i18n( "ezteamroom/events" )|wash()}</h5>
      <div class="float-break">


{if $day_events|count()|gt( 0 )}

    {foreach $day_events as $event}

       <span class="ezagenda_date">

        {'%1 - %2'|i18n( 'ezteamroom/events', , array( $event.data_map.event_date.content.start_date|l10n( 'shorttime' ), $event.data_map.event_date.content.end_date||l10n( 'shorttime' ) ) )}

       </span>
       <a href={$event.main_node.url_alias|ezurl}>{$event.name|wash()}</a>

    {/foreach}

{else}

    {"No events"|i18n( "ezteamroom/events" )|wash()}

{/if}

      </div>
     </div>

{if $next_events|count()|gt( 0 )}

     <div id="sidebar_calendar_today">
      <h5>{"Next days"|i18n("ezteamroom/events")|wash()}</h5>
      <div class="float-break">

    {foreach $next_events as $event max 3}

      <span class="ezagenda_date">

        {$event.data_map.event_date.content.start_date|l10n( 'shortdatetime' )}

      </span>
      <a href={$event.main_node.url_alias|ezurl()}>{$event.name|wash()}</a>

    {/foreach}

      </div>
     </div>

{/if}

    </div>
   </div>
  </div>
 </div>

{if $hasPFBox}

</div>

{/if}

