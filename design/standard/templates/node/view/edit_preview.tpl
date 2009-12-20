{if $node.data_map.image}
    {attribute_view_gui attribute=$node.data_map.image image_class="thumbnail"}
{else}
    {$node.name|wash}
{/if}