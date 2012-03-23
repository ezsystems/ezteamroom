{* Article - Full view *}

<div class="attribute-header">
    <h1 class="long">{$node.parent.name|wash()}</h1>
</div>


<div id="full_article">
    <div class="message-icon float-left">
        <img src={'icons/icon_info.jpg'|ezimage()} alt="" />
    </div>
    <div class="message-textcontent float-right box_background">
        <h1>{$node.data_map.title.content|wash()}</h1>
        {if $node.data_map.author.content.is_empty|not()}
        <div class="attribute-byline">
        <span class="date">
             {$node.object.published|l10n(date)},
        </span>
        <span class="author">
             {attribute_view_gui attribute=$node.data_map.author}
        </span>
        </div>
        {/if}

        {if $node.data_map.image.content}
            <div class="attribute-image">
                {attribute_view_gui attribute=$node.data_map.image align=right}
            </div>
        {/if}

        {if $node.data_map.intro.content.is_empty|not}
            <div class="attribute-short">
                {attribute_view_gui attribute=$node.data_map.intro}
            </div>
        {/if}

        {if $node.data_map.body.content.is_empty|not}
            <div class="attribute-long">
                {attribute_view_gui attribute=$node.data_map.body}
            </div>
        {/if}

        <div class="attribute-tipafriend float-left">
          <p>
             <a href={concat('/content/tipafriend/',$node.node_id)|ezurl}>{"Tip a friend"|i18n("ezteamroom/article")}</a>
          </p>
        </div>

        <div class="attribute-pdf float-right">
          <p>
             <a href={concat('/content/pdf/',$node.node_id)|ezurl}>{'application/pdf'|mimetype_icon( small, "Download PDF"|i18n( "ezteamroom/article" ) )} {"Download PDF version of this page"|i18n( "ezteamroom/article" )}</a>
          </p>
        </div>

        {* Should we allow comments? *}
        {if is_unset( $versionview_mode )}
        {if $node.data_map.enable_comments.content}
            <h2>{"Comments"|i18n("ezteamroom/article")}</h2>
                <div class="content-view-children">
                    {section name=Child loop=fetch_alias( 'teamroom_comments', hash( 'parent_node_id', $node.node_id ) )}
                        {node_view_gui view='line' content_node=$:item}
                    {/section}
                </div>

                {def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}

                {* Are we allowed to create new object under this node? *}
                {if fetch( content, access,
                                     hash( access, 'create',
                                           contentobject, $node,
                                           contentclass_id, $class_identifier_map['comment'] ) )}
                    <form method="post" action={"content/action"|ezurl}>
                    <input type="hidden" name="ClassIdentifier" value="{$class_identifier_map['comment']}" />
                    <input type="hidden" name="NodeID" value="{$node.node_id}" />
                    <input class="button new_comment" type="submit" name="NewButton" value="{'New Comment'|i18n( 'ezteamroom/article' )}" />
                    </form>
                {else}
                    <h3>{"You are not allowed to create comments."|i18n("ezteamroom/article")}</h3>
                {/if}

                {undef $class_identifier_map}
        {/if}
        {/if}

    </div>
    <div class="float-break"></div>
</div>



