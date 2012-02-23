{* set-block scope=root variable=cache_ttl}600{/set-block *} {* ab: Commented out to find a better way if possible *}

{* Event - Full view *}

<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-view-full">
    <div class="class-event">

        <div class="attribute-header">
            <h1>{$node.name|wash()}</h1>
        </div>
        <div class="box_background">
            <div class="float-left content_width">
                <div class="attribute-byline">
                    <p>
                    {if $node.object.data_map.category.has_content}
                    <span class="ezagenda_keyword">
                    {"Category"|i18n('ezteamroom/events')}:
                    {attribute_view_gui attribute=$node.object.data_map.category}
                    </span>
                    {/if}
                    </p>
                    <p>
                    <span class="ezagenda_date">

        {def $eventDateContent = $node.data_map.event_date.content}

        {switch match = $eventDateContent.event_type}
        {case match=11} {* Normal *}
            {if and( $eventDateContent.start.is_valid, $eventDateContent.end.is_valid )}

                {'From %1 to %2'|i18n( 'ezteamroom/events', , array( $eventDateContent.start.timestamp|l10n( 'shortdatetime' ), $eventDateContent.end.timestamp|l10n( 'shortdatetime' ) ) )|wash()}

            {else}

                {'Invalid date'|i18n( 'ezteamroom/events' )|wash()}

            {/if}
        {/case}
        {case match=12} {* Full day *}
            {if and( $eventDateContent.start.is_valid, $eventDateContent.end.is_valid )}

                {'From %1 to %2'|i18n( 'ezteamroom/events', , array( $eventDateContent.start.timestamp|l10n( 'shortdate' ), $eventDateContent.end.timestamp|l10n( 'shortdate' ) ) )|wash()}

            {else}

                {'Invalid date'|i18n( 'ezteamroom/events' )|wash()}

            {/if}
        {/case}
        {case match=15} {* Weekly *}

            {if $eventDateContent.start.is_valid}


                {'Weekly on %1 from %2 to %3'|i18n( 'ezteamroom/events', , array( $eventDateContent.start.timestamp|datetime( 'custom', '%l' ), $eventDateContent.start.timestamp|l10n( 'shortdate' ), $eventDateContent.end.timestamp|l10n( 'shortdate' ) ) )|wash()}

            {else}

                {'Invalid date'|i18n( 'ezteamroom/events' )|wash()}

            {/if}

        {/case}
        {case match=16} {* Monthly *}

            {if $eventDateContent.start.is_valid}

                {'Monthly each %1.'|i18n( 'ezteamroom/events', , array( $eventDateContent.start.timestamp|datetime( 'custom', '%d' ) ) )|wash()}

            {else}

                {'Invalid date'|i18n( 'ezteamroom/events' )|wash()}

            {/if}

        {/case}
        {case match=17} {* Yearly *}

            {if $eventDateContent.start.is_valid}

                {'Yearly the %1/%2'|i18n( 'ezteamroom/events', , array( $eventDateContent.start.day, $eventDateContent.start.month ) )|wash()}

            {else}

                {'Invalid date'|i18n( 'ezteamroom/events' )|wash()}

            {/if}

        {/case}
        {/switch}

                    </span>
                    </p>
                </div>
                {if $node.object.data_map.location.has_content}
                    <div class="attribute-short">{'Location'|i18n( 'ezteamroom/events' )}:{attribute_view_gui attribute=$node.object.data_map.location}</div>
                {/if}
                {if $node.object.data_map.text.has_content}
                    <div class="attribute-short">{attribute_view_gui attribute=$node.object.data_map.text}</div>
                {/if}

        {def  $attendeeCount = $eventDateContent.attendees|count()
             $attendeeObject = false()}

            <div class="attribute-short">

        <p>{'Attendees'|i18n( 'ezteamroom/events' )}:</p>

        {if $attendeeCount|gt( 0 )}

             <ul>

            {foreach $eventDateContent.attendees as $attendee}

                {set $attendeeObject = fetch( 'content', 'object', hash( 'object_id', $attendee.contentobject_id ) )}

                {if $attendeeObject}

                    <li>{$attendeeObject.name|wash()}</li>

                {/if}

            {/foreach}

             </ul>

        {else}

             {'None'|i18n( 'ezteamroom/events' )}

        {/if}

            </div>

            </div>
            <div class="blog_actions">
                {if $node.object.can_edit}
                <div class="attribute-edit">
                    <form method="post" action={"content/action"|ezurl}>
                        <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
                        <input type="hidden" name="NodeID" value="{$node.object.main_node.node_id}" />
                        <input type="hidden" name="ContentObjectLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                        <input type="image"  src={'event_edit_all.png'|ezimage()} name="EditButton" value="{'Edit complete event'|i18n( 'ezteamroom/events' )}" title="{'Edit complete event'|i18n( 'ezteamroom/events' )}" />
                    </form>
                </div>
                {/if}
            {if and( $node.object.can_edit,
                     fetch( 'user', 'has_access_to', hash( 'module', 'event', 'function', 'split' ) ),
                     array( 15, 16, 17 )|contains( $eventDateContent.event_type )
                   )}
            <div class="attribute-edit">
                <a href={concat("/event/split/", $node.object.id, "/", $event_date, "/", ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini'))|ezurl()}>
                    <img src={'event_edit_single.png'|ezimage} alt="{'Edit single event'|i18n( 'ezteamroom/events' )}" title="{'Edit single event'|i18n( 'ezteamroom/events' )}" />
                </a>
            </div>
            {/if}
                {if $node.object.can_remove}
                <div class="attribute-edit">
                    <form method="post" action={"content/action/"|ezurl}>
                        <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
                        <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                        <input class="" type="image" src={'task_delete.gif'|ezimage} name="ActionRemove" value="{'Remove'|i18n( 'ezteamroom/events' )}" title="{'Remove this event'|i18n( 'ezteamroom/events' )}" />
                    </form>
                </div>
                {/if}
            </div>
            <div class="float-break"></div>
        </div>
    </div>
</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
