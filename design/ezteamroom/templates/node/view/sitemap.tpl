{def $page_limit=10
     $col_count=2
     $sub_children=0
     $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
     $children=fetch('content','list',hash('parent_node_id', $node.node_id,
                                            'limit', $page_limit,
                                            'class_filter_type', 'exclude',
                                            'class_filter_array', array( $class_identifier_map['boxfolder'] ),
                                           'offset', $view_parameters.offset,
                                           'sort_by', $node.sort_array))}
<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-view-sitemap">

<div class="attribute-header">
    <h1 class="long">{"Site map"|i18n("ezteamroom/teamroom")} {$node.name|wash}</h1>
</div>

{if $children|count()}

<table width="100%" cellspacing="0" cellpadding="4">
<tr>
{foreach $children as $key => $child}
    <td>
    <h2><a href={$child.url_alias|ezurl}>{$child.name|wash()}</a></h2>
    {if $child.class_identifier|eq( 'event_calendar' )}
        {set $sub_children=fetch('content','list',hash( 'parent_node_id', $child.node_id,
                                                        'limit', $page_limit,
                                            'class_filter_type', 'exclude',
                                            'class_filter_array', array( $class_identifier_map['boxfolder'] ),
                                                        'sort_by', array( 'attribute', false(), 'event/from_time' ) ) )}
    {else}
        {set $sub_children=fetch('content','list',hash( 'parent_node_id', $child.node_id,
                                                        'limit', $page_limit,
                                            'class_filter_type', 'exclude',
                                            'class_filter_array', array( $class_identifier_map['boxfolder'] ),
                                                        'sort_by', $child.sort_array))}
    {/if}
    <ul>
    {foreach $sub_children as $sub_child}
    <li><a href={$sub_child.url_alias|ezurl}>{$sub_child.name|wash()}</a></li>
    {/foreach}
    </ul>
    </td>
    {if ne( $key|mod($col_count), 0 )}
</tr>
<tr>
    {/if}
{/foreach}

{undef $class_identifier_map}

</tr>
</table>

{else}

    {'There are no Teamrooms yet'|i18n( 'ezteamroom/teamroom' )|wash()}

{/if}

</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
