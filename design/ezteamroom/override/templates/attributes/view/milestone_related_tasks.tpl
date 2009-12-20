{if $attribute.content.relation_list}
<ul>
    {foreach $attribute.content.relation_list as $item sequence array( bglight, bgdark ) as $style}
        {if $item.in_trash|not()}
            <li>
                {content_view_gui view='smallline' style=$style content_object=fetch( content, object, hash( object_id, $item.contentobject_id ) )}
            </li>
        {/if}
    {/foreach}
</ul>
{else}
{'There are no related tasks.'|i18n( 'ezteamroom/tasks' )}
{/if}