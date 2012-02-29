{if is_set($attribute_base)|not()}
    {def $attribute_base='ContentObjectAttribute'}
{/if}

{def $event_type = 12}

{* Set the default date depending on the class settings *}
{def $defaultDate = 0}
{switch match=$attribute.contentclass_attribute.data_int1}
    {case match=1}
        {set $defaultDate = currentdate()}
    {/case}
    {case match=2}
        {set $defaultDate = currentdate()}
    {/case}
{/switch}

<div id="ezeventattribute" class="block">
    <div id="ezeventattribute_selection">
        <input onclick="ezevent_seteditmode(11)" type="radio" name="{$attribute_base} _datetime_typeofevent_{$attribute.id}" value="11" {if $event_type|eq(11)}checked="checked"{/if} />{'Normal'|i18n( 'design/ezevent/content/datatype' )}
        <input onclick="ezevent_seteditmode(12)" type="radio" name="{$attribute_base} _datetime_typeofevent_{$attribute.id}" value="12" {if $event_type|eq(12)}checked="checked"{/if} />{'Full Day'|i18n( 'design/ezevent/content/datatype' )}
    </div>

    <div id="ezeventattribute_date">
        <div class="element">
            <label>{'Year'|i18n( 'design/ezwebin/content/datatype' )}:</label>
            <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_year" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="text" name="{$attribute_base}_datetime_year_{$attribute.id}" size="5" value="{if show=$attribute.content.is_valid}{$attribute.content.year}{/if}" />
        </div>
        <div class="element">
            <label>{'Month'|i18n( 'design/ezwebin/content/datatype' )}:</label>
            <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_month"  class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="text" name="{$attribute_base}_datetime_month_{$attribute.id}" size="3" value="{if show=$attribute.content.is_valid}{$attribute.content.month}{/if}" />
        </div>
        <div class="element">
            <label>{'Day'|i18n( 'design/ezwebin/content/datatype' )}:</label>
            <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_day" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="text" name="{$attribute_base}_datetime_day_{$attribute.id}" size="3" value="{if show=$attribute.content.is_valid}{$attribute.content.day}{/if}" />
        </div>
        <div class="element">
            <img class="datepicker-icon" src={"calendar_icon.png"|ezimage} id="{$attribute_base}_datetime_cal_{$attribute.id}" width="24" height="28" onclick="showDatePicker( '{$attribute_base}', '{$attribute.id}', 'datetime' );" style="cursor: pointer;" />
            <div id="{$attribute_base}_datetime_cal_container_{$attribute.id}" style="display: none; position: absolute;"></div>
            &nbsp;
            &nbsp;
            &nbsp;
            &nbsp;
        </div>
    </div>

    <div id="ezeventattribute_starttime">
        <div class="element">
            <label>{'Hour'|i18n( 'design/ezwebin/content/datatype' )}:</label>
            <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_hour" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="text" name="{$attribute_base}_datetime_hour_{$attribute.id}" size="3" value="{if $attribute.content.is_valid}{$attribute.content.hour}{else}23{/if}" />
        </div>
        <div class="element">
            <label>{'Minute'|i18n( 'design/ezwebin/content/datatype' )}:</label>
            <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_minute" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="text" name="{$attribute_base}_datetime_minute_{$attribute.id}" size="3" value="{if$attribute.content.is_valid}{$attribute.content.minute}{else}59{/if}" />
        </div>
    </div>
    <div class="break"></div>
</div>

<script type="text/javascript" language="javascript">
    ezevent_initWithMode( {$event_type} );
</script>

