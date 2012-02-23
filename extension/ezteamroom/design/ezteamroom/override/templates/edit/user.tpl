<form enctype="multipart/form-data" id="editform" name="editform" method="post" action={concat("/content/edit/",$object.id,"/",$edit_version,"/",$edit_language|not|choose(concat($edit_language,"/"),''))|ezurl}>

<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-edit">

    <div class="attribute-header">
        <h1 class="long">{'Edit %1 - %2'|i18n( 'ezteamroom/membership', , array( $class.name|wash, $object.name|wash ) )}</h1>
    </div>

    {include uri='design:content/edit_validation.tpl'}

    {include uri='design:content/edit_attribute.tpl'}

    <div class="buttonblock">
    <input class="defaultbutton" type="submit" name="PublishButton" value="{'Store'|i18n( 'ezteamroom/membership' )}" />
    <input class="button" type="submit" name="DiscardButton" value="{'Discard'|i18n( 'ezteamroom/membership' )}" />
    <input type="hidden" name="DiscardConfirm" value="0" />
        {* if ezhttp_hasvariable( 'RedirectIfDiscarded', 'session' )}
        <input type="hidden" name="RedirectIfDiscarded" value="{ezhttp( 'RedirectIfDiscarded', 'session' )}" />
        {else}
        <input type="hidden" name="RedirectIfDiscarded" value="/user/edit/{$object.id}" />
        {/if}
        {if ezhttp_hasvariable( 'RedirectURIAfterPublish', 'session' )}
        <input type="hidden" name="RedirectURIAfterPublish" value="{ezhttp( 'RedirectURIAfterPublish', 'session' )}" />
        {else}
        <input type="hidden" name="RedirectURIAfterPublish" value="/user/edit/{$object.id}" />
        {/if *}
    </div>
</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>

</form>
