<form enctype="multipart/form-data" id="editform" name="editform" method="post" action={concat("/content/edit/",$object.id,"/",$edit_version,"/",$edit_language|not|choose(concat($edit_language,"/"),''))|ezurl}>

{* {include uri='design:parts/website_toolbar_edit.tpl'} *}

<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-edit">

    <div class="attribute-header">
        {if $edit_version|gt(1)}
            <h1 class="long">{'Edit %1 - %2'|i18n( 'ezteamroom/files', , array( $class.name|wash, $object.name|wash ) )}</h1>
        {else}
            <h1 class="long">{'Create new file'|i18n( 'ezteamroom/files' )}</h1>
        {/if}
    </div>



    {include uri='design:content/edit_validation.tpl'}

    {include uri='design:content/edit_attribute.tpl' hidden_attributes=array('description', 'thumbnail')}

    <div class="buttonblock">
        {if $edit_version|gt(1)}
    <input class="defaultbutton" type="submit" name="PublishButton" value="{'Store File'|i18n( 'ezteamroom/files' )}" />
        {else}
    <input class="defaultbutton" type="submit" name="PublishButton" value="{'Create File'|i18n( 'ezteamroom/files' )}" />
        {/if}
    <input class="button" type="submit" name="DiscardButton" value="{'Discard'|i18n( 'ezteamroom/files' )}" />
    <input type="hidden" name="DiscardConfirm" value="0" />
        {*if $edit_version|gt(1)}
            <input type="hidden" name="RedirectIfDiscarded" value={$object.main_node.parent.url_alias|wash()} />
            <input type="hidden" name="RedirectURIAfterPublish" value={$object.main_node.parent.url_alias|wash()} />
        {else}
            <input type="hidden" name="RedirectIfDiscarded" value="{ezhttp( 'LastAccessesURI', 'session' )}" />
            <input type="hidden" name="RedirectURIAfterPublish" value="{ezhttp( 'LastAccessesURI', 'session' )}" />
        {/if*}
    </div>
</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>

</form>
