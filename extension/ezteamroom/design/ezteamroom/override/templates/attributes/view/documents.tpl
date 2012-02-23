{if $attribute.content.relation_list}
    {def $document_node = false()}
    {foreach $attribute.content.relation_list as $item}
        {if $item.in_trash|not()}
            {set $document_node = fetch( content, node, hash( node_id, $item.node_id ) )}
            {if is_set($document_node.data_map.file)}
                <a href={concat("content/download/", $document_node.data_map.file.contentobject_id,"/",$document_node.data_map.file.id,"/file/",$document_node.data_map.file.content.original_filename|rawurlencode() )|ezurl}>{$document_node.name|wash()}</a> - {$document_node.data_map.file.content.mime_type_part|wash()|upcase()|shorten(3,'')}({$document_node.data_map.file.content.filesize|si( byte )})
            {else}
                {def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}
                {if $document_node.class_identifier|eq( $class_identifier_map['milestone'] )}
                <a href={$document_node.parent.url_alias|ezurl()}>{$document_node.name|wash()}</a>
                {else}
                <a href={$document_node.url_alias|ezurl()}>{$document_node.name|wash()}</a>
                {/if}
                {undef $class_identifier_map}
            {/if}
        {/if}
        {delimiter}, {/delimiter}
    {/foreach}
    {undef $document_node}
{else}
{'No related documents.'|i18n( 'ezteamroom/tasks' )}
{/if}
