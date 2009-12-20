{def $default_limit = 15}

{if ezpreference( 'teamroom_forum_list_limit' )}

    {set $default_limit = ezpreference( 'teamroom_forum_list_limit' )}

{/if}

{def $page_limit = first_set( $default_limit, 5 )}

{if $view_parameters.limit|gt(0)}

    {set $page_limit = $view_parameters.limit}

{/if}

{def $replies_to_show = cond($page_limit|eq(-1), $children_count, $page_limit )
     $frontpagestyle='noleftcolumn rightcolumn'}

<div class="content-view-full">
    <div class="class-forum_topic {$frontpagestyle}">

    <div class="attribute-header">
        <h1>{attribute_view_gui attribute=$node.data_map.subject}</h1>
    </div>

    <div class="columns-frontpage float-break">
        <div class="center-column-position">
            <div class="center-column float-break">
                <div class="overflow-fix">
                <!-- Content: START -->


                    {def $reply_offset=cond( $view_parameters.offset|gt( 0 ), sub( $view_parameters.offset, 1 ),
                                             $view_parameters.offset )
                         $reply_count=fetch('content','list_count', hash( parent_node_id, $node.node_id ) )
                         $reply_list=fetch('content','list', hash( parent_node_id, $node.node_id,
                                                                limit, $replies_to_show,
                                                                offset, $reply_offset,
                                                                sort_by, array( array( published, true() ) ) ) )
                         $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
                         $previous_topic=fetch_alias( subtree, hash( parent_node_id, $node.parent_node_id,
                                                                    class_filter_type, include,
                                                                    class_filter_array, array( $class_identifier_map['forum_topic'] ),
                                                                    limit, 1,
                                                                    attribute_filter, array( and, array( 'modified_subnode', '<', $node.modified_subnode ) ),
                                                                    sort_by, array( array( 'modified_subnode', false() ) ) ) )
                         $next_topic=fetch_alias( subtree, hash( parent_node_id, $node.parent_node_id,
                                                                class_filter_type, include,
                                                                class_filter_array, array( $class_identifier_map['forum_topic'] ),
                                                                limit, 1,
                                                                attribute_filter, array( and, array( 'modified_subnode', '>', $node.modified_subnode ) ),
                                                                sort_by, array( array( 'modified_subnode', true() ) ) ) ) }

                    <div class="border-box">
                    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
                    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

                    <div class="content-view-full">
                        <div class="class-forum-topic">

                                <a id="msg{$node.node_id}"></a>
                                <table class="list forum" cellspacing="0">
                                {if $view_parameters.offset|lt( 1 )}
                                <tr class="header">
                                    <td colspan="2">
                                        {$node.object.published|l10n(datetime)}
                                        <div class="manage_forum_reply float-break">
                                        {if $node.object.can_edit}
                                            <form method="post" action={"content/action/"|ezurl}>
                                                <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
                                                <input class="forum-account-edit" type="image" src={'edit.png'|ezimage} name="EditButton" value="{'Edit'|i18n('ezteamroom/forum')}" title="{'Edit this entry'|i18n( 'ezteamroom/forum' )}" />
                                                <input type="hidden" name="ContentObjectLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                                            </form>
                                        {/if}
                                        {if $node.object.can_remove}
                                            <form method="post" action={"content/action/"|ezurl}>
                                                <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
                                                <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                                                <input type="image" src={'remove.png'|ezimage} name="ActionRemove" value="{'Remove'|i18n( 'ezteamroom/forum' )}" title="{'Delete this entry'|i18n( 'ezteamroom/forum' )}" />                      </form>
                                        {/if}
                                        </div>
                                    </td>
                                </tr>
                                <tr class="bglight">
                                <td class="author float-break">
                                {def $owner=$node.object.owner
                                     $owner_map=$owner.data_map}
                                    {if $owner_map.image.has_content}
                                    <div class="authorimage">
                                        {attribute_view_gui attribute=$owner_map.image image_class=small}
                                    </div>
                                    {/if}
                                    <p class="author">{$owner.name|wash}</p>
                                </td>
                                <td class="message">
                                    <p>
                                        {$node.data_map.message.content|simpletags|wordtoimage|autolink}
                                    </p>
                                    {if $owner_map.signature.has_content}
                                        <p class="author-signature">{$owner_map.signature.content|simpletags|autolink}</p>
                                    {/if}
                                </td>
                                {undef $owner $owner_map}
                            </tr>
                            {/if}

                            {* On first page do not show last replie (because the forum topic by itself is counted as one replie) *}
                            {if $view_parameters.offset|lt( 1 )}
                                {set $replies_to_show = $replies_to_show|dec}
                            {/if}
                            {foreach $reply_list as $reply sequence array( bgdark, bglight ) as $sequence max $replies_to_show}
                            <tr class="header">
                                <td colspan="2" class="float-break">
                                    <div class="date">{$reply.object.published|l10n(datetime)}</div>
                                <div class="manage_forum_reply float-break">
                                    {if $reply.object.can_edit}
                                        <form method="post" action={"content/action/"|ezurl}>
                                        <input type="hidden" name="ContentObjectID" value="{$reply.object.id}" />
                                        <input type="image" src={'edit.png'|ezimage} name="EditButton" value="{'Edit'|i18n('ezteamroom/forum')}" title="{'Edit this reply'|i18n( 'ezteamroom/forum' )}" />
                                        <input type="hidden" name="ContentObjectLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                                        </form>
                                    {/if}
                                    {if $node.object.can_remove}
                                        <form method="post" action={"content/action/"|ezurl}>
                                            <input type="hidden" name="ContentObjectID" value="{$reply.object.id}" />
                                            <input type="hidden" name="ContentNodeID" value="{$reply.node_id}" />
                                            <input type="image" src={'remove.png'|ezimage} name="ActionRemove" value="{'Remove'|i18n( 'ezteamroom/forum' )}" title="{'Remove this item.'|i18n( 'ezteamroom/forum' )}" title="{'Remove this reply'|i18n( 'ezteamroom/forum' )}" />
                                            </form>
                                    {/if}
                                    <a href="#msg{$node.node_id}" title="{'Jump to top'|i18n( 'ezteamroom/forum' )}"><img src={'forum_up.gif'|ezimage} alt="forum_up_icon" title="{'Jump to the top of this page'|i18n( 'ezteamroom/forum' )}" /></a>

                                </div>
                                </td>
                            </tr>
                            <tr class="{$sequence}">
                                <td class="author">
                                {def $owner=$reply.object.owner
                                     $owner_map=$owner.data_map}
                                    {if $owner_map.image.has_content}
                                    <div class="authorimage">
                                        {attribute_view_gui attribute=$owner_map.image image_class=small}
                                    </div>
                                    {/if}

                                    <p class="author">{$owner.name|wash}
                                </td>
                                <td class="message">
                                    <a id="msg{$reply.node_id}"></a>
                                    <p>
                                        {$reply.object.data_map.message.content|simpletags|wordtoimage|autolink}
                                    </p>

                                    {if $owner_map.signature.has_content}
                                        <p class="author-signature">{$owner_map.signature.content|simpletags|autolink}</p>
                                    {/if}
                                {undef $owner $owner_map}
                                </td>
                            </tr>
                            {/foreach}

                            </table>



                    {include name=navigator
                            uri='design:navigator/google.tpl'
                            page_uri=$node.url_alias
                            item_count=inc($reply_count)
                            view_parameters=$view_parameters
                            item_limit=$page_limit
                            preference      = "teamroom_forum_list_limit"}

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
                    {def $can_create = fetch( 'content', 'access', hash( 'access', 'create', 'contentobject', $node, 'contentclass_id', $class_identifier_map['forum_reply'] ) )}
                    {if $can_create}

                <div class="create-task">
                        <form method="post" action={"content/action/"|ezurl}>
                            <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                            <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
                            <input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                            <input type="hidden" name="NodeID" value="{$node.node_id}" />
                            <input type="hidden" name="ClassIdentifier" value="{$class_identifier_map['forum_reply']}" />
                            <input type="hidden" name="RedirectURIAfterPublish" value="{$node.parent.url_alias}" />
                            <input type="hidden" name="RedirectIfDiscarded" value="{$node.parent.url_alias}" />
                            <div class="submitimage">
                             <div class="emptyButton">
                              <input class="mousePointer emptyButton" type="submit" name="NewButton" value="{'Reply'|i18n( 'ezteamroom/forum' )}" />
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



            <div class="categories">
                <h3>{'Navigation'|i18n('ezteamroom/forum')}</h3>
                <ul>
                    <li>
                        {if $previous_topic}
                            <a href={$previous_topic[0].url_alias|ezurl} title="{$previous_topic[0].name|wash}">{'Previous topic'|i18n( 'ezteamroom/forum' )}</a>
                        {else}
                            {'Previous topic'|i18n( 'ezteamroom/forum' )}
                        {/if}
                    </li>

                    <li><a href={$node.parent.url_alias|ezurl}>{$node.parent.name|wash}</a></li>

                    <li>
                        {if $next_topic}
                            <a href={$next_topic[0].url_alias|ezurl} title="{$next_topic[0].name|wash}">{'Next topic'|i18n( 'ezteamroom/forum' )}</a>
                        {else}
                            {'Next topic'|i18n( 'ezteamroom/forum' )}
                        {/if}
                    </li>
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
