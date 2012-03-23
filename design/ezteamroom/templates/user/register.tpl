<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="user-register">

<form enctype="multipart/form-data"  action={"/user/register/"|ezurl} method="post" name="Register">

<div class="attribute-header">

    <h1 class="long">{"Register as a new user"|i18n("ezteamroom/membership")}</h1>
<div>
 {'Please fill in the form to register yourself as a new user. After filling out the form and pushing the "Register" button an email will be sent to the email address submitted in this form. The email will contain a link to verify the validity of the registration request. After clicking on the link in the email your new user account (login and password combination) will be activated. From there on you will be able to make use of the teamrooms.'|i18n( 'ezteamroom/membership' )|wash()}
</div>
</div>

{if and( and( is_set( $checkErrNodeId ), $checkErrNodeId ), eq( $checkErrNodeId, true() ) )}
    <div class="message-error">
        <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {$errMsg|wash()}</h2>
    </div>
{/if}

{if $validation.processed}

    {if $validation.attributes|count|gt(0)}
        <div class="warning">
        <h2>{"Input did not validate"|i18n("ezteamroom/membership")}</h2>
        <ul>
        {foreach $validation.attributes as $attribute}
            <li>{$attribute.name|wash()}: {$attribute.description|wash()}</li>
        {/foreach}
        </ul>
        </div>
    {else}
        <div class="feedback">
        <h2>{"Input was stored successfully"|i18n("ezteamroom/membership")}</h2>
        </div>
    {/if}

{/if}

{if count($content_attributes)|gt(0)}
{foreach $content_attributes as $attribute sequence array( 'bglight', 'bgdark' ) as $sequence}
    <div class="edit-attribute block {$sequence}"
    <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
        <label class="title">{$attribute.contentclass_attribute.name|wash()}</label><div class="labelbreak"></div>
        {attribute_edit_gui attribute=$attribute}
    </div>
    {/foreach}

    <div class="buttonblock">
         <input class="button" type="hidden" name="UserID" value="{$content_attributes[0].contentobject_id}" />

    {if and( is_set( $checkErrNodeId ), $checkErrNodeId )|not()}
        <input class="button" type="submit" name="PublishButton" value="{'Register'|i18n('ezteamroom/membership')}" />
    {else}
        <input class="button" type="submit" name="PublishButton" disabled="disabled" value="{'Register'|i18n('ezteamroom/membership')}" />
    {/if}
    <input class="button" type="submit" name="CancelButton" value="{'Discard'|i18n('ezteamroom/membership')}" />
    </div>
{else}
    <div class="warning">
         <h2>{"Unable to register new user"|i18n("ezteamroom/membership")}</h2>
    </div>
    <input class="button" type="submit" name="CancelButton" value="{'Back'|i18n('ezteamroom/membership')}" />
{/if}
</form>

</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
