{default $attr_view='text_linked'
         $object_parameters=hash()}
    {if $attribute.content}
        {content_view_gui view=$attr_view content_object=$attribute.content object_parameters=$object_parameters}
    {/if}
{/default}
