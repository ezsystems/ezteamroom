<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-edit">
    <div class="class-comment">

    <form enctype="multipart/form-data" method="post" action={concat( "/content/edit/", $object.id, "/", $edit_version, "/", $edit_language|not|choose( concat( $edit_language, "/" ), '' ) )|ezurl}>

    <div class="attribute-header">
        <h1 class="long">{"Edit %1 - %2"|i18n("ezteamroom/comment",,array( $class.name|wash(), $object.name|wash() ) )}</h1>
    </div>

    {include uri="design:content/edit_validation.tpl"}

    <div class="edit-attribute block">
       {def $attribute = $object.data_map.subject}
       <label class="title">{$attribute.contentclass_attribute.name}{if $attribute.contentclass_attribute.is_required} *{/if}</label><div class="labelbreak"></div>
       <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
       <input class="box" type="text" size="70" name="ContentObjectAttribute_ezstring_data_text_{$attribute.id}" value="{$attribute.content|wash()}" />
    </div>

    {def $current_user = fetch( 'user', 'current_user' )}
    {set $attribute = $object.data_map.author}
        {if $current_user.is_logged_in}
        <input type="hidden" name="ContentObjectAttribute_ezstring_data_text_{$attribute.id}" value="{$current_user.contentobject.name|wash()}" />
        {else}
    <div class="edit-attribute block">
            <label class="title">{$attribute.contentclass_attribute.name}{if $attribute.contentclass_attribute.is_required} *{/if}</label><div class="labelbreak"></div>
        <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
        <input class="box" type="text" size="70" name="ContentObjectAttribute_ezstring_data_text_{$attribute.id}" value="{$attribute.content|wash()}" />
    </div>
        {/if}

    <div class="edit-attribute block">
       {set $attribute = $object.data_map.message}
       <label class="title">{$attribute.contentclass_attribute.name}{if $attribute.contentclass_attribute.is_required} *{/if}</label><div class="labelbreak"></div>
       <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
       <textarea class="box" cols="70" rows="10" name="ContentObjectAttribute_data_text_{$attribute.id}">{$attribute.content|wash()}</textarea>
    </div>

    <div class="buttonblock">
        <input class="defaultbutton" type="submit" name="PublishButton" value="{'Store Comment'|i18n('ezteamroom/comment')}" />
        <input class="button" type="submit" name="DiscardButton" value="{'Discard'|i18n('ezteamroom/comment')}" />
        <input type="hidden" name="MainNodeID" value="{$main_node_id }" />
        <input type="hidden" name="DiscardConfirm" value="0" />
        <input type="hidden" name="RedirectIfDiscarded" value={$object.main_node.parent.url_alias|wash()} />
    </div>

    </form>

    </div>
</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
