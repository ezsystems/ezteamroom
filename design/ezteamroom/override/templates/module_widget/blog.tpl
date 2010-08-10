{def $hasPFBox = false()}

{if is_set( $view_parameters.pfbox )}

    {if $view_parameters.pfbox|eq( '1' )}

        {set $hasPFBox = true()}

<!--PFBOXCONTENT-->
<div class="pf_box">

    {/if}

{/if}

<div class="latest-messages itemized_sub_items">
<div class="content-view-embed">

    <div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">
{def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
             $children     = fetch( 'content', 'tree', hash( 'parent_node_id',    $node.node_id,
                                                             'limit',             1,
                                                             'class_filter_type', 'include',
                                                             'class_filter_array', array( $class_identifier_map['blog_post'] ),
                                                             'sort_by',            array( 'published', false() ) ) )}

{undef $class_identifier_map}

{if $children|count()}
{def $child=$children.0}

<div class="listitem_blog">
    <div class="header float-break">
        <span class="date">{$child.object.published|l10n('shortdate')}</span>
        <span class="owner">{$child.object.owner.name|wash()|shorten(10)}</span>
    </div>
    <div class="tags"><strong>{'Tags'|i18n('ezteamroom/blog')}: </strong>
        {foreach $child.data_map.tags.content.keywords as $keyword}
            <a href={concat( $child.parent.url_alias, "/(id)/", $child.parent.node_id, "/(tag)/", $keyword|rawurlencode )|ezurl} title="{$keyword}">{$keyword|wash()}</a>
            {delimiter}, {/delimiter}
        {/foreach}
    </div>
    <div class="content">
        <div class="title">{attribute_view_gui attribute=$child.data_map.title}</div>
        <span class="message">{$child.data_map.body.content.output.output_text|striptags|shorten(180)}</span>
        <span class="more"><a href={$child.url_alias|ezurl}>{"more..."|i18n("ezteamroom/blog")}</span>
    </div>
</div>



{else}
    <p>{"There are no blog post."|i18n("ezteamroom/blog")}</p>
{/if}

    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>

</div>
</div>

{if $hasPFBox}

</div>

{/if}

