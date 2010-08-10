{set-block scope=root variable=cache_ttl}0{/set-block}

{def $frontpagestyle='noleftcolumn rightcolumn'}

<div class="content-view-full">
    <div class="class-milestone_folder {$frontpagestyle}">

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
    <div class="columns-frontpage float-break">
        <div class="center-column-position">
            <div class="center-column float-break">
                <div class="overflow-fix">
                <!-- Content: START -->
                    <div class="border-box">
                    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
                    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

                            {if ezpreference( 'teamroom_milestone_list_limit' )}
                            {def $default_limit = ezpreference( 'teamroom_milestone_list_limit' )}
                            {/if}
                            {def    $page_limit = first_set( $default_limit, 5 )}
                            {if and(is_set($view_parameters.limit), $view_parameters.limit|gt(0))}
                                {set $page_limit = $view_parameters.limit}
                            {/if}

                            {def $url = concat('/', $node.url_alias)}
                            {foreach $view_parameters as $key => $value}
                                {if $value}
                                    {set $url=concat($url,'/(',$key,')/',$value)}
                                {/if}
                            {/foreach}

                            {def $sort_field_list     = ezini( 'MilestoneSettings', 'SortFieldList', 'teamroom.ini' )
                                $sort_field_name     = ezini( 'MilestoneSettings', 'DefaultSortField', 'teamroom.ini' )
                                $sort_by_field       = false()
                                $sort_by_direction   = true()
                                $sort_by             = false()
                                $view_parameter_text = false()
                                            $sorting = ''}

                            {if and( is_set($view_parameters.sortfield), $view_parameters.sortfield, $sort_field_list|contains($view_parameters.sortfield) )}
                                {set $sort_by_field = ezini( concat('SortField_milestone_',$view_parameters.sortfield), 'SortField', 'teamroom.ini' )
                                           $sorting = concat( $sorting , '/(sortfield)/', $view_parameters.sortfield )}
                            {else}
                                {set $sort_by_field = ezini( concat('SortField_milestone_',$sort_field_name), 'SortField', 'teamroom.ini' )}
                            {/if}
                            {if and( is_set($view_parameters.sortorder), $view_parameters.sortorder, $view_parameters.sortorder|eq( 'desc' ) )}
                                {set $sort_by_direction = false()
                                               $sorting = concat( $sorting , '/(sortorder)/', $view_parameters.sortorder )}
                            {/if}
                            {if $sort_by_field}
                                {set $sort_by = array( 'attribute', $sort_by_direction, $sort_by_field)}
                            {/if}
                            {def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
                                       $children_count = 0
                                       $children = 0}
                            {if is_set($view_parameters.tag)}
                                {set  $children_count = fetch( 'content', 'keyword_count', hash( 'alphabet', $view_parameters.tag|rawurldecode,
                                                                                'include_duplicates', false(),
                                                                                'parent_node_id', $node.node_id ) )
                                      $children = fetch( 'content', 'keyword', hash( 'alphabet', $view_parameters.tag|rawurldecode,
                                                                                'include_duplicates', false(),
                                                                                'parent_node_id', $node.node_id,
                                                                                'offset', $view_parameters.offset,
                                                                                'sort_by', $sort_by,
                                                                                'limit', cond($page_limit|eq(-1), $children_count, $page_limit ) ) )}
                                <div class="content-view-children">
                                    {foreach $children as $child sequence array( 'bgdark', 'bglight' ) as $style}
                                        {node_view_gui view='line' content_node=$child.link_object style=$style url=$url}
                                    {/foreach}
                                </div>
                                {include name            = navigator
                                        uri             = 'design:navigator/google.tpl'
                                        page_uri        = $node.url_alias
                                        page_uri_suffix = $url_params
                                        item_count      = $children_count
                                        view_parameters = $view_parameters
                                        item_limit      = $page_limit
                                        preference      = "teamroom_milestone_list_limit"}
                            {else}
                                {set $children_count = fetch( 'content', 'list_count', hash( 'parent_node_id',     $node.node_id,
                                                                                        'class_filter_type',  'include',
                                                                                        'class_filter_array', array( $class_identifier_map['milestone'] ),
                                                                                        'attribute_filter', array( array( concat( $class_identifier_map['milestone'], '/closed' ), '>=', '0'  ) ) ))
                                     $children = fetch( 'content', 'list', hash( 'parent_node_id',     $node.node_id,
                                                                                'offset',             $view_parameters.offset,
                                                                                'limit',              cond($page_limit|eq(-1), $children_count, $page_limit ),
                                                                                'sort_by',            $sort_by,
                                                                                'class_filter_type',  'include',
                                                                                'class_filter_array', array( $class_identifier_map['milestone'] ),
                                                                                'attribute_filter',   array( array( concat( $class_identifier_map['milestone'], '/closed' ), '>=', '0'  ) ) ) )}

                                {foreach $view_parameters as $key => $value}
                                    {if and($value, $key|ne('sortfield'),$key|ne('sortorder'))}
                                        {set $view_parameter_text=concat($view_parameter_text,'/(',$key,')/',$value)}
                                    {/if}
                                {/foreach}

                                <div class="content-view-children">
                                    {foreach $children as $child sequence array(bgdark,bglight) as $style}
                                            {node_view_gui content_node=$child view='line' style=$style url=$url class_identifier_map = $class_identifier_map}
                                    {/foreach}
                                </div>
                                {include name            = navigator
                                        uri             = 'design:navigator/google.tpl'
                                        page_uri        = $node.url_alias
                                        page_uri_suffix = $url_params
                                        item_count      = $children_count
                                        view_parameters = $view_parameters
                                        item_limit      = $page_limit
                                        preference      = "teamroom_milestone_list_limit"}
                        {/if}


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


                    {def $can_create = fetch( 'content', 'access', hash( 'access', 'create', 'contentobject', $node, 'contentclass_id', $class_identifier_map['milestone'] ) )}
                    {if $can_create}

                <div class="create-file">
                        <form method="post" action={"content/action/"|ezurl}>
                            <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                            <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
                            <input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                            <input type="hidden" name="NodeID" value="{$node.node_id}" />
                            <input type="hidden" name="ClassIdentifier" value="{$class_identifier_map['milestone']}" />
                            <div class="submitimage">
                             <div class="emptyButton">
                              <input class="mousePointer emptyButton" type="submit" name="NewButton" value="{'New milestone'|i18n( 'ezteamroom/tasks' )}" />
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

