{* Folder - Full view *}

<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-view-full">
    <div class="class-folder">

        <div class="attribute-header">
            <h1>{attribute_view_gui attribute=$node.data_map.name}</h1>
        </div>

        {if eq( ezini( 'folder', 'SummaryInFullView', 'content.ini' ), 'enabled' )}
            {if $node.object.data_map.short_description.has_content}
                <div class="attribute-short">
                    {attribute_view_gui attribute=$node.data_map.short_description}
                </div>
            {/if}
        {/if}

        {if $node.object.data_map.description.has_content}
            <div class="attribute-long">
                {attribute_view_gui attribute=$node.data_map.description}
            </div>
        {/if}

        {if $node.object.data_map.show_children.data_int}
            {if ezpreference( 'teamroom_folder_list_limit' )}
                {def $default_limit = ezpreference( 'teamroom_folder_list_limit' )}
            {/if}
            {if $view_parameters.limit|gt(0)}
                {set $page_limit = $view_parameters.limit}
            {/if}
            {def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
                 $page_limit = first_set( $default_limit, 5 )
                 $classes = array( $class_identifier_map['infobox'] )
                 $children = array()
                 $children_count = ''}

            {if le( $node.depth, '3')}
                {set $classes=array( $class_identifier_map['infobox'], 'folder' )}
            {/if}

            {set $children_count=fetch_alias( 'children_count', hash( 'parent_node_id', $node.node_id,
                                                                      'class_filter_type', 'exclude',
                                                                      'class_filter_array', $classes ) )
                 $children=fetch_alias( 'children', hash( 'parent_node_id', $node.node_id,
                                                          'offset', $view_parameters.offset,
                                                          'sort_by', $node.sort_array,
                                                          'class_filter_type', 'exclude',
                                                          'class_filter_array', $classes,
                                                          'limit', cond($page_limit|eq(-1), $children_count, $page_limit ) ) )}
            {undef $class_identifier_map}
            <div class="content-view-children">
                {foreach $children as $child }
                    {node_view_gui view='line' content_node=$child}
                {/foreach}
            </div>

            {include name=navigator
                     uri='design:navigator/google.tpl'
                     page_uri=$node.url_alias
                     item_count=$children_count
                     view_parameters=$view_parameters
                     item_limit=$page_limit
                     preference      = "teamroom_folder_list_limit"}

        {/if}
    </div>
</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>