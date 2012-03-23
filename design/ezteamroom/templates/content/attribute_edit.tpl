{if and( eq( $attribute.can_translate, 0 ), ne( $object.initial_language_code, $attribute.language_code ) )}
    <label>{$attribute.contentclass_attribute_name|wash}{if $attribute.can_translate|not} <span class="nontranslatable">({'not translatable'|i18n( 'ezteamroom/edit' )})</span>{/if}:</label>
    {if $is_translating_content}
        <div class="original">
        {attribute_view_gui attribute_base=$attribute_base attribute=$attribute}
        <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
        </div>
    {else}
        {attribute_view_gui attribute_base=$attribute_base attribute=$attribute}
        <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
    {/if}
{else}
    {if $is_translating_content}
        <label{if $attribute.has_validation_error} class="message-error"{/if}>{$attribute.contentclass_attribute_name|wash}{if $attribute.is_required} <span class="required">({'required'|i18n( 'ezteamroom/edit' )})</span>{/if}{if $attribute.is_information_collector} <span class="collector">({'information collector'|i18n( 'ezteamroom/edit' )})</span>{/if}:</label>
        <div class="original">
        {attribute_view_gui attribute_base=$attribute_base attribute=$from_content_attributes[$attributes.key]}
        </div>
        <div class="translation">
        {if $attributes.display_info.edit.grouped_input}
            <fieldset>
            {attribute_edit_gui attribute_base=$attribute_base attribute=$attribute}
            <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
            </fieldset>
        {else}
            {attribute_edit_gui attribute_base=$attribute_base attribute=$attribute}
            <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
        {/if}
        </div>
    {else}
        {if $attributes.display_info.edit.grouped_input}
            <fieldset>
            <legend{if $attribute.has_validation_error} class="message-error"{/if}>{$attribute.contentclass_attribute_name|wash}{if $attribute.is_required} <span class="required">({'required'|i18n( 'ezteamroom/edit' )})</span>{/if}{if $attribute.is_information_collector} <span class="collector">({'information collector'|i18n( 'ezteamroom/edit' )})</span>{/if}</legend>
            {attribute_edit_gui attribute_base=$attribute_base attribute=$attribute}
            <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
            </fieldset>
        {else}
            <label{if $attribute.has_validation_error} class="message-error"{/if}>{$attribute.contentclass_attribute_name|wash}{if $attribute.is_required} <span class="required">({'required'|i18n( 'ezteamroom/edit' )})</span>{/if}{if $attribute.is_information_collector} <span class="collector">({'information collector'|i18n( 'ezteamroom/edit' )})</span>{/if}:</label>
            {attribute_edit_gui attribute_base=$attribute_base attribute=$attribute}
            <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
        {/if}
    {/if}
{/if}
