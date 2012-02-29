<div class="content-view-line">

{def $eventDateContent = $object.data_map.event_date.content}

    <div class="class-event float-break">

        <div class="event-type cal_entry_event">
        </div>

        <div class="blog_actions float-break">

            {if $object.can_edit}
            <div class="attribute-edit">
                <form method="post" action={"content/action"|ezurl}>
                    <input type="hidden" name="ContentObjectID" value="{$object.id}" />
                    <input type="hidden" name="NodeID" value="{$object.main_node_id}" />
                    <input type="hidden" name="ContentObjectLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                    <input type="hidden" name="RedirectURIAfterPublish" value="{$redirect}" />
                    <input type="hidden" name="RedirectIfDiscarded" value="{$redirect}" />
                    <input type="image"  src={'event_edit_all.png'|ezimage} name="EditButton" value="{'Edit complete event'|i18n( 'ezteamroom/events' )}" title="{'Edit event'|i18n( 'ezteamroom/events' )}" />
                </form>
            </div>
            {/if}

            {if and( $object.can_edit,
                     fetch( 'user', 'has_access_to', hash( 'module', 'event', 'function', 'split' ) ),
                     array( 15, 16, 17 )|contains( $eventDateContent.event_type )
                   )}
            <div class="attribute-edit">
                <a href={concat("/event/split/", $object.id, "/", $event_date, "/", ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini'))|ezurl()}>
                    <img src={'event_edit_single.png'|ezimage} alt="{'Edit single event'|i18n( 'ezteamroom/events' )}" title="{'Edit single date of recurring event'|i18n( 'ezteamroom/events' )}" />
                </a>
            </div>
            {/if}

            {if $object.can_remove}
            <div class="attribute-edit">
                <form method="post" action={"content/action/"|ezurl}>
                    <input type="hidden" name="ContentObjectID" value="{$object.id}" />
                    <input type="hidden" name="ContentNodeID" value="{$object.main_node_id}" />
                    <input class="" type="image" src={'task_delete.gif'|ezimage} name="ActionRemove" value="{'Remove'|i18n( 'ezteamroom/events' )}" title="{'Remove this item.'|i18n( 'ezteamroom/events' )}" />
                </form>
            </div>
            {/if}
        </div>

        <h2><a href={$object.main_node.url_alias|ezurl} title="{$object.name|wash()}">{$object.name|wash()}</a></h2>
        
        {def $content=$object.data_map.event_date.content}
        <h4>
        {switch match=$content.event_type}
        {case match=11} {* Normal *}
            {if $content.start.is_valid}{$content.start.timestamp|l10n(shortdatetime)}{/if}
            {if $content.end.is_valid} - {$content.end.timestamp|l10n(shortdatetime)}{/if}
        {/case}
        {case match=12} {* Full day *}
            {if $content.start.is_valid}{$content.start.timestamp|l10n(shortdate)}{/if}
            {if $content.end.is_valid} - {$content.end.timestamp|l10n(shortdate)}{/if}
        {/case}
        {case match=15} {* Weekly *}
            {if $content.start.is_valid}Every {$content.start.timestamp|datetime('custom', '%l')} ({$content.start.timestamp|l10n(shortdate)}-{$content.end.timestamp|l10n(shortdate)}){/if}
        {/case}
        {case match=16} {* Monthly *}
            {if $content.start.is_valid}Every {$content.start.timestamp|datetime('custom', '%d')}. a month.{/if}
        {/case}
        {case match=17} {* Yearly *}
            {if $content.start.is_valid}{$content.start.day}.{$content.start.month}.{/if}
        {/case}
        {/switch}
        </h4>

        {if $object.data_map.category.has_content}
           <div class="attribute-short"><h5>{"Category"|i18n('ezteamroom/events')}:{attribute_view_gui attribute=$object.data_map.category}</h5></div>
        {/if}


        {if $object.data_map.location.has_content}
            <div class="attribute-short"><h5>{'Location'|i18n( 'ezteamroom/events' )}:{attribute_view_gui attribute=$object.data_map.location}</h5></div>
        {/if}

        {def  $attendeeCount = $eventDateContent.attendees|count()
             $attendeeObject = false()}

            <div class="attribute-short">

        {if $attendeeCount|gt( 0 )}

             <h5 onmouseover="document.getElementById( 'event_attendee_list_{$eventDateContent.id}_{$event_date}' ).style.display = 'block';" onmouseout="document.getElementById( 'event_attendee_list_{$eventDateContent.id}_{$event_date}' ).style.display = 'none';">{'Attendees '|i18n( 'ezteamroom/events' )|wash()}: {$attendeeCount}</h5>

        {else}

             <h5>{'Attendees '|i18n( 'ezteamroom/events' )|wash()}: {'None'|i18n( 'ezteamroom/events' )}</h5>

        {/if}

             <div id="event_attendee_list_{$eventDateContent.id}_{$event_date}" style="display: none;">

            {foreach $eventDateContent.attendees as $attendee}

                {set $attendeeObject = fetch( 'content', 'object', hash( 'object_id', $attendee.contentobject_id ) )}

                {if $attendeeObject}

                    {$attendeeObject.name|wash()}<br />

                {/if}

            {/foreach}

             </div>
            </div>

        {if $object.data_map.text.has_content}
            <div class="attribute-short">{$object.data_map.text.content.output.output_text|striptags|shorten(180)|wash()}</div>
        {/if}


    </div>
</div>
