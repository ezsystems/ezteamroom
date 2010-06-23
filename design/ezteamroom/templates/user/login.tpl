<div class="box">
<div class="tl"><div class="tr"><div class="br"><div class="bl"><div class="box-content float-break">

<div class="user-login">
<div class="box_background">

<form method="post" action={"/user/login/"|ezurl} name="loginform">

<div class="attribute-header">
    <h1 class="long">{"Login"|i18n("ezteamroom/membership")}</h1>
</div>

{if $User:warning.bad_login}
<div class="warning">
<h2>{"Could not login"|i18n("ezteamroom/membership")}</h2>
<ul>
    <li>{"A valid username and password is required to login."|i18n("ezteamroom/membership")}</li>
</ul>
</div>
{else}

{if $site_access.allowed|not}
<div class="warning">
<h2>{"Access not allowed"|i18n("ezteamroom/membership")}</h2>
<ul>
    <li>{"You are not allowed to access %1."|i18n("ezteamroom/membership",,array($site_access.name))}</li>
</ul>
</div>
{/if}

{/if}

<div class="block">
<label for="id1">{"Username"|i18n("ezteamroom/membership",'User name')}</label>
<input class="halfbox" type="text" size="10" name="Login" id="id1" value="{$User:login|wash}" tabindex="1" />
</div>

<div class="block">
<label for="id2">{"Password"|i18n("ezteamroom/membership")}</label>
<input class="halfbox" type="password" size="10" name="Password" id="id2" value="" tabindex="1" />
<a href={'/user/forgotpassword'|ezurl}>{'Forgot your password?'|i18n( 'ezteamroom/membership' )}</a>
</div>
{if ezini( 'Session', 'RememberMeTimeout' )}
<div class="block">
<input type="checkbox" tabindex="1" name="Cookie" class="checkbox" id="id4" style="display:inline;" />
<label for="id4" style="display:inline; float: none;">{"Remember me"|i18n("ezteamroom/membership")}</label>
</div>
{/if}

<div class="buttonblock">
    <div style="width: 185px; float: left;">&nbsp;</div>
    <div class="emptyButton emptyButton_whitebg">
        <input class="mousePointer emptyButton" type="submit" name="LoginButton" value="{'Login'|i18n('ezteamroom/membership','Button')}" tabindex="1" />
    </div>
    <div class="emptyButton emptyButton_whitebg">
        <input class="mousePointer emptyButton" type="submit" name="RegisterButton" value="{'Sign Up'|i18n('ezteamroom/membership','Button')}" tabindex="2" />
    </div>
</div>

{if $User:redirect_uri}
    <input type="hidden" name="RedirectURI" value="{$User:redirect_uri|wash}" />
{else}
{def $teamroom_pool_id     = ezini( 'TeamroomSettings', 'TeamroomPoolNodeID', 'teamroom.ini' )
     $teamroom_pool_node   = fetch( 'content', 'node', hash( 'node_id', $teamroom_pool_id ) )}
    <input type="hidden" name="RedirectURI" value="/{$teamroom_pool_node.url_alias|wash}" />
{/if}

{if and( is_set( $User:post_data ), is_array( $User:post_data ) )}
  {foreach $User:post_data as $key => $post_data}
     <input name="Last_{$key}" value="{$postData}" type="hidden" /><br/>
  {/foreach}
{/if}

</form>

</div>
</div>

</div></div></div></div></div>
</div>
