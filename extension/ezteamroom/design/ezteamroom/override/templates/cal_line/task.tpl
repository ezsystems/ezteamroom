<div class="content-view-line">

    <div class="class-event float-break">

    <div class="event-type cal_entry_task">
     </div>

    <div class="blog_actions float-break">

{*        {if $object.can_edit}
        <div class="attribute-edit">
            <form method="post" action={"content/action"|ezurl}>
                <input type="hidden" name="ContentObjectID" value="{$object.id}" />
                <input type="hidden" name="NodeID" value="{$object.main_node_id}" />
                <input type="hidden" name="ContentObjectLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                <input type="hidden" name="RedirectURIAfterPublish" value="{$redirect}" />
                <input type="hidden" name="RedirectIfDiscarded" value="{$redirect}" />
                <input type="image"  src={'task_edit.gif'|ezimage} name="EditButton" value="{'Edit'|i18n( 'ezteamroom/events' )}" />
            </form>
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
        {/if}*}
    </div>

        <h2><a href={$object.main_node.parent.url_alias|ezurl} title="{$object.data_map.title.content|wash}">{$object.data_map.title.content|wash}</a></h2>

        <h4>{$object.data_map.planned_end_date.content.timestamp|l10n(shortdatetime)}</h4>

        {if $object.data_map.description.has_content}
            <div class="attribute-short">{$object.data_map.description.content|striptags()|shorten(180)|wash()}</div>
        {/if}


    </div>
</div>

