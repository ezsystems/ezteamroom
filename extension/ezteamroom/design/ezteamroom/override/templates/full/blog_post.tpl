{def $frontpagestyle='noleftcolumn rightcolumn'}

<div class="content-view-full">
    <div class="class-blog_post {$frontpagestyle}">

    <div class="attribute-header">
        <h1>{$node.name|wash()}</h1>
    </div>

    <div class="columns-frontpage float-break">

        <div class="center-column-position">
            <div class="center-column float-break">
                <div class="overflow-fix">
                <!-- Content: START -->



                    <div class="border-box">
                    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
                    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

                            <div class="content-view-full">
                                <div class="class-blog-post float-break">

                                    <div class="attribute-byline">
                                        <span class="date">{$node.data_map.publication_date.content.timestamp|l10n(shortdatetime)}</span> |
                                        <span class="author"><strong>{'Author'|i18n('ezteamroom/blog')} </strong>{$node.object.owner.name|wash()}</span>
                                    </div>



                                        <div class="attribute-body">
                                            {attribute_view_gui attribute=$node.data_map.body}
                                        </div>

                                    <div class="attribute-byline">
                                        <p class="tags"> Tags: {foreach $node.data_map.tags.content.keywords as $keyword}
                                                                        <a href={concat( $node.parent.url_alias, "/(tag)/", $keyword|rawurlencode )|ezurl} title="{$keyword}">{$keyword|wash()}</a>
                                                                        {delimiter}
                                                                            ,
                                                                        {/delimiter}
                                                                    {/foreach}
                                        </p>
                                    </div>


                                    {if $node.data_map.enable_comments.data_int}
                                    <div class="attribute-comments">
                                        <a name="comments" id="comments"></a>
                                        {def $comment_list = fetch_alias( 'teamroom_comments', hash( 'parent_node_id', $node.node_id ) )}
                                        {if $comment_list|count()|eq(0)}
                                            <h1>{"No Comments"|i18n("ezteamroom/blog")}</h1>
                                        {else}
                                            <h1>{"Comments"|i18n("ezteamroom/blog")}</h1>
                                        {/if}
                                        <div class="content-view-children">
                                            {foreach $comment_list as $comment}
                                                {node_view_gui view='line' content_node=$comment}
                                            {/foreach}
                                        </div>
                                    </div>
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

                {def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}

                {if and(fetch( 'content', 'access', hash( 'access', 'create',
                                                          'contentobject', $node,
                                                          'contentclass_id', $class_identifier_map['comment'] ) ), $node.data_map.enable_comments.data_int)}
                <div class="create-task">
                <form method="post" action={"content/action"|ezurl}>
                    <input type="hidden" name="ClassIdentifier" value="{$class_identifier_map['comment']}" />
                    <input type="hidden" name="NodeID" value="{$node.object.main_node.node_id}" />
                    <input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                            <input type="hidden" name="RedirectURIAfterPublish" value="{$node.url_alias}" />
                            <input type="hidden" name="RedirectIfDiscarded" value="{$node.url_alias}" />
                            <div class="submitimage">
                             <div class="emptyButton">
                              <input class="mousePointer emptyButton" type="submit" name="NewButton" value="{'Add Comment'|i18n( 'ezteamroom/blog' )}" />
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



            <div class="keywords">
                <h3>{'Keywords'|i18n('ezteamroom/blog')}</h3>
                {def $sorting=cond($sort_by_field, concat("/(sortfield)/", $sort_by_field))}
                <div class="tags">
                {foreach ezkeywordlist( $class_identifier_map['blog_post'], $node.parent.node_id) as $keyword}<a href={concat( $node.parent.url_alias, "/(tag)/", $keyword.keyword|rawurlencode, $sorting )|ezurl} title="{$keyword.keyword}" {if and($view_parameters.tag,$view_parameters.tag|eq($keyword.keyword))}class="selected"{/if}>{$keyword.keyword|wash()}</a>{delimiter}, {/delimiter}{/foreach}
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

