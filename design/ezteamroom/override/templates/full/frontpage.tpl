{def $frontpagestyle='noleftcolumn norightcolumn'}

{if $node.object.data_map.left_column.has_content}
    {set $frontpagestyle='leftcolumn norightcolumn'}
{/if}

{if eq( $frontpagestyle, 'leftcolumn norightcolumn')}
    {if $node.object.data_map.right_column.has_content}
        {set $frontpagestyle='leftcolumn rightcolumn'}
    {/if}
{else}
    {if $node.object.data_map.right_column.has_content}
        {set $frontpagestyle='noleftcolumn rightcolumn'}
    {/if}
{/if}

{def $children=fetch('content', 'list', hash( 'parent_node_id', $node.node_id,
                                              'sort_by', $node.sort_array
                                              )
                    )
}

<div class="content-view-full">
    <div class="class-frontpage {$frontpagestyle}">

        <div class="attribute-header">
            <h1 class="long">{$node.name|wash()}</h1>
        </div>

        <div id="message_allcontent">
            <div class="message-icon float-left">
                <img src={'icons/icon_info.jpg'|ezimage()} alt="" />
            </div>

            <div class="message-textcontent float-right">
                {if $node.object.data_map.billboard.has_content}
                    <div class="attribute-billboard">
                        {content_view_gui view=billboard content_object=$node.object.data_map.billboard.content}
                    </div>
                {/if}
                <div class="columns-frontpage float-break">
                    <div class="center-column float-break">
                        <div class="overflow-fix">
                        <!-- Content: START -->
                               {attribute_view_gui attribute=$node.object.data_map.left_column}
                        <!-- Content: END -->
                        </div>
                    </div>
                    <div class="center-column-position">
                        <div class="center-column float-break">
                            <div class="overflow-fix">
                            <!-- Content: START -->
                                {attribute_view_gui attribute=$node.object.data_map.center_column}
                            <!-- Content: END -->
                            </div>
                        </div>
                    </div>
                    <div class="center-column float-break">
                        <div class="overflow-fix">
                        <!-- Content: START -->
                              {attribute_view_gui attribute=$node.object.data_map.right_column}
                        <!-- Content: END -->
                        </div>
                    </div>
                </div>
                <div class="attribute-bottom-column">
                    {attribute_view_gui attribute=$node.object.data_map.bottom_column}
                </div>

                <div class="more_foot">
                    <ul>
                    {foreach $children as $child}
                        <li><a class="help-item-link" title="{$child.name|wash()}" href={$child.url_alias|ezurl()}>{$child.name|wash()}</a></li>
                    {/foreach}
                    </ul>
                </div>
            </div>

        </div>

    </div>
</div>
