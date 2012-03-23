{def $frontpagestyle='noleftcolumn rightcolumn'}
<div class="content-view-full">
    <div class="class-personal_frontpage {$frontpagestyle}">

    <div class="attribute-header">
        <h1 class="long">{"List of all teamrooms"|i18n("ezteamroom/teamroom")}</h1>
    </div>

    <div class="columns-frontpage float-break">
        <div class="center-column-position">
            <div class="center-column float-break">
                <div class="overflow-fix">
                <!-- Content: START -->

                    {def $default_limit=5}
                    {if ezpreference( 'teamroom_list_limit' )}
                        {set $default_limit = ezpreference( 'teamroom_list_limit' )}
                        {if array( 5, 10, 20, 50 )|contains( $default_limit )|not()}
                            {if $default_limit|lt( 5 )}
                                {set $default_limit = false}
                            {else}
                                {set $default_limit=5}
                            {/if}
                        {/if}
                    {/if}
                    {def $page_limit = first_set( $default_limit, 5 )}
                    {if $view_parameters.limit|gt(0)}
                        {set $page_limit = $view_parameters.limit}
                    {/if}
                    {def $page_offset = 0}
                    {if $view_parameters.offset|gt(0)}
                        {set $page_offset = $view_parameters.offset}
                    {/if}

                    {def $sort_field_list     = ezini( 'TeamroomlistSettings', 'SortFieldList', 'teamroom.ini' )
                         $sort_field_name     = ezini( 'TeamroomlistSettings', 'DefaultSortField', 'teamroom.ini' )
                         $sort_by_field       = false()
                         $sort_by_direction   = true()
                         $sort_by             = false()
                         $view_parameter_text = false()}

                    {if and( $view_parameters.sortfield,
                             $sort_field_list|contains($view_parameters.sortfield) )}
                        {set $sort_field_name = $view_parameters.sortfield}
                    {/if}
                    {set $sort_by_field = ezini( concat('SortField_', $sort_field_name), 'SortField', 'teamroom.ini' )}

                    {if and( $view_parameters.sortorder, $view_parameters.sortorder|eq( 'desc' ) )}
                        {set $sort_by_direction = false()}
                    {/if}
                    {if $sort_by_field}
                        {if ezini( concat( 'SortField_', $sort_field_name ), 'IsAttribute', 'teamroom.ini' )|eq('false')}
                            {set $sort_by = array( $sort_by_field, $sort_by_direction)}
                        {else}
                            {set $sort_by = array( 'attribute', $sort_by_direction, $sort_by_field)}
                        {/if}
                    {/if}

                    {def $children = 0
                         $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}
                    {if $page_limit}
                        {set $children = fetch('content','list',hash( 'parent_node_id',     $node.node_id,
                                                                      'limit',              $page_limit,
                                                                      'offset',             $page_offset,
                                                                      'class_filter_type',  'include',
                                                                      'class_filter_array', array( $class_identifier_map['teamroom'] ),
                                                                      'sort_by',            $sort_by))}
                    {else}
                        {set $children = fetch('content','list',hash( 'parent_node_id',     $node.node_id,
                                                                      'class_filter_type',  'include',
                                                                      'class_filter_array', array( $class_identifier_map['teamroom'] ),
                                                                      'sort_by',            $sort_by))}
                    {/if}

                    {def $children_count = fetch( content, list_count, hash( 'parent_node_id',     $node.node_id,
                                                                             'class_filter_type',  'include',
                                                                             'class_filter_array', array( $class_identifier_map['teamroom'] ) ) )
                         $current_user = fetch( 'user', 'current_user' )}
                    <div class="border-box">
                    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
                    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

                    <div class="content-view-teamrooms">

                    {foreach $children as $key => $child}
                        {node_view_gui content_node=$child view='line'}
                    {/foreach}

                    {include name            = navigator
                             uri             = 'design:navigator/google.tpl'
                             page_uri        = concat( 'content/view/allteamrooms/', $node.node_id )
                             page_uri_suffix = $url_params
                             item_count      = $children_count
                             view_parameters = $view_parameters
                             item_limit      = $page_limit}

                    </div>

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


                <div class="create-task">
                    {def $can_create_file = false()}

                    {if $node.object.can_create}
                        {def $teamroom_class_id = ezini( 'TeamroomSettings', 'TeamroomClassID', 'teamroom.ini' )}
                        {foreach $node.object.can_create_class_list as $class}
                            {if $class.id|eq( $teamroom_class_id )}
                                {set $can_create_file = true()}
                                {continue}
                            {/if}
                        {/foreach}
                    {/if}
                    {if $can_create_file}
                        <form method="post" action={"content/action/"|ezurl}>
                            <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                            <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
                            <input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                            <input type="hidden" name="NodeID" value="{$node.node_id}" />
                            <input type="hidden" name="ClassIdentifier" value="{$class_identifier_map['teamroom']}" />
                            <div class="submitimage">
                               <div class="emptyButton">
                                <input class="mousePointer emptyButton" type="submit" name="NewButton" value="{'Add new Teamroom'|i18n('ezteamroom/teamroom')}" />
                               </div>
                            </div>
                        </form>
                    {/if}
            </div>

            <div class="sort-by">
                <h3>{'Sort By'|i18n('ezteamroom/teamroom')}</h3>
                {def $sort=hash( 'name' , 'Name'|i18n('ezteamroom/teamroom'), 'date' , 'Date'|i18n('ezteamroom/teamroom'), 'access_type' , 'Visibility'|i18n('ezteamroom/teamroom') )
                     $order = cond($sort_by_direction|eq(true()), 'desc', 'asc' )}
                <div class="tags">
                    <ul>
                    {foreach $sort as $key => $keyword}
                        <li {if $sort_by_field|eq($key)}class="selected"{/if}>
                            <a href={concat( 'content/view/allteamrooms/', $node.node_id,
                                             "/(sortfield)/", $key,
                                             "/(sortorder)/", $order)|ezurl}
                               title="{$keyword}">{$keyword|wash()}</a>
                        </li>
                    {/foreach}
                    </ul>
                </div>

            </div>

            <div class="keywords">
                <h3>{'Keywords'|i18n('ezteamroom/teamroom')}</h3>
                {def $sorting=cond($sort_by_field, concat("/(sortfield)/", $sort_by_field))}
                <div class="tags">
                {foreach ezkeywordlist( $class_identifier_map['teamroom'], $node.node_id) as $keyword}
                <a href={concat( $node.url_alias, "/(tag)/", $keyword.keyword|rawurlencode, $sorting )|ezurl}
                   title="{$keyword.keyword}"
                   {if and($view_parameters.tag,$view_parameters.tag|eq($keyword.keyword))}class="selected"{/if}>
                   {$keyword.keyword|wash()}</a>
                {delimiter}, {/delimiter}
                {/foreach}
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
