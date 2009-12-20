{def $current_user =  fetch( 'user', 'current_user' )
     $taskcount = 0
     $lastteamroomname = false()
     $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
     $tasklist = fetch( 'content', 'tree', hash( 'parent_node_id',     $node.node_id,
                                                 'class_filter_type',  'include',
                                                 'class_filter_array', array( $class_identifier_map['task'] ),
                                                 'sort_by',            array( array( 'path', false() ),
                                                                              array( 'attribute',
                                                                                      false(),
                                                                                     concat( $class_identifier_map['task'], '/planned_end_date' ) ) )
                                                ) )
}

{undef $class_identifier_map}

<div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>

    <div class="border-ml">
      <div class="border-mr">
        <div class="border-mc float-break">

            {def $frontpagestyle='noleftcolumn rightcolumn'}
            <div class="content-view-full">
                <div class="class-user_group {$frontpagestyle}">

                <div class="attribute-header">
                    <h1>{"User profile"|i18n("ezteamroom/membership")}</h1>
                </div>

                <div class="columns-frontpage float-break">
                    <div class="center-column-position">
                        <div class="user-edit">















<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

    <div class="attribute-header">
        <h1>{"My Tasks"|i18n( "ezteamroom/tasks" )}</h1>
    </div>

    <div class="content-view-full">
    <div class="class-user_group noleftcolumn rightcolumn">

    <table class="tasklist list" style="width:85%" cellspacing="1" cellpadding="2" border="0">
    <thead><tr>
        <th class="sortable tight">{"Priority"|i18n("ezteamroom/tasks")}</th>
        <th class="sortable">{"Task"|i18n("ezteamroom/tasks")}</th>
        <th width="120" class="tight">{"Progress"|i18n("ezteamroom/tasks")}</th>
        <th class="sortable tight">{"Planned end date"|i18n("ezteamroom/tasks")}</th>
        <th class="tight">{"Effort"|i18n("ezteamroom/tasks")}</th>
        <th colspan="2" class="tight"></th>
    </tr></thead>
    <tbody>
    {foreach $tasklist as $task sequence array(bglight,bgdark) as $style}
        {foreach $task.data_map.users.content.relation_list as $taskuser}
            {if $taskuser.contentobject_id|eq( $current_user.contentobject_id )}
                {if $task.parent.parent.name|ne( $lastteamroomname )}
                    <tr><td colspan="7"><h1>{$task.parent.parent.name|wash()}</h1></td></tr>
                {/if}
                {def $url = concat('/', $node.url_alias)}
                {foreach $view_parameters as $key => $value}
                    {if $value}{set $url=concat($url,'/(',$key,')/',$value)}{/if}
                {/foreach}
                {node_view_gui content_node=$task view='table_line' style=$style url=$url}
                {set $taskcount = $taskcount|inc()}
                {set $lastteamroomname = $task.parent.parent.name}
                {undef $url}
                {continue}
            {/if}
        {/foreach}
    {/foreach}
    </tbody>
    </table>
    {if or( $tasklist|count()|not(), $taskcount|eq( 0 ))}
        <p>{"There are no tasks assigned to you."|i18n("ezteamroom/tasks")}</p>
    {/if}

    </div>
    </div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>














                        </div>

                    </div>

                    <div class="right-column-position">
                        <div class="right-column">

{include uri='design:user/edit_menu.tpl' add_form = true()}

                        </div>
                    </div>

              </div>
            </div>
          </div>

        </div>
      </div>
    </div>

    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
