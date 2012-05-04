{def $description_attr = null}
<div class="teamroom-search-item">
{*     <a title="{$node.name|wash()}" href="{$node.url_alias}">{$node.class_identifier|class_icon('small',$node.name|wash)}</a> *}

    <b><a class="search-item-link" title="{$node.name|wash()}" href="{$node.url_alias}">{$node.name|wash}</a></b> ({$node.class_name|wash})

    {def $description_attr = first_set( $node.data_map.short_description,
                                        $node.data_map.text_description,
                                        $node.data_map.description,
                                        $node.data_map.message,
                                        $node.data_map.text,
                                        $node.data_map.body,
                                        $node.data_map.content )}
    {if $description_attr}
    <br />
        {if $description_attr.data_type_string|eq('ezxmltext')}
            {$description_attr.content.output.output_text|shorten_xml(120)}
        {elseif $description_attr.data_type_string|eq('eztext')}
            {$description_attr.content|shorten(120)}
        {elseif $description_attr.data_type_string|eq('ezstring')}
            {$description_attr.content|shorten(120)}
        {/if}
    {/if}
{if is_set( $node.data_map.text_description )}{attribute_view_gui attribute=$node.data_map.description}{/if}

</div>

