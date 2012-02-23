{set-block scope=root variable=cache_ttl}0{/set-block}

{def $default_limit = 15}

{if ezpreference( 'teamroom_tasklist_list_limit' )}

    {set $default_limit = ezpreference( 'teamroom_tasklist_list_limit' )}

{/if}

{def $page_limit = first_set( $default_limit, 5 )}

{if and(is_set($view_parameters.limit),$view_parameters.limit|gt(0))}

    {set $page_limit = $view_parameters.limit}

{/if}

{def $frontpagestyle='noleftcolumn rightcolumn'}

<div class="content-view-full">
    <div class="class-task_list {$frontpagestyle}">

    <div class="attribute-header">
        <h1>{attribute_view_gui attribute=$node.data_map.name}
        {*if teamroom owner is logged in allow edit*}
        {def $current_user = fetch( 'user', 'current_user' )}
        {if eq( $current_user.contentobject_id, $node.object.owner.id )}
            <a href={concat("content/edit/",$node.object.id,'/f/',ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini'))|ezurl}><img src={'task_edit.gif'|ezimage} alt="{'Edit description'|i18n('ezteamroom/tasks')}"/></a>
        {/if}
        {undef $current_user}
        </h1>
    </div>

    {if $node.object.data_map.description.has_content}
        <div class="attribute-long">
            {attribute_view_gui attribute=$node.data_map.description}
        </div>
    {/if}

    <br />
    <br />

    {if is_set($view_parameters.error)}
            <div class="message-warning" id="tasklistwarning" style="background-color:#006699; color:#CCCCFF;">
                {switch match=$view_parameters.error}
                {case match='access'}
                    <p>{"You don't have access to modify this task."|i18n("ezteamroom/tasks")}</p>
                    {break}
                {/case}
                {case match='kernel'}
                    <p>{"An unexpected error occured."|i18n("ezteamroom/tasks")}</p>
                    {break}
                {/case}

                {/switch}
            </div>
    {/if}

    <div class="columns-frontpage float-break">

        <div class="center-column-position">
            <div class="center-column float-break">
                <div class="overflow-fix">
                <!-- Content: START -->
                    <div class="border-box">
                    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
                    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">


                        {def $url = concat('/', $node.url_alias)}
                        {foreach $view_parameters as $key => $value}
                            {if $value}
                                {set $url=concat($url,'/(',$key,')/',$value)}
                            {/if}
                        {/foreach}

                        {def $sort_field_list     = ezini( 'TaskListSettings', 'SortFieldList', 'teamroom.ini' )
                            $sort_field_name     = ezini( 'TaskListSettings', 'DefaultSortField', 'teamroom.ini' )
                            $sort_by_field       = false()
                            $sort_by_direction   = true()
                            $sort_by             = false()
                            $view_parameter_text = false()
                                     $task_count = 0
                                          $tasks = array()}

                        {if and( is_set($view_parameters.sortfield), $sort_field_list|contains($view_parameters.sortfield) )}
                            {set $sort_by_field = ezini( concat('SortField_task_',$view_parameters.sortfield), 'SortField', 'teamroom.ini' )}
                        {else}
                            {set $sort_by_field = ezini( concat('SortField_task_',$sort_field_name), 'SortField', 'teamroom.ini' )}
                        {/if}
                        {if and( is_set($view_parameters.sortorder), $view_parameters.sortorder|eq( 'desc' ) )}
                            {set $sort_by_direction = false()}
                        {/if}
                        {if $sort_by_field}
                            {set $sort_by = array( 'attribute', $sort_by_direction, $sort_by_field)}
                        {/if}

                        {def $view_finished='<'}
                        {if and(is_set($view_parameters.viewfinished), $view_parameters.viewfinished|eq('true'))}
                            {set $view_finished='='}
                        {elseif and(is_set($view_parameters.viewfinished), $view_parameters.viewfinished|eq('all'))}
                            {set $view_finished='<='}
                        {/if}

                        {foreach $view_parameters as $key => $value}
                            {if and($value, $key|ne('sortfield'),$key|ne('sortorder'))}
                                {set $view_parameter_text=concat($view_parameter_text,'/(',$key,')/',$value)}
                            {/if}
                        {/foreach}

                                <table class="tasklist list" width="100%" cellspacing="1" cellpadding="2" border="0">
                                    <thead>
                                        <tr class="">
                                            <th class="sortable tight">
                                                {"Priority"|i18n("ezteamroom/tasks")}
                                            </th>
                                            <th class="sortable">
                                                {"Task"|i18n("ezteamroom/tasks")}
                                            </th>
                                            <th width="120" class="tight">
                                                {"Progress"|i18n("ezteamroom/tasks")}
                                            </th>
                                            <th class="sortable tight">
                                                {"Planned end date"|i18n("ezteamroom/tasks")}
                                            </th>
                                            <th class="tight">
                                                {"Effort"|i18n("ezteamroom/tasks")}
                                            </th>
                                            <th colspan="2" class="tight"></th>
                                        </tr>
                                    </thead>
                                    <tbody>

{def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
     $total_task_count = fetch( 'content', 'list_count', hash( 'parent_node_id',     $node.node_id,
                                                               'class_filter_type',  'include',
                                                               'class_filter_array', array( $class_identifier_map['task'] )
                                                             )
                              )}

                                        {if is_set($view_parameters.tag)}
                                            {set $task_count = fetch( 'content', 'keyword_count', hash( 'alphabet', $view_parameters.tag|rawurldecode,
                                                                                            'include_duplicates', false(),
                                                                                            'parent_node_id', $node.node_id ) )
                                                 $tasks = fetch( 'content', 'keyword', hash( 'alphabet', $view_parameters.tag|rawurldecode,
                                                                                            'include_duplicates', false(),
                                                                                            'parent_node_id', $node.node_id,
                                                                                            'offset', $view_parameters.offset,
                                                                                            'sort_by', $sort_by,
                                                                                            'limit', cond($page_limit|eq(-1), $task_count, $page_limit ) ) )}
                                            {foreach $tasks as $task sequence array( 'bgdark', 'bglight' ) as $style}
                                                {node_view_gui view='table_line' content_node=$task.link_object style=$style url=$url}
                                            {/foreach}
                                        {else}

                                            {set $task_count = fetch( 'content', 'list_count', hash( 'parent_node_id',     $node.node_id,
                                                                                                     'class_filter_type',  'include',
                                                                                                     'class_filter_array', array( $class_identifier_map['task'] ),
                                                                                                     'attribute_filter', array( array( concat( $class_identifier_map['task'], '/progress' ), $view_finished, 100 )  ) ) )
                                                 $tasks = fetch( 'content', 'list', hash( 'parent_node_id',     $node.node_id,
                                                                                         'offset',             $view_parameters.offset,
                                                                                         'limit',              cond($page_limit|eq(-1), $task_count, $page_limit ),
                                                                                         'sort_by',            $sort_by,
                                                                                         'class_filter_type',  'include',
                                                                                         'class_filter_array', array( $class_identifier_map['task'] ),
                                                                                         'attribute_filter', array( array( concat( $class_identifier_map['task'], '/progress' ), $view_finished, 100 )  ) ) )}
                                            {foreach $tasks as $task sequence array(bglight,bgdark) as $style}
                                                    {node_view_gui content_node=$task view='table_line' style=$style url=$url}
                                            {/foreach}
                                        {/if}
                                    </tbody>
                                </table>

                                {include name            = navigator
                                        uri             = 'design:navigator/google.tpl'
                                        page_uri        = $node.url_alias
                                        page_uri_suffix = $url_params
                                        item_count      = $task_count
                                        view_parameters = $view_parameters
                                        item_limit      = $page_limit
                                        preference      = "teamroom_tasklist_list_limit"
                                        show_limit_sel  = true}



                    </div></div></div>
                    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
                    </div>


                <!-- Content: END -->
                </div>
            </div>
        </div>
        <div class="right-column-position">
            <div class="right-column">
            <!-- Content: START -->
                    <div class="border-box">
                    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
                    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">


                    {def $can_create = fetch( 'content', 'access', hash( 'access', 'create', 'contentobject', $node, 'contentclass_id', $class_identifier_map['task'] ) )}
                    {if $can_create}

                <div class="create-task">
                        <form method="post" action={"content/action/"|ezurl}>
                            <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                            <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
                            <input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                            <input type="hidden" name="NodeID" value="{$node.node_id}" />
                            <input type="hidden" name="ClassIdentifier" value="{$class_identifier_map['task']}" />
                            <div class="submitimage">
                             <div class="emptyButton">
                              <input class="mousePointer emptyButton" type="submit" name="NewButton" value="{'Add new task'|i18n( 'ezteamroom/tasks' )}" />
                             </div>
                            </div>
                        </form>
            </div>

                    {/if}

            <div class="create-task">
                <form method="post" action={"content/action/"|ezurl}>
                    <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                    <div class="keepupdated">
                        <div class="arrowWhiteButton">
                         <input class="mousePointer arrowWhiteButton" type="submit" name="ActionAddToNotification" value="{'Keep me updated'|i18n( 'ezteamroom/keepmeupdated' )}" title="{'Receive an email if anything changes in this area'|i18n( 'ezteamroom/keepmeupdated' )}" />
                        </div>
                    </div>
                </form>
            </div>

{if or( $total_task_count|gt( 0 ), is_set( $view_parameters.tag ), is_set( $view_parameters.viewfinished ) )}

            <div class="sort-by">
                <h3>{'Filter'|i18n('ezteamroom/tasks')}</h3>
                    <ul>
                        {if and(is_set($view_parameters.viewfinished),$view_parameters.viewfinished|eq('true'))}
                            <li><a href={concat( $node.url_alias, "/(viewfinished)/all/")|ezurl} title="{"View all tasks"|i18n("ezteamroom/tasks")}">{"View all tasks"|i18n("ezteamroom/tasks")}</a></li>
                            <li><a href={concat( $node.url_alias, "/(viewfinished)/false/")|ezurl} title="{"View unfinished tasks"|i18n("ezteamroom/tasks")}">{"View only unfinished tasks"|i18n("ezteamroom/tasks")}</a></li>
                        {elseif and(is_set($view_parameters.viewfinished),$view_parameters.viewfinished|eq('all'))}
                            <li><a href={concat( $node.url_alias, "/(viewfinished)/true/")|ezurl} title="{"View finished tasks"|i18n("ezteamroom/tasks")}">{"View finished tasks"|i18n("ezteamroom/tasks")}</a></li>
                            <li><a href={concat( $node.url_alias, "/(viewfinished)/false/")|ezurl} title="{"View unfinished tasks"|i18n("ezteamroom/tasks")}">{"View only unfinished tasks"|i18n("ezteamroom/tasks")}</a></li>
                        {else}
                            <li><a href={concat( $node.url_alias, "/(viewfinished)/all/")|ezurl} title="{"View all tasks"|i18n("ezteamroom/tasks")}">{"View all tasks"|i18n("ezteamroom/tasks")}</a></li>
                            <li><a href={concat( $node.url_alias, "/(viewfinished)/true/")|ezurl} title="{"View finished tasks"|i18n("ezteamroom/tasks")}">{"View finished tasks"|i18n("ezteamroom/tasks")}</a></li>
                        {/if}
                    </ul>
            </div>

    {if $task_count|gt( 0 )}

            <div class="sort-by">
                <h3>{'Sort By'|i18n('ezteamroom/tasks')}</h3>
                {def $sort = hash( 'name' , 'Task'|i18n("ezteamroom/tasks"),
                                   'plan' , 'Planned end date'|i18n("ezteamroom/tasks"),
                                   'priority', 'Priority'|i18n("ezteamroom/tasks"),
                                   'progress', 'Progress'|i18n("ezteamroom/tasks") )
                     $order = cond($sort_by_direction|eq(true()), 'desc', 'asc' )}
                <div class="tags">
                    <ul>
                    {def $view_finished_param = ''}
                    {if is_set($view_parameters.viewfinished)}
                        {set $view_finished_param=concat('/(viewfinished)/', $view_parameters.viewfinished)}
                    {/if}
                    {foreach $sort as $key => $keyword}
                        <li {if $view_parameters.sortfield|eq($key)}class="selected"{/if}>
                           <a href={concat( $node.url_alias, "/(sortfield)/", $key,"/(sortorder)/",$order,$view_finished_param)|ezurl} title="{$keyword}">{$keyword|wash()}</a>
                        </li>
                    {/foreach}
                    </ul>
                </div>

            </div>

            <div class="keywords">
                <h3>{'Keywords'|i18n('ezteamroom/tasks')}</h3>

                {def     $sorting = cond( $sort_by_field, concat("/(sortfield)/", $sort_by_field ) )
                     $taskTagList = ezkeywordlist( $class_identifier_map['task'], $node.node_id )}

                <div class="tags">

                {if $taskTagList|count()|gt( 0 )}

                    {foreach $taskTagList as $keyword}

                        {if and( is_set( $view_parameters.tag ), $view_parameters.tag|eq( $keyword.keyword ) )}

                 <a href={concat( $node.url_alias, $sorting )|ezurl()} title="{'Only tasks with tag "%1" are shown'|i18n( 'ezteamroom/tasks', , array( $keyword.keyword ) )|wash()}" class="selected">{$keyword.keyword|wash()}</a>

                        {else}

                 <a href={concat( $node.url_alias, "/(tag)/", $keyword.keyword|rawurlencode(), $sorting )|ezurl()} title="{'Shown only tasks with tag "%1"'|i18n( 'ezteamroom/tasks', , array( $keyword.keyword ) )|wash()}">{$keyword.keyword|wash()}</a>

                        {/if}

                        {delimiter}, {/delimiter}

                    {/foreach}

                {else}

                    {'No tags available'|i18n( 'ezteamroom/tags' )}

                {/if}
                </div>
            </div>

    {/if}

{/if}

{undef $class_identifier_map $total_task_count}

                    </div></div></div>
                    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
                    </div>
            <!-- Content: END -->
            </div>
        </div>
    </div>

    </div>
</div>



{literal}
<script type="text/javascript">
setTimeout( "hideWarnBox()", 10000);
</script>
{/literal}

