{* Forum reply - Edit *}

<div class="edit">
    <div class="class-forum-reply">

        <form enctype="multipart/form-data" method="post" action={concat( "/content/edit/", $object.id, "/", $edit_version, "/", $edit_language|not|choose( concat( $edit_language, "/" ), '' ) )|ezurl}>

        {if $object.name|ne( '' )}

        <h1>{"Edit %1 - %2"|i18n("ezteamroom/forum",,array($class.name|wash,$object.name|wash))}</h1>

        {else}

        <h1>{"Edit %1"|i18n("ezteamroom/forum",,array($class.name|wash ) )}</h1>

        {/if}

        {include uri="design:content/edit_validation.tpl"}

        <input type="hidden" name="MainNodeID" value="{$main_node_id}" />
        {include uri="design:content/edit_attribute.tpl" hidden_attributes=array('subject')}
        <br/>

        <div class="buttonblock">
        {*if $edit_version|gt(1)}
            <input type="hidden" name="RedirectIfDiscarded" value={$object.main_node.parent.url_alias|wash()} />
            <input type="hidden" name="RedirectURIAfterPublish" value={$object.main_node.parent.url_alias|wash()} />
        {else}
            <input type="hidden" name="RedirectIfDiscarded" value="{ezhttp( 'LastAccessesURI', 'session' )}" />
            <input type="hidden" name="RedirectURIAfterPublish" value="{ezhttp( 'LastAccessesURI', 'session' )}" />
        {/if*}
            <input class="defaultbutton" type="submit" name="PublishButton" value="{'Store'|i18n('ezteamroom/forum')}" />
            <input class="button" type="submit" name="DiscardButton" value="{'Discard'|i18n('ezteamroom/forum')}" />
            <input type="hidden" name="DiscardConfirm" value="0" />
        </div>

        </form>
    </div>
</div>
