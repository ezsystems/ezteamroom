{default $view_parameters=array()
         $hidden_attributes=array()}
{foreach $content_attributes as $attribute sequence array( 'bglight', 'bgdark' ) as $sequence}
    <div class="edit-attribute block {$sequence}"
         {if $hidden_attributes|contains($attribute.contentclass_attribute.identifier)}style="display:none;"{/if}>
    {if and(eq($attribute.contentclass_attribute.can_translate,0),
                      ne($object.initial_language_code,$attribute.language_code) ) }
        <label class="title">{$attribute.contentclass_attribute.name|wash}{if $attribute.contentclass_attribute.is_required} *{/if}</label><div class="labelbreak"></div>
        <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
        {attribute_view_gui attribute_base=$attribute_base attribute=$attribute view_parameters=$view_parameters assigned_node_array=$assigned_node_array}
    {else}
        <label class="title{if $attribute.has_validation_error} validation-error{/if}">{$attribute.contentclass_attribute.name|wash}{if $attribute.contentclass_attribute.is_required} *{/if}</label><div class="labelbreak"></div>
        <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
        {attribute_edit_gui attribute_base=$attribute_base attribute=$attribute view_parameters=$view_parameters assigned_node_array=$assigned_node_array}

    {/if}
    </div>

{/foreach}
{/default}
