{def $default_limit = 10}

{if ezpreference( 'teamroom_documents_list_limit' )}

    {set $default_limit = ezpreference( 'teamroom_documents_list_limit' )}

{/if}

{def $page_limit = first_set( $default_limit, 5 )}

{if and(is_set($view_parameters.limit),$view_parameters.limit|gt(0))}

    {set $page_limit = $view_parameters.limit}

{/if}

{def $frontpagestyle='leftcolumn rightcolumn'}

<div class="content-view-full">
    <div class="class-documentation_page {$frontpagestyle}">

    <div class="attribute-header">
        <h1>{'Wiki'|i18n('ezteamroom/wiki')}</h1>
    </div>

    <div class="columns-frontpage float-break">
        <div class="left-column-position">
            <div class="left-column">
            <!-- Content: START -->
                {if eztoc2( $node.object.data_map.body )}
                <div class="attribute-toc">
                    <h2>{'Table of contents'|i18n( 'ezteamroom/wiki' )}</h2>
                    {eztoc2( $node.object.data_map.body )}
                </div>
                {/if}
            <!-- Content: END -->
            </div>
        </div>
        <div class="center-column-position">
            <div class="center-column float-break">
                <div class="overflow-fix">
                <!-- Content: START -->
                    <div class="border-box">
                    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
                    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

                    <div class="content-view-full">
                        <div class="class-documentation-page">

                        <div class="attribute-byline">
                            <span class="date">{$node.object.modified|l10n(shortdatetime)}</span> |
                            <span class="author"><strong>{'Author'|i18n('ezteamroom/wiki')} </strong>{$node.object.owner.name|wash()}</span>
                        </div>



    <div class="blog_actions float-break">
        {if and(is_set($node.data_map.enable_comments), $node.data_map.enable_comments.data_int)}
        <div class="attribute-comments">
        <p>
            <a href={concat( $node.url_alias, "#comments" )|ezurl}><img src={'comment.gif'|ezimage} alt="comment_icon" /></a>
        </p>
        </div>
        {/if}

        {if $node.object.can_edit}
        <div class="attribute-edit">
            <form method="post" action={"content/action"|ezurl}>
                <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
                <input type="hidden" name="NodeID" value="{$node.object.main_node.node_id}" />
                <input type="hidden" name="ContentObjectLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                <input type="image"  src={'task_edit.gif'|ezimage} name="EditButton" value="{'Edit'|i18n( 'ezteamroom/wiki' )}" title="{'Edit this entry'|i18n( 'ezteamroom/wiki' )}" />
            </form>
        </div>
        {/if}

        {if $node.object.can_remove}
        <div class="attribute-edit">
            <form method="post" action={"content/action/"|ezurl}>
                <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
                <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                <input class="" type="image" src={'task_delete.gif'|ezimage} name="ActionRemove" value="{'Remove'|i18n( 'ezteamroom/wiki' )}" title="{'Remove this entry'|i18n( 'ezteamroom/wiki' )}" />
            </form>
        </div>
        {/if}
    </div>

{def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
     $children_count = 0
     $children = array()
     $pathStringArray = $node.path_string|explode( '/' )}

                            <div class="attribute-header">
                                <h1>{attribute_view_gui attribute=$node.object.data_map.title}</h1>
                            </div>

                            <div class="attribute-body">
                                {attribute_view_gui attribute=$node.object.data_map.body}
                            </div>

                        {if $node.object.data_map.show_children.data_int}

                            {if is_set($view_parameters.tag)}

                                {set $children_count = fetch( 'content', 'keyword_count', hash( 'alphabet', $view_parameters.tag|rawurldecode(),
                                                                                                'include_duplicates', false(),
                                                                                                'parent_node_id', $pathStringArray[5]
                                                                                              )
                                                            )
                                     $children = fetch( 'content', 'keyword', hash( 'alphabet', $view_parameters.tag|rawurldecode(),
                                                                                    'include_duplicates', false(),
                                                                                    'parent_node_id', $pathStringArray[5],
                                                                                    'offset', $view_parameters.offset,
                                                                                    'limit', cond( $page_limit|eq( -1 ), $task_count, $page_limit )
                                                                                  )
                                                      )}

                                <div class="content-view-children">
                                    {foreach $children as $child }
                                        {node_view_gui view='line' content_node=$child.link_object}
                                    {/foreach}
                                </div>

                            {else}

                                {set $children_count=fetch_alias( 'children_count', hash( parent_node_id, $node.node_id,
                                                                                class_filter_type, exclude,
                                                                                class_filter_array, array( $class_identifier_map['infobox'] ) ) )
                                     $children=fetch_alias( 'children', hash( parent_node_id, $node.node_id,
                                                                                offset, $view_parameters.offset,
                                                                                sort_by, $node.sort_array,
                                                                                class_filter_type, exclude,
                                                                                class_filter_array, array( $class_identifier_map['infobox'] ),
                                                                                limit, cond($page_limit|eq(-1), $children_count, $page_limit ) ) )}

                                <div class="content-view-children">
                                    {foreach $children as $child }
                                        {node_view_gui view='line' content_node=$child}
                                    {/foreach}
                                </div>

                            {/if}

                                {include name=navigator
                                        uri='design:navigator/google.tpl'
                                        page_uri=$node.url_alias
                                        item_count=$children_count
                                        view_parameters=$view_parameters
                                        item_limit=$page_limit
                                        preference="teamroom_documents_list_limit"}

                        {/if}

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

                {if fetch( 'content', 'access', hash( 'access', 'create', 'contentobject', $node, contentclass_id, $class_identifier_map['documentation_page'] ) )}

                <div class="create-task">
                <form method="post" action={"content/action"|ezurl}>
                    <input type="hidden" name="ClassIdentifier" value="{$class_identifier_map['documentation_page']}" />
                    <input type="hidden" name="NodeID" value="{$node.object.main_node.node_id}" />
                    <input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                            <div class="submitimage">
                             <div class="emptyButton">
                              <input class="mousePointer emptyButton" type="submit" name="NewButton" value="{'Add new entry'|i18n( 'ezteamroom/blog' )}" />
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

{if or( $children_count|gt( 0 ), is_set( $view_parameters.tag ) )}

            <div class="keywords">
                <h3>{'Keywords'|i18n('ezteamroom/wiki')}</h3>

                {def $wikiTagList = ezkeywordlist( $class_identifier_map['documentation_page'], $pathStringArray[5], $node.depth|inc() )}

                <div class="tags">

                {if $wikiTagList|count()|gt( 0 )}

                    {foreach $wikiTagList as $keyword}

                        {if and( is_set( $view_parameters.tag ), $view_parameters.tag|eq( $keyword.keyword ) )}

                 <a href={$node.url_alias|ezurl()} title="{'Only entries with tag "%1" are shown'|i18n( 'ezteamroom/blog', , array( $keyword.keyword ) )|wash()}" class="selected">{$keyword.keyword|wash()}</a>

                        {else}

                 <a href={concat( $node.url_alias, "/(tag)/", $keyword.keyword|rawurlencode() )|ezurl()} title="{'Shown only entries with tag "%1"'|i18n( 'ezteamroom/files', , array( $keyword.keyword ) )|wash()}">{$keyword.keyword|wash()}</a>

                        {/if}

                        {delimiter}, {/delimiter}

                    {/foreach}

                {else}

                    {'No tags available'|i18n( 'ezteamroom/tags' )}

                {/if}

                </div>
            </div>

{/if}

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
