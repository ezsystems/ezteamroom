{def $teamroom_class_id    = ezini( 'TeamroomSettings', 'TeamroomClassID', 'teamroom.ini' )
     $can_create_team_room = false()
     $max_items_to_show    = ezini( 'TeamroomSettings', 'MaxEntryCount', 'teamroom.ini' )
     $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
     $hasPFBox             = false()}

{if is_set( $view_parameters.pfbox )}

    {if $view_parameters.pfbox|eq( '1' )}

        {set $hasPFBox = true()}

<!--PFBOXCONTENT-->
<div class="pf_box">

    {/if}

{/if}

<div class="teamroom-list itemized_sub_items">
<div class="content-view-embed">

    <div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

    {def $children = fetch( content, list, hash( 'parent_node_id', $node.node_id,
                                                 'limit', $max_items_to_show,
                                                 'class_filter_type', 'include',
                                                 'class_filter_array', array( $class_identifier_map['teamroom'] ),
                                                 'sort_by', $node.sort_array,
                                               ) )}
    {def $children_count = fetch( content, list_count, hash( 'parent_node_id',     $node.node_id,
                                                             'class_filter_type',  'include',
                                                             'class_filter_array', array( $class_identifier_map['teamroom'] ),
                                                            ) )}

{undef $class_identifier_map}

    {if $children_count|gt( 0 )}

    <ul>
    {foreach $children as $child}
        <li><div><a href={$child.url_alias|ezurl}>{node_view_gui content_node=$child view='listitem'}</a></div></li>
    {/foreach}
    </ul>

    <div class="infobox-link">
    {if $max_items_to_show|lt( $children_count )}
        <a href={concat( 'content/view/allteamrooms/', $node.node_id )|ezurl()} title="{'Edit'|i18n('ezteamroom/teamroom')}">
        {'Browse all'|i18n('ezteamroom/teamroom')}</a>
    {/if}
    </div>

    {else}

    <p>{'No teamroom has been created yet.'|i18n('ezteamroom/teamroom')}</p>

    {/if}

    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>

</div>
</div>

{if $hasPFBox}

</div>

{/if}

