{* Event Calendar - Full Program view *}
{def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
     $event_node = $node.node_id
     $curr_ts = currentdate()
     $curr_today = $curr_ts|datetime( custom, '%j')
     $curr_year = $curr_ts|datetime( custom, '%Y')
     $curr_month = $curr_ts|datetime( custom, '%n')
     $temp_oldest_event = ''
     $temp_newest_event = ''

     $temp_offset = cond( ne($view_parameters.offset, ''), $view_parameters.offset, 0)
     $daymode = false()
     $direction = ""
     $newer_event_count = fetch( 'content', 'list_count', hash(
             'parent_node_id', $event_node,
             'class_filter_type',  'include',
             'class_filter_array', array( $class_identifier_map['event'] ),
                'attribute_filter',    array( 'or',
                     array( 'event/from_time', '>=', $curr_ts  ),
                     array( 'event/to_time', '>=', $curr_ts  )
             )    ))
     $older_event_count = fetch( 'content', 'list_count', hash(
             'parent_node_id', $event_node,
             'class_filter_type',  'include',
             'class_filter_array', array( $class_identifier_map['event'] ),
                'attribute_filter',
             array( 'and', array( 'event/from_time', '<', $curr_ts  ),
                     array( 'event/to_time', '<', $curr_ts  )
             )    ))}

{if ge($temp_offset,0)}
{set $temp_offset = $temp_offset|abs}
{def $events = fetch( 'content', 'list', hash(
            'parent_node_id', $event_node,
            'sort_by', array( 'attribute', true(), 'event/from_time' ),
            'class_filter_type',  'include',
            'class_filter_array', array( $class_identifier_map['event'] ),
            'limitation', 15,
            'offset', $temp_offset|mul(15),
            'attribute_filter', array( 'or',
                    array( 'event/from_time', '>=', $curr_ts  ),
                    array( 'event/to_time', '>=', $curr_ts  )
            )    ))
}
{set $newer_event_count = $newer_event_count|sub( 15|mul( $temp_offset|inc ) )}
{else}
{set $temp_offset = $temp_offset|abs|dec
     $direction = "-"}
{def $events = fetch( 'content', 'list', hash(
            'parent_node_id', $event_node,
            'sort_by', array( 'attribute', true(), 'event/from_time' ),
            'class_filter_type',  'include',
            'class_filter_array', array( $class_identifier_map['event'] ),
            'limitation', 15,
            'offset', $temp_offset|mul(15),
            'attribute_filter', array( 'and',
                    array( 'event/from_time', '<', $curr_ts  ),
                    array( 'event/to_time', '<', $curr_ts  )
            )))
}
{set $older_event_count = $older_event_count|sub( 15|mul( $temp_offset|inc ) )}
{/if}

{undef $class_identifier_map}

{foreach $events as $event}
{if or(eq($temp_newest_event,''),gt($event.object.data_map.from_time.content.timestamp, $temp_newest_event))}
    {set $temp_newest_event=$event.object.data_map.from_time.content.timestamp}
{/if}
{if or(eq($temp_oldest_event,''),lt($event.object.data_map.from_time.content.timestamp, $temp_oldest_event))}
    {set $temp_oldest_event=$event.object.data_map.from_time.content.timestamp}
{/if}
{/foreach}

{if eq($temp_oldest_event|datetime(custom,"%M"),  $temp_newest_event|datetime(custom,"%M"))}
{set $daymode=true()}
{/if}

<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-view-full">
 <div class="class-event-calendar event-calendar-programview">

<div class="attribute-header">
    <h1>{$node.name|wash()}</h1>
</div>

<div id="ezagenda_calendar_right">
    {foreach $events as $event}
    <table class="ezagenda_month_event" cellpadding="0" cellspacing="0"{if gt($curr_ts , $event.object.data_map.to_time.content.timestamp)} class="ezagenda_event_old"{/if} summary="Previw of event">
    <tr>
    {if $daymode}
    <td  class="ezagenda_month_label"><h2>{$event.object.data_map.from_time.content.timestamp|datetime(custom,"%j %M")}</h2></td>
    {else}
    <td class="ezagenda_month_label"><h2>{$event.object.data_map.from_time.content.timestamp|datetime(custom,"%M<br />%y")}</h2></td>
    {/if}
    <td class="ezagenda_month_info">

    <h4><a href={$event.url_alias|ezurl}>{$event.name|wash}</a></h4>

    <p>
    <span class="ezagenda_date">
    {$event.object.data_map.from_time.content.timestamp|datetime(custom,"%H:%i")}
    {if $event.object.data_map.to_time.has_content}
        {if $event.object.data_map.to_time.content.day|int()|eq( $event.object.data_map.from_time.content.day|int() )}
        - {$event.object.data_map.to_time.content.timestamp|datetime(custom,"%H:%i")}
        {else}
        - {$event.object.data_map.to_time.content.timestamp|datetime(custom,"%j %M %H:%i")}
        {/if}
    {/if}
    </span>

    {if $event.object.data_map.category.has_content}
        <span class="ezagenda_keyword">
        {attribute_view_gui attribute=$event.object.data_map.category}
        </span>
    {/if}
    </p>

    {if $event.object.data_map.text.has_content}
        <div class="attribute-short">{attribute_view_gui attribute=$event.object.data_map.text}</div>
    {/if}

    </td>
    </tr>
    </table>

    {/foreach}
</div>
<div class="block">
{if $direction}{* '-' direction  *}
    <div class="left">
    {if $older_event_count|gt(0)}
        <a href={concat("/content/view/full/",  $node.node_id, "/offset/-", $temp_offset|sum(2))|ezurl}>&lt;&lt; {"Past events"|i18n("ezteamroom/events")}</a>
    {/if}
    </div>
    <div class="right">
    {if $temp_offset|gt(0)}
        <a href={concat("/content/view/full/",  $node.node_id, "/offset/-", $temp_offset)|ezurl}>{"Future events"|i18n("ezteamroom/events")} &gt;&gt;</a>
    {elseif $newer_event_count|gt(0)}
        <a href={concat("/content/view/full/",  $node.node_id, "/offset/0")|ezurl}>{"Future events"|i18n("ezteamroom/events")} &gt;&gt;</a>
    {/if}
    </div>
{else}
    <div class="left">
    {if $temp_offset|gt(0)}
        <a href={concat("/content/view/full/",  $node.node_id, "/offset/", $temp_offset|dec)|ezurl}>&lt;&lt; {"Past events"|i18n("ezteamroom/events")}</a>
    {elseif $older_event_count|gt(0)}
        <a href={concat("/content/view/full/",  $node.node_id, "/offset/-1")|ezurl}>&lt;&lt; {"Past events"|i18n("ezteamroom/events")}</a>
    {/if}
    </div>
    <div class="right">
    {if $newer_event_count|gt(0)}
        <a href={concat("/content/view/full/",  $node.node_id, "/offset/", $temp_offset|inc)|ezurl}>{"Future events"|i18n("ezteamroom/events")} &gt;&gt;</a>
    {/if}
    </div>
{/if}
</div>
{undef}
</div>
</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>