{def $default_limit = 10}
{if ezpreference( 'teamroom_wiki_list_limit' )}
    {set $default_limit = ezpreference( 'teamroom_wiki_list_limit' )}
{/if}

{def $page_limit = first_set( $default_limit, 5 )}
{if and(is_set($view_parameters.limit),$view_parameters.limit|gt(0))}
    {set $page_limit = $view_parameters.limit}
{/if}

{if $page_limit|eq(-1)}
    {set $page_limit = ''}
{/if}

{def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}

<div class="content-view-full">
    <div class="class-wiki leftcolumn norightcolumn">

    <div class="attribute-header">
        <h1>{'Wiki'|i18n('ezteamroom/wiki')}</h1>
    </div>

    <div class="columns-frontpage float-break">
        <div class="left-column-position">
            <div class="left-column">
            <!-- Content: START -->

                {include uri='design:parts/wiki_leftcol.tpl'}
            <!-- Content: END -->
            </div>
        </div>
        <div class="center-column-position">
            <div class="center-column float-break center-column-wiki-atoz">
                <div class="overflow-fix">
                <!-- Content: START -->
                    <div class="border-box">
                    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
                    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

                    <div class="content-view-full">
                        <div class="class-wiki">

                            <div class="blog_actions float-break">
                            </div>

                            <div class="attribute-header">
                                <h1>{'Wiki'|i18n('ezteamroom/wiki')} Tag {$view_parameters.tag|wash()}</h1>
                            </div>

                            <div class="attribute-body">
                                {'Only entries with tag "%1" are shown'|i18n( 'ezteamroom/blog', , array( $view_parameters.tag ) )|wash()}
                            </div>

                            {def $children_count = fetch( 'content', 'keyword_count', hash( 'alphabet', $view_parameters.tag|rawurldecode(),
                                                                                            'include_duplicates', false(),
                                                                                            'parent_node_id', $node.node_id
                                                                                            )
                                                        )
                                    $children = fetch( 'content', 'keyword', hash( 'alphabet', $view_parameters.tag|rawurldecode(),
                                                                                    'include_duplicates', false(),
                                                                                    'parent_node_id', $node.node_id,
                                                                                    'offset', $view_parameters.offset,
                                                                                    'limit', $page_limit ) )}

                            <div class="content-view-children-wiki_atoz">
                                {foreach $children as $child }
                                    {node_view_gui view='line' content_node=$child.link_object}
                                {/foreach}
                            </div>

                            {include name=navigator
                                    uri='design:navigator/google.tpl'
                                    page_uri=$node.url_alias
                                    item_count=$children_count
                                    view_parameters=$view_parameters
                                    item_limit=$page_limit
                                    node_id=$node.node_id
                                    preference="teamroom_wiki_list_limit"}

                            {undef $children_count $children}

                        </div>
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
</div>
{undef $class_identifier_map}
