<div class="content-view-embed">
    <div class="class-gallery">

    <h2><a href={$object.main_node.url_alias|ezurl}>{$object.name|wash()}</a></h2>

    <div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

    {def $children = array()
         $limit = 5
         $offset = 0
         $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}

    {if is_set( $object_parameters.limit )}
        {set $limit = $object_parameters.limit}
    {/if}

    {if is_set( $object_parameters.offset )}
        {set $offset = $object_parameters.offset}
    {/if}

    {set $children=fetch( content, list, hash( 'parent_node_id', $object.main_node_id,
                                               'limit', $limit,
                                               'offset', $offset,
                                               'class_filter_type', 'include',
                                               'class_filter_array', array( $class_identifier_map['image'] ),
                                               'sort_by', $object.main_node.sort_array ) ) }

    {undef $class_identifier_map}

    {if $children|count()}

    <ul>
    {foreach $children as $child}
       <li><div><a href={$child.url_alias|ezurl}>{$child.name|wash()}</a></div></li>
    {/foreach}
    </ul>
    {/if}

    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>

    </div>
</div>