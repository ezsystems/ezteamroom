{def $default_limit = 15}

{if ezpreference( 'teamroom_member_list_limit' )}

    {set $default_limit = ezpreference( 'teamroom_member_list_limit' )}

{/if}

{def $page_limit = first_set( $default_limit, 5 )
     $frontpagestyle = 'noleftcolumn rightcolumn'}

{if $view_parameters.limit|gt(0)}

    {set $page_limit = $view_parameters.limit}

{/if}

{if $page_limit|eq(-1)}

    {set $page_limit = $default_limit}

{/if}

<div class="content-view-full">
    <div class="class-user_group {$frontpagestyle}">

    <div class="attribute-header">
        <h1>{attribute_view_gui attribute=$node.data_map.name}
        {*if teamroom owner is logged in allow edit*}
        {def $current_user = fetch( 'user', 'current_user' )}
        {if eq( $current_user.contentobject_id, $node.object.owner.id )}
            <a href={concat("content/edit/",$node.object.id,'/f/',ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini'))|ezurl}><img src={'task_edit.gif'|ezimage} alt="{'Edit description'|i18n('ezteamroom/membership')}"/></a>
        {/if}
        {undef $current_user}
        </h1>
    </div>

    {if $node.object.data_map.description.has_content}
        <div class="attribute-long">
            {attribute_view_gui attribute=$node.data_map.description}
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

                    <div class="content-view-full">
                        <div class="class-user_group">

                        {def $children_count = fetch( 'content', 'tree_count', hash( 'parent_node_id',     $node.node_id,
                                                                                     'limitation',         array(),
                                                                                     'class_filter_type',  'include',
                                                                                     'class_filter_array', array( 'user' ) ) )
                                $member_list = fetch( 'content', 'tree', hash(  'parent_node_id',     $node.node_id,
                                                                                'limitation',         array(),
                                                                                'class_filter_type',  'include',
                                                                                'class_filter_array', array( 'user' ),
                                                                                'offset',  $view_parameters.offset,
                                                                                'sort_by', $node.parent.sort_array,
                                                                                'limit', $page_limit ) )}
                        <div class="attribute-member">
                            <ul class="member-list">
                            {foreach $member_list as $user sequence array(bglight,bgdark) as $style}
                                <li>{node_view_gui content_node=$user view='avatar' style=$style teamroomobjectid=$node.parent.contentobject_id referrer=$node.url_alias teamroom_path_string=$node.parent.path_string}</li>
                            {/foreach}
                            </ul>

                            {include name=navigator
                                     uri='design:navigator/google.tpl'
                                     page_uri=$node.url_alias
                                     item_count=$children_count
                                     view_parameters=$view_parameters
                                     item_limit=$page_limit
                                     show_limit_sel=cond($children_count|ne(0),true(),false())
                                     preference="teamroom_member_list_limit"}
                        </div>

{undef $children_count $member_list}

                        </div>
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
                <form method="post" action={"content/action/"|ezurl}>
                    <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                    <div class="keepupdated">
                        <div class="arrowWhiteButton">
                         <input class="mousePointer arrowWhiteButton" type="submit" name="ActionAddToNotification" value="{'Keep me updated'|i18n( 'ezteamroom/keepmeupdated' )}" title="{'Receive an email if new users join this teamroom or modify their profile.'|i18n( 'ezteamroom/keepmeupdated' )}" />
                        </div>
                    </div>
                </form>
            </div>

            <div class="sort-by">
                <h3>{'Members'|i18n('ezteamroom/membership')}</h3>
                <br />
                <ul>
                    {if fetch( 'teamroom', 'has_access_to', hash( 'module', 'teamroom', 'function', 'manage', 'subtree', $node.parent.path_string ) )}
                        <li><a href={concat("teamroom/manage/",$node.parent.contentobject_id)|ezurl}>{"Manage member"|i18n("ezteamroom/membership")}</a></li>
                    {/if}
                    {if fetch( 'teamroom', 'has_access_to', hash( 'module', 'teamroom', 'function', 'manage', 'subtree', $node.parent.path_string ) )}
                        <li><a href={concat("teamroom/invite/",$node.parent.contentobject_id)|ezurl}>{"Invite new member"|i18n("ezteamroom/membership")}</a></li>
                    {/if}
                    {*if fetch( 'teamroom', 'has_access_to', hash( 'module', 'teamroom', 'function', 'messagecenter', 'subtree', $node.parent.path_string ) )}
                        <li><a href={concat( '/teamroom/messagecenter/', $node.parent.contentobject_id, '/send/0' )|ezurl() }>{'Send message'|i18n( 'ezteamroom/messagecenter' )}</a></li>
                    {/if*}
                </ul>
            </div>

                    </div></div></div>
                    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
                    </div>
            <!-- Content: END -->
            </div>
        </div>
    </div>

    </div>
</div>
