{default attribute_base=ContentObjectAttribute}
{def $data_array=hash( '5', 'low'|i18n('ezteamroom/tasks'), '4', 'tepid'|i18n('ezteamroom/tasks'), '3', 'normal'|i18n('ezteamroom/tasks'), '2', 'medium'|i18n('ezteamroom/tasks'), '1', 'high'|i18n('ezteamroom/tasks')  )}
<p>{'Priority:'|i18n('ezteamroom/tasks')}


<select id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" 
        class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" 
        name="{$attribute_base}_data_integer_{$attribute.id}">
    {foreach $data_array as $key => $value}
        <option value="{$key}" {if $attribute.data_int|eq($key)}selected="selected"{/if}>{$key}{if $value|ne('')} ({$value|wash( xhtml )}){/if}</option>
    {/foreach}
</select>

{/default}
