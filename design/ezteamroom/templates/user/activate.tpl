<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="user-activate">
<div class="box_background">

<div class="attribute-header">
    <h1 class="long">{"Activate account"|i18n("ezteamroom/membership")}</h1>
</div>

<p>
{if $account_activated}
    {if $is_pending}
        {'Your email address has been confirmed. An email is send to you. Please follow the link to activate your account.'|i18n('ezteamroom/membership')}
    {else}
        {'Your account is now activated.'|i18n('ezteamroom/membership')}
    {/if}
{elseif $already_active}
    {'Your account is already active.'|i18n('ezteamroom/membership')}
{else}
    {'Sorry, the key submitted was not a valid key. Account was not activated.'|i18n('ezteamroom/membership')}
{/if}
</p>

<div class="buttonblock">
<form action={"/"|ezurl} method="post">
    <input class="button" type="submit" value="{'Back'|i18n( 'ezteamroom/membership' )}" />
</form>
</div>

</div>
</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
