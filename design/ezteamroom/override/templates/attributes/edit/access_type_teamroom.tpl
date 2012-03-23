{if is_set($attribute_base)|not()}
{def $attribute_base='ContentObjectAttribute'}
{/if}
{def $selected_id_array=$attribute.content
     $visibility_list=ezini( "TeamroomSettings", "VisibilityList", "teamroom.ini" )}

<input type="hidden" name="{$attribute_base}_ezselect_selected_array_{$attribute.id}" value="" />

<select id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" name="{$attribute_base}_ezselect_selected_array_{$attribute.id}[]" {if $attribute.class_content.is_multiselect}multiple{/if}>

{foreach $visibility_list as $visibility}
    {def $visibility_name=ezini( concat( "VisibilitySettings_", $visibility ), "Title", "teamroom.ini" )}
    <option value="{$visibility}" {if $selected_id_array|contains( $visibility )}selected="selected"{/if}>{$visibility_name|wash( xhtml )}</option>
    {undef $visibility_name}
{/foreach}

</select>