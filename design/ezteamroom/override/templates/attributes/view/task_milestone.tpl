{if $attribute.content.relation_list}
    {def $taskMilestoneItem = $attribute.content.relation_list.0}
    {if $taskMilestoneItem.in_trash|not()}
        {def $taskMilestoneNode=fetch( content, node, hash( node_id, $taskMilestoneItem.node_id ) )}
        <a href={$taskMilestoneNode.parent.url_alias|ezurl}>{$taskMilestoneNode.name|wash()}</a>
        {undef $taskMilestoneNode}
    {/if}
    {undef $taskMilestoneItem}
{else}
    {'No one defined.'|i18n( 'ezteamroom/tasks' )}
{/if}
