<div class="content-view-embed">
    <div class="class-folder">

    <div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
    <div class="border-ml"><div class="border-mr"><div class="border-mc">

    {def $children = array()
         $limit = 5
         $offset = 0}

    {if is_set( $object_parameters.limit )}
        {set $limit = $object_parameters.limit}
    {/if}

    {if is_set( $object_parameters.offset )}
        {set $offset = $object_parameters.offset}
    {/if}
    
    {set $children=fetch( content, list, hash( 'parent_node_id', $object.main_node_id, 
                                               'limit', $limit,
                                               'offset', $offset,
                                               'sort_by', $object.main_node.sort_array ) ) }

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