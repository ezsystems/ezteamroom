{def $taskcount = 0
     $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
     $current_user =  fetch( 'user', 'current_user' )
     $max_items_to_show = ezini( 'TeamroomSettings', 'MaxEntryCount', 'teamroom.ini' )
     $tasklist = fetch( 'content', 'tree', hash( 'parent_node_id',     $node.node_id,
                                                 'class_filter_type',  'include',
                                                 'class_filter_array', array( $class_identifier_map['task'] ),
                                                 'sort_by',            array( 'attribute',
                                                                              false(),
                                                                              concat( $class_identifier_map['task'], '/planned_end_date') )
                                                ) )
}

{undef $class_identifier_map}

<div class="latest-messages itemized_sub_items">
<div class="content-view-embed">

    <div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

    <ul>
    {foreach $tasklist as $task}
        {foreach $task.data_map.users.content.relation_list as $taskuser}
            {if $taskuser.contentobject_id|eq( $current_user.contentobject_id )}
                <li>
                    <span class="listitem_file">
                    <span class="owner">
                    <a href={$task.parent.url_alias|ezurl} style="display:inline">{node_view_gui content_node=$task view='listitem'}</a>
                    <strong> {"from"|i18n( "ezteamroom/tasks" )}</strong>
                    <a href={$task.parent.parent.url_alias|ezurl} style="display:inline;padding-left:0">{$task.parent.parent.name|wash()}</a>
                    </span>
                    </span>
                </li>
                {set $taskcount = $taskcount|inc()}
                {continue}
            {/if}
        {/foreach}
        {if gt( $taskcount, $max_items_to_show )}{break}{/if}
    {/foreach}
    </ul>
    {if or( $tasklist|count()|not(), $taskcount|eq( 0 ))}
        <p>{"There are no tasks assigned to you."|i18n("ezteamroom/tasks")}</p>
    {/if}

    <div class="infobox-link">
    {if $max_items_to_show|lt( $taskcount )}
        <a href={concat( 'content/view/usertasks/', $node.node_id )|ezurl()} title="{'Browse all'|i18n('ezteamroom/tasks')}">{'Browse all'|i18n('ezteamroom/tasks')}</a>
    {/if}
    </div>

    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>

</div>
</div>
