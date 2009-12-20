{def $default_limit = 15}

{if ezpreference( 'teamroom_forum_list_limit' )}

    {set $default_limit = ezpreference( 'teamroom_forum_list_limit' )}

{/if}

{def $page_limit = first_set( $default_limit, 5 )}

{if and( is_set($view_parameters.limit),$view_parameters.limit|gt( 0 ))}

    {set $page_limit = $view_parameters.limit}

{/if}

{def $frontpagestyle='noleftcolumn rightcolumn'
     $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}

<div class="content-view-full">
    <div class="class-forum {$frontpagestyle}">

    <div class="attribute-header">
        <h1>{attribute_view_gui attribute=$node.data_map.name}
        {*if teamroom owner is logged in allow edit*}
        {def $current_user = fetch( 'user', 'current_user' )}
        {if eq( $current_user.contentobject_id, $node.object.owner.id )}
            <a href={concat("content/edit/",$node.object.id,'/f/',ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini'))|ezurl}><img src={'task_edit.gif'|ezimage} alt="{'Edit description'|i18n('ezteamroom/forum')}"/></a>
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

                    {def $topic_count = fetch( 'content', 'list_count', hash( 'parent_node_id', $node.node_id ) )
                         $topic_list = fetch( 'content', 'list', hash( 'parent_node_id', $node.node_id,
                                                                    'limit', cond($page_limit|eq(-1), $children_count, $page_limit ),
                                                                    'offset', $view_parameters.offset,
                                                                    'sort_by', array( array( attribute, false(), concat( $class_identifier_map['forum_topic'], '/sticky' ) ), array( 'modified_subnode', false() ) ) ) )}

                    <div class="border-box">
                    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
                    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

                    <div class="content-view-full">
                        <div class="class-forum">

                        <div class="content-view-children">

                            <table class="list forum" cellspacing="0">
                            <thead>
                            <tr>
                                <th class="topic">
                                    {"Topic"|i18n( "ezteamroom/forum" )}/{"Author"|i18n( "ezteamroom/forum" )}
                                </th>
                                <th class="replies">
                                    {"Replies"|i18n( "ezteamroom/forum" )}
                                </th>
                                <th class="lastreply">
                                    {"Last reply"|i18n( "ezteamroom/forum" )}
                                </th>
                            </tr>
                            </thead>
                            <tbody>

                            {foreach $topic_list as $topic sequence array( bglight, bgdark ) as $style}
                            {def $topic_reply_count=fetch( 'content', 'tree_count', hash( parent_node_id, $topic.node_id ) )
                                 $topic_reply_pages=sum( int( div( sum( $topic_reply_count, 1 ), 20 ) ), cond( mod( sum( $topic_reply_count, 1 ), 20 )|gt( 0 ), 1, 0 ) )}
                            <tr class="{$style}">
                                <td class="topic">
                                    <p>{if $topic.object.data_map.sticky.content}<img class="forum-topic-sticky" src={"sticky-16x16-icon.gif"|ezimage} height="16" width="16" align="middle" alt="" />{/if}
                                    <a href={$topic.url_alias|ezurl}>{$topic.object.name|wash}</a></p>
                                    {if $topic_reply_count|gt( sub( 20, 1 ) )}
                                        <p>
                                        {'Pages'|i18n( 'ezteamroom/forum' )}:
                                        {if $topic_reply_pages|gt( 5 )}
                                            <a href={$topic.url_alias|ezurl}>1</a>...
                                            {foreach $topic_reply_pages as $reply_page offset sub( $topic_reply_pages, sub( 5, 1 ) )}
                                                <a href={concat( $topic.url_alias, '/(offset)/', mul( sub( $reply_page, 1 ), 20 ) )|ezurl}>{$reply_page}</a>
                                            {/foreach}
                                        {else}
                                            <a href={$topic.url_alias|ezurl}>1</a>
                                            {foreach $topic_reply_pages as $reply_page offset 1}
                                                <a href={concat( $topic.url_alias, '/(offset)/', mul( sub( $reply_page, 1 ), 20 ) )|ezurl}>{$reply_page}</a>
                                            {/foreach}
                                        {/if}
                                        </p>
                                    {/if}
                                    <div class="attribute-byline">
                                    <span class="date">{$topic.object.published|l10n(shortdatetime)}</span> | <span class="author">{$topic.object.owner.name|wash}</span>
                                    </div>
                                </td>
                                <td class="replies">
                                    <p>{$topic_reply_count}</p>
                                </td>
                                <td class="lastreply">
                                {def $last_reply=fetch('content','list',hash( parent_node_id, $topic.node_id,
                                                                            sort_by, array( array( 'published', false() ) ),
                                                                            limit, 1 ) )}
                                    {foreach $last_reply as $reply}
                                    <div class="attribute-byline">
                                    <p>
                                    {if $topic_reply_count|gt( 19 )}
                                        <a href={concat( $reply.parent.url_alias, '/(offset)/', sub( $topic_reply_count, mod( $topic_reply_count, 20 ) ) , '#msg', $reply.node_id )|ezurl}>{'Last reply'|i18n('ezteamroom/forum')}</a>
                                    {else}
                                        <a href={concat( $reply.parent.url_alias, '#msg', $reply.node_id )|ezurl}>{'Last reply'|i18n('ezteamroom/forum')}</a>
                                    {/if}
                                    </p>
                                    <span class="date">{$reply.object.published|l10n(shortdatetime)}</span> |
                                    <span class="author">{$reply.object.owner.name|wash}</span>
                                    </div>

                                    {/foreach}
                            </td>
                            </tr>
                            {undef $topic_reply_count $topic_reply_pages $last_reply}
                            {/foreach}
                            </tbody>
                            </table>

                        </div>

                        </div>
                    </div>
                    {include name=navigator
                            uri='design:navigator/google.tpl'
                            page_uri=concat('/content/view','/full/',$node.node_id)
                            item_count=$topic_count
                            view_parameters=$view_parameters
                            item_limit=$page_limit
                            preference="teamroom_forum_list_limit"}

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

                    {if fetch( 'content', 'access', hash( 'access', 'create', 'contentobject', $node, 'contentclass_id', $class_identifier_map['forum_topic'] ) )}
                <div class="create-task">

                        <form method="post" action={"content/action/"|ezurl}>
                            <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                            <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
                            <input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                            <input type="hidden" name="NodeID" value="{$node.node_id}" />
                            <input type="hidden" name="ClassIdentifier" value="{$class_identifier_map['forum_topic']}" />
                            <div class="submitimage">
                             <div class="emptyButton">
                              <input class="mousePointer emptyButton" type="submit" name="NewButton" value="{'Add new topic'|i18n( 'ezteamroom/forum' )}" />
                             </div>
                            </div>
                        </form>
            </div>
                    {/if}

                    {undef $class_identifier_map}

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
                    </div></div></div>
                    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
                    </div>
            <!-- Content: END -->
            </div>
        </div>
    </div>

    </div>
</div>
