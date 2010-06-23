<div class="box_background page-invite float-break">

    <div class="attribute-header">
        <h1>{"Invite member"|i18n("ezteamroom/membership")}</h1>
    </div>

{if $errors|count()}
    <div class="message-error">
        {foreach $errors as $error}<p>{$error|wash()}</p>{/foreach}
    </div>
{/if}
{if $messages|count()}
    <div class="message-feedback">
        {foreach $messages as $message}<p>{$message|wash()}</p>{/foreach}
    </div>
{/if}

    <form action={$from_page|ezurl} method="post" name="teamroom_invite_users">
    <div class="invite">
        <div class="search-users">
            <h3>{"Invite a user"|i18n("ezteamroom/membership")}:</h3>
            <p>{"Enter a valid email address. It is also possible to enter a comma separated list of email addresses. If there does not exist a user with one of the given email addresses in the system yet, new user accounts will be generated for them automatically."|i18n( "ezteamroom/membership" )}</p>
            <input type="text"  name="MailAddressList"  value="" class="input" />
            <input type="submit" name="SearchMailButton" value="{'Search user'|i18n('ezteamroom/membership')}" class="defaultbutton" title="{'Search for existing users or invite new users according to their email addresses'|i18n('ezteamroom/membership')}" />
        </div>
        <div class="browse-users">
            <h3>{"Browse users"|i18n("ezteamroom/membership")}:</h3>
            <p>{"Select an existing user by browsing through all registered users."|i18n("ezteamroom/membership")}</p>
            <input type="submit" name="BrowseUsersButton" value="{'Browse users'|i18n('ezteamroom/membership')}" class="defaultbutton" title="{'Browse through user groups to find user that already have a user account'|i18n('ezteamroom/membership')}" />
        </div>
    </div>

    <div class="select-user">
        <h3>{"Selected Users:"|i18n("ezteamroom/membership")}</h3>
        {if $inviteUserList|count()}
        <ul>
         <li><img onclick="ezteamroom_toggleCheckboxes( document.teamroom_invite_users, 'SelectedExistingUsers', false ); return false;" title="{'Invert selection'|i18n( 'ezteamroom/teamroom' )}" alt="toggle_button" src={"toggle-button-16x16.gif"|ezimage()} /></li>
            {def $user = false()}
            {foreach $inviteUserList as $userId}
                {set $user = fetch( 'content', 'object', hash( 'object_id', $userId ) )}
                <li class="selected-user-list"><input type="checkbox" name="SelectedExistingUsers[]" value="{$userId}" />
                    <a href={$user.main_node.url_alias|ezurl()}>{$user.name|wash()}</a>
                    (<a href="mailto:{$user.data_map.user_account.content.email}">{$user.data_map.user_account.content.email|wash()}</a>)
                </li>
            {/foreach}
            {undef $user}
        </ul>
            {if $inviteUserListString}   <input type="hidden" name="inviteUserList" value="{$inviteUserListString}" />{/if}
        {/if}
        {if $createUserList|count()}
        <h3>{"Create new account for:"|i18n("ezteamroom/membership")}</h3>
        <ul>
            {def $user = false()}
            {foreach $createUserList as $user_mail}
                <li class="selected-user-list">
                    <a href="mailto:{$user_mail|wash()}">{$user_mail|wash()}</a>
                </li>
            {/foreach}
        </ul>
            {if $createUserListString}   <input type="hidden" name="createUserList" value="{$createUserListString}" />{/if}
        <br />
        {/if}
        <input type="submit" name="InviteButton" value="{'Send invitation'|i18n('ezteamroom/membership')}" class="defaultbutton" title="{'Automatically create user accounts for new users and send an invitation email to all users displayed in the list above'|i18n( 'ezteamroom/membership' )}" />
        <input type="submit" name="ClearInviteListButton" value="{'Remove'|i18n('ezteamroom/membership')}" class="defaultbutton" title="{'Remove the selected users from the invitation list displayed above'|i18n( 'ezteamroom/membership' )}" />
        <br /><br />
        <div >
            {if ezhttp_hasvariable( 'RedirectIfDiscarded', 'session' )}
                <input type="hidden" name="RedirectIfDiscarded" value="{ezhttp( 'RedirectIfDiscarded', 'session' )}" />
            {/if}
            {if ezhttp_hasvariable( 'RedirectURIAfterPublish', 'session' )}
                <input type="hidden" name="RedirectURIAfterPublish" value="{ezhttp( 'RedirectURIAfterPublish', 'session' )}" />
            {/if}
            <input type="submit" name="CancelButton" value="{'Back'|i18n('ezteamroom/membership')}" class="defaultbutton"  />
        </div>

    </div>

    </form>

</div>
