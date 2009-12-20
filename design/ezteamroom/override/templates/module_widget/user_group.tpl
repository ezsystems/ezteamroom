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
{def $children     = fetch( 'content', 'tree', hash( 'parent_node_id',    $node.node_id,
                                                     'limit',             5,
                                                     'depth',             2,
                                                     'class_filter_type', 'include',
                                                     'class_filter_array', array( 'user' ),
                                                     'sort_by',            array( 'published', false() ) ) )}

{if $children|count()}
    <ul>
    {foreach $children as $child}
        <li><div><a href={$child.url_alias|ezurl}>{node_view_gui content_node=$child view='listitem'}</a></div></li>
    {/foreach}
    </ul>
{else}
    <p>{"There are no users."|i18n("ezteamroom/membership")}</p>
{/if}

    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>

</div>
</div>

{if $hasPFBox}

</div>

{/if}

