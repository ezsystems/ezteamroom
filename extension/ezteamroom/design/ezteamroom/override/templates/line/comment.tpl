{* Comment - Line view *}

<div class="content-view-line">
    <div class="class-comment float-break">


    <div class="comment_actions float-break">
        {if $node.data_map.enable_comments.data_int}
        <div class="attribute-comments">
        <p>
            <a href={concat( $node.url_alias, "#comments" )|ezurl}><img src={'comment.gif'|ezimage} alt="comment_icon" /></a>
        </p>
        </div>
        {/if}

        {if $node.object.can_edit}
        <div class="attribute-edit">
            <form method="post" action={"content/action"|ezurl}>
                <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
                <input type="hidden" name="NodeID" value="{$node.object.main_node.node_id}" />
                <input type="hidden" name="ContentObjectLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                <input type="image"  src={'task_edit.gif'|ezimage} name="EditButton" value="{'Edit'|i18n( 'ezteamroom/blog' )}" title="{'Edit this comment'|i18n( 'ezteamroom/blog' )}" />
            </form>
        </div>
        {/if}

        {if $node.object.can_remove}
        <div class="attribute-edit">
            <form method="post" action={"content/action/"|ezurl}>
                <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
                <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                <input class="" type="image" src={'task_delete.gif'|ezimage} name="ActionRemove" value="{'Remove'|i18n( 'ezteamroom/blog' )}" title="{'Remove this comment'|i18n( 'ezteamroom/blog' )}" />
            </form>
        </div>
        {/if}
    </div>

    <div class="author">
        <p class="date">{$node.object.published|l10n(datetime)}</p>
        {def $owner=$node.object.owner
            $owner_map=$owner.data_map}
        {if $owner_map.image.has_content}
        <div class="authorimage">
            {attribute_view_gui attribute=$owner_map.image image_class=small}
        </div>
        {/if}
        <p class="author">{$owner.name|wash}</p>

    </div>

    <div class="message">
        <h3>{$node.name|wash}</h3>
        <p>{$node.data_map.message.content|wash(xhtml)|break}</p>
    </div>

    </div>
</div>