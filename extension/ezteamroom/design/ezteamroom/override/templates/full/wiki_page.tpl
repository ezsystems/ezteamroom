<div class="content-view-full">
<div class="class-wiki-page {*leftcolumn *}noleftcolumn norightcolumn">

    <div class="attribute-header">
        <h1>{'Wiki'|i18n('ezteamroom/wiki')}</h1>
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
                        <div class="class-wiki-page">

                            <div class="attribute-byline">
                                <span class="date">{$node.object.modified|l10n(shortdatetime)}</span> |
                                <span class="author"><strong>{'Author'|i18n('ezteamroom/wiki')} </strong>{$node.object.owner.name|wash()}</span>
                            </div>

                            <div class="blog_actions float-break">
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


                                <div class="keep-me-updated">
                                    <form method="post" action={"content/action/"|ezurl}>
                                        <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                                        <div class="keepupdated">
                                            <div class="arrowWhiteButton">
                                            <input class="mousePointer arrowWhiteButton" type="submit" name="ActionAddToNotification" value="{'Keep me updated'|i18n( 'ezteamroom/keepmeupdated' )}" title="{'Receive an email if anything changes in this area'|i18n( 'ezteamroom/keepmeupdated' )}" />
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>


                            <div class="attribute-header">
                                <h1>{attribute_view_gui attribute=$node.object.data_map.title}</h1>
                            </div>

                            <div class="attribute-body">

                                {def $toc = eztoc2( $node.object.data_map.body )}
                                {if $toc}
                                <div class="attribute-toc">
                                    <h2>{'Table of contents'|i18n( 'ezteamroom/wiki' )}</h2>
                                    {$toc}
                                </div>
                                {/if}
                                {undef $toc}


                                {attribute_view_gui attribute=$node.object.data_map.body}


                            </div>
                        </div>
                    </div>

                    </div></div></div>
                    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
                    </div>


                <!-- Content: END -->
                </div>
            </div>
        </div>
{*        <div class="right-column-position">
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
        </div>*}
    </div>

</div>
</div>