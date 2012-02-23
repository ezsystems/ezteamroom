<div class="content-view-embed">
    {def $children = array()
         $limit = 3
         $offset = 0
         $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}

    {if is_set( $object_parameters.limit )}
        {set $limit = $object_parameters.limit}
    {/if}

    {if is_set( $object_parameters.offset )}
        {set $offset = $object_parameters.offset}
    {/if}

    {set $children=fetch( 'content', 'list', hash( 'parent_node_id', $object.main_node_id,
                                               'limit', $limit,
                                               'offset', $offset,
                                               'class_filter_type', 'exclude',
                                               'class_filter_array', array( $class_identifier_map['infobox'] ),
                                               'sort_by', $object.main_node.sort_array ) ) }

    {undef $class_identifier_map}

    <h2>{$object.name|wash()}</h2>
<div class="border-box box-3">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

         <div class="split float-break">
                                <div class="three-left">
                                    <div class="split-content">
                                        <!-- Content: START -->
                                        {if is_set( $children.0 )}
                                        {node_view_gui view=horizontallylistedsubitems content_node=$children.0}
                                        {/if}
                                        <!-- Content: END -->
                                    </div>
                                </div>
                                <div class="three-right">
                                    <div class="split-content">
                                        <!-- Content: START -->
                                        {if is_set( $children.2 )}
                                        {node_view_gui view=horizontallylistedsubitems content_node=$children.2}
                                        {/if}
                                        <!-- Content: END -->
                                    </div>
                                </div>
                                <div class="three-center float-break">
                                    <div class="split-content">
                                        <!-- Content: START -->
                                        {if is_set( $children.1 )}
                                        {node_view_gui view=horizontallylistedsubitems content_node=$children.1}
                                        {/if}
                                        <!-- Content: END -->
                                    </div>
                                </div>
                                <div class="break"></div>
                            </div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>

</div>