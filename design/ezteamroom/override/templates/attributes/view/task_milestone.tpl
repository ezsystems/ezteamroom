{if $attribute.content.relation_list}
    {def $item = $attribute.content.relation_list.0}
    {if $item.in_trash|not()}
        {def $node=fetch( content, node, hash( node_id, $item.node_id ) )}
        <a href={$node.parent.url_alias|ezurl}>{$node.name|wash()}</a>
    {/if}
{else}
    {'No one defined.'|i18n( 'ezteamroom/tasks' )}
{/if}
