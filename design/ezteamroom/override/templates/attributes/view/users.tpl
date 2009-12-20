{if $attribute.content.relation_list}
    {foreach $attribute.content.relation_list as $item}
        {if $item.in_trash|not()}
            {content_view_gui view=embed content_object=fetch( content, object, hash( object_id, $item.contentobject_id ) )}
        {/if}
        {delimiter}, {/delimiter}
    {/foreach}
{else}
{'No one defined.'|i18n( 'ezteamroom/tasks' )}
{/if}
