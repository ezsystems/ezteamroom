{if $object.main_node_id|null|not}
    <a href={$object.main_node.url_alias|ezurl}>
        <span class="prio">{attribute_view_gui attribute=$object.data_map.priority}</span> | 
        <span class="date">{$object.data_map.planned_end_date.content.timestamp|l10n('shortdate')}</span> | 
        <span class="name">{$object.name|wash|shorten(20)}</span> | 
        <span class="prog">{$object.data_map.progress.content}%</span>
    </a>
{else}
    {$object.name|wash}
{/if} 
