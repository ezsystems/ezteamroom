<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="user-success">
<div class="box_background">

{if $verify_user_email}
<div class="attribute-header">
    <h1 class="long">{"User registered"|i18n("ezteamroom/membership")}</h1>
</div>

<div class="feedback">
<p>
{'Your account was successfully created. An email will be sent to the specified address. Follow the instructions in that email to activate your account.'|i18n('ezteamroom/membership')}
</p>
<div class="buttonblock">
<form action={'/'|ezurl()} method="post">
    <input type="submit" name="ContinueButton" value="{'Continue'|i18n( 'ezteamroom/membership' )}"
           title="{'Use this button to go back.'|i18n( 'ezteamroom/membership' )}" class="button" />
</form>
</div>
</div>
{else}
<div class="attribute-header">
    <h1 class="long">{"User registered"|i18n("ezteamroom/membership")}</h1>
</div>

<div class="feedback">
    <h2>{"Your account was successfully created."|i18n("ezteamroom/membership")}</h2>
</div>
{/if}
</div>
</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
