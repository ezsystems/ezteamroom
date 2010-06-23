{if $attribute.content.relation_list}
    {foreach $attribute.content.relation_list as $item}
        {if $item.in_trash|not()}
            {def $showEmbed = true()}
            {if is_set( $teamroom_node_id )}
                {def $contentObject = fetch( content, object, hash( object_id, $item.contentobject_id ) )}
                {foreach $contentObject.assigned_nodes as $contentNode}
                    {if $contentNode.path_string|contains( concat( '/', $teamroom_node_id, '/' ) )}
                        {set $showEmbed = false()}
                        <a href={$contentNode.url_alias|ezurl()}>{$contentObject.name|wash()}</a>
                        {break}
                    {/if}
                {/foreach}
                {undef $contentObject}
            {/if}
            {if $showEmbed}
                {content_view_gui view=embed content_object=fetch( content, object, hash( object_id, $item.contentobject_id ) )}
            {/if}
            {undef $showEmbed}
        {/if}
        {delimiter}, {/delimiter}
    {/foreach}
{else}
{'No one defined.'|i18n( 'ezteamroom/tasks' )}
{/if}
