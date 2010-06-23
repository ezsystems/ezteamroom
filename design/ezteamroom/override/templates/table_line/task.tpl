{def $prio=$node.data_map.priority.data_int
     $prog = $node.data_map.progress.content
     $aliasArray = $node.url_alias|explode( '/' )}

<tr class="{$style} prio{$prio}">
    <td class="prio tight" style="text-align: center;">{attribute_view_gui attribute=$node.data_map.priority}</td>
    <td class="desc">
        <a href="#" onclick="javascript:showhide('ai{$node.node_id}'); return false;"><img src={"task_info.gif"|ezimage()} alt="task_info_icon" /></a>
        <a href="#" onclick="javascript:showhide('ai{$node.node_id}'); return false;" name="{$aliasArray|remove( 0, $aliasArray|count()|dec() )|implode( '/' )}">{$node.name|wash()}</a>

{undef $aliasArray}

    </td>
    <td class="prog nowrap tight">
        <div class="progress float-break">
        <span class="prog025"><a href={concat("tasklist/set/",$node.object.id,"/progress/",25,$url)|ezurl()} title="{'Set progress to %1%.'|i18n( 'ezteamroom/tasks',,hash('%1',25) )}"   class="prog025 {if $prog|ge(25)}selected{/if}"></a></span>
        <span class="prog050"><a href={concat("tasklist/set/",$node.object.id,"/progress/",50,$url)|ezurl()} title="{'Set progress to %1%.'|i18n( 'ezteamroom/tasks',,hash('%1',50) )}"   class="prog050 {if $prog|ge(50)}selected{/if}"></a></span>
        <span class="prog075"><a href={concat("tasklist/set/",$node.object.id,"/progress/",75,$url)|ezurl()} title="{'Set progress to %1%.'|i18n( 'ezteamroom/tasks',,hash('%1',75) )}"   class="prog075 {if $prog|ge(75)}selected{/if}"></a></span>
        <span class="prog100"><a href={concat("tasklist/set/",$node.object.id,"/progress/",100,$url)|ezurl()} title="{'Set progress to %1%.'|i18n( 'ezteamroom/tasks',,hash('%1',100) )}" class="prog100 {if $prog|ge(100)}selected{/if}"></a></span>
        <div class="procent">{$prog|wash}%</div></div>
    </td>
    <td class="end tight nowrap">
    {if $node.data_map.planned_end_date.has_content}
    {attribute_view_gui attribute=$node.data_map.planned_end_date}
    {else}
    {'N/A'|i18n( 'ezteamroom/tasks' )}
    {/if}
    </td>
    <td class="est">
        {$node.data_map.est_hours.content|wash()}:{if $node.data_map.est_minutes.content|wash()|count_chars()|eq(1)}0{/if}{$node.data_map.est_minutes.content|wash()}h
    </td>
    <td class="edit tight">
        {if $node.can_edit}
        <form method="post" action={"/content/action/"|ezurl}>
         <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
         <input type="hidden" name="RedirectURIAfterPublish" value="{$node.parent.url_alias}" />
         <input type="hidden" name="RedirectIfDiscarded" value="{$node.parent.url_alias}" />
            <input type="image" src={"task_edit.gif"|ezimage()} name="EditButton" title="{'Edit this task'|i18n( 'ezteamroom/tasks' )}" />
        </form>
        {/if}
    </td>
    <td class="del tight">

        {if $node.can_remove}
        <form method="post" action={"content/action/"|ezurl}>
            <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
            <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
            <input type="hidden" name="ViewMode" value="full" />
            <input type="image" src={"task_delete.gif"|ezimage()} name="ActionRemove" value="{'Remove'|i18n( 'ezteamroom/tasks' )}" title="{'Delete this task'|i18n( 'ezteamroom/tasks' )}" />
        </form>
        {/if}
    </td>
</tr>
<tr class="task-additional-info {$style}" id="ai{$node.node_id}" style="display:none;">
    <td class="left">&nbsp;</td>
    <td colspan="4" class="content">
            <div class="attribute-long">
                {attribute_view_gui attribute=$node.data_map.description}
            </div>
            <table class="taskdetails" cellspacing="0">
<tr><td><strong>{'Milestone'|i18n('ezteamroom/tasks')}</strong>:</td><td>{if $node.data_map.milestone.content.relation_list}{attribute_view_gui attribute = $node.data_map.milestone}{else}-{/if}</td></tr>
<tr><td><strong>{'Tags'|i18n('ezteamroom/tasks')}</strong>:</td><td>{attribute_view_gui attribute = $node.data_map.tags}</td></tr>
<tr><td><strong>{'Persons in charge'|i18n('ezteamroom/tasks')}</strong>:</td><td>{if $node.data_map.users.content.relation_list}{attribute_view_gui attribute = $node.data_map.users teamroom_node_id = $node.parent.parent.main_node_id}{else}-{/if}</td></tr>
<tr><td><strong>{'Related documents'|i18n('ezteamroom/tasks')}</strong>:</td><td>{if $node.data_map.documents.content.relation_list}{attribute_view_gui attribute = $node.data_map.documents}{else}-{/if}</td></tr>
</table>
    </td>
    <td colspan="2" class="right">&nbsp;</td>
</tr>
