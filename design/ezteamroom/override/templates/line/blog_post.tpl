{* Blog post - Line view *}
<div class="content-view-line">
    <div class="class-blog-post float-break">

    <div class="blog_actions float-break">
        {if $node.data_map.enable_comments.data_int}
        <div class="attribute-comments">
        <p>
            <a href={concat( $node.url_alias, "#comments" )|ezurl}><img src={'comment.gif'|ezimage} alt="comment_icon" title="{'Show the comments to this post'|i18n( 'ezteamroom/blog' )}" /></a>
        </p>
        </div>
        {/if}

        {if $node.object.can_edit}
        <div class="attribute-edit">
            <form method="post" action={"content/action"|ezurl}>
                <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
                <input type="hidden" name="NodeID" value="{$node.object.main_node.node_id}" />
                <input type="hidden" name="ContentObjectLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                <input type="hidden" name="RedirectURIAfterPublish" value="{$node.parent.url_alias}" />
                <input type="hidden" name="RedirectIfDiscarded" value="{$node.parent.url_alias}" />
                <input type="image"  src={'task_edit.gif'|ezimage} name="EditButton" value="{'Edit'|i18n( 'ezteamroom/blog' )}" title="{'Edit this post'|i18n( 'ezteamroom/blog' )}" />
            </form>
        </div>
        {/if}

        {if $node.object.can_remove}
        <div class="attribute-edit">
            <form method="post" action={"content/action/"|ezurl}>
                <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
                <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                <input type="image" src={'task_delete.gif'|ezimage} name="ActionRemove" value="{'Remove'|i18n( 'ezteamroom/blog' )}" title="{'Remove this post'|i18n( 'ezteamroom/blog' )}" />
            </form>
        </div>
        {/if}
    </div>

    <div class="attribute-byline">
        <span class="date">{$node.data_map.publication_date.content.timestamp|l10n(shortdatetime)}</span> |
        <span class="author"><strong>{'Author'|i18n('ezteamroom/blog')} </strong>{$node.object.owner.name|wash()}</span>
     </div>

    <div class="attribute-header">
        <h1><a href={$node.url_alias|ezurl} title="{$node.data_map.title.content|wash}">{$node.data_map.title.content|wash}</a></h1>
     </div>


        <div class="attribute-body">
            {attribute_view_gui attribute=$node.data_map.body}
        </div>

    <div class="attribute-byline">
        <p class="tags">
        {if $node.data_map.tags.content.keywords|count()|eq(0)}
            {'No Tags'|i18n( 'ezteamroom/blog' )}
        {else}
            {'Tags'|i18n( 'ezteamroom/blog' )}:
            {foreach $node.data_map.tags.content.keywords as $keyword}
                <a href={concat( $node.parent.url_alias, "/(tag)/", $keyword|rawurlencode )|ezurl} title="{$keyword}">{$keyword|wash()}</a>
                {delimiter},{/delimiter}
            {/foreach}
        {/if}
        </p>
    </div>



    </div>
</div>
