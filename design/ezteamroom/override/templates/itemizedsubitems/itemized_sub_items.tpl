<div class="content-view-embed">
    <div class="class-{$object.class_identifier}">
    <div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

{def $children = array()
        $limit = 5
     $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}


{set $children = fetch( content, list, hash( 'parent_node_id', $object.main_node_id,
                                                         'limit', $limit,
                                                         'class_filter_type', 'exclude',
                                                         'class_filter_array', array( $class_identifier_map['infobox'], $class_identifier_map['boxfolder'] ),
                                                         'sort_by', $object.main_node.sort_array ) ) }

{undef $class_identifier_map}

    {if $children|count()}

    <ul>
    {foreach $children as $child}
       <li><div><a href={$child.url_alias|ezurl}>{node_view_gui content_node=$child view='listitem'}</a></div></li>
    {/foreach}
    </ul>

        <div class="infobox-link">
            <a href={concat("/content/view/teamrooms/",$object.main_node_id)|ezurl} title="{"Browse all"|i18n("ezteamroom/files")}">{"Browse all"|i18n("ezteamroom/files")}</a>
        </div>
    {/if}

    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>

    </div>
</div>