{if or( $children_count|gt( 0 ), is_set( $view_parameters.tag ), $sorting|ne( '' ) )}

            <div class="sort-by">
                <h3>{'Sort By'|i18n('ezteamroom/tasks')}</h3>
                {def $sort=hash( 'title' , 'Milestone'|i18n( 'ezteamroom/tasks' ), 'date' , 'Date'|i18n( 'ezteamroom/tasks' ) )
                     $order = cond($sort_by_direction|eq(true()), 'desc', 'asc' )}
                <div class="tags">
                    <ul>
                    {foreach $sort as $key => $keyword}
                        <li {if $sort_by_field|eq($key)}class="selected"{/if}>
                            <a href={concat( $node.url_alias, "/(sortfield)/", $key,"/(sortorder)/",$order)|ezurl} title="{$keyword}">{$keyword|wash()}</a>
                        </li>
                    {/foreach}
                    </ul>
                </div>

            </div>

{/if}

            <div class="keywords">
                <h3>{'Keywords'|i18n('ezteamroom/tasks')}</h3>
                <div class="tags">

                {def $milestoneTagList = ezkeywordlist( $class_identifier_map['milestone'], $node.node_id )}

                {if $milestoneTagList|count()|gt( 0 )}

                    {foreach $milestoneTagList as $keyword}

                        {if and( is_set( $view_parameters.tag ), $view_parameters.tag|eq( $keyword.keyword ) )}

                 <a href={concat( $node.url_alias, $sorting )|ezurl()} title="{'Only milestones with tag "%1" are shown'|i18n( 'ezteamroom/tasks', , array( $keyword.keyword ) )|wash()}" class="selected">{$keyword.keyword|wash()}</a>

                        {else}

                 <a href={concat( $node.url_alias, "/(tag)/", $keyword.keyword|rawurlencode(), $sorting )|ezurl()} title="{'Shown only milestones with tag "%1"'|i18n( 'ezteamroom/tasks', , array( $keyword.keyword ) )|wash()}">{$keyword.keyword|wash()}</a>

                        {/if}

                        {delimiter}, {/delimiter}

                    {/foreach}

                {else}

                    {'No tags available'|i18n( 'ezteamroom/tags' )}

                {/if}
                </div>
            </div>

{undef $class_identifier_map}

                    </div></div></div>
                    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
                    </div>
            <!-- Content: END -->
            </div>
        </div>
    </div>

    </div>
</div>
