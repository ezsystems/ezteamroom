<div class="box_background">

    <div class="attribute-header">
        <h1>{'Teamroom policy management'|i18n('ezteamroom/teamroom')}</h1>
    </div>

    {if $messages|count()}
        <div class="message-feedback">
            {foreach $messages as $message}<p>{$message|wash()}</p>{/foreach}
        </div>
    {/if}
    {if $errors|count()}
        <div class="message-error">
            {foreach $errors as $error}<p>{$error|wash()}</p>{/foreach}
        </div>
    {/if}

<form action={$from_page|ezurl()} method="post" name="teamroom_manageusers">
    <table class="list rolemanagement">
    <thead>
        <tr>
            <th width="10px">{'Group'|i18n('ezteamroom/teamroom')|texttoimage( 'rotated' )}</th>
            <th colspan="4">{'User'|i18n('ezteamroom/teamroom')|texttoimage( 'rotated' )}</th>
            {foreach $roleList as $role}
                <th width="10px">{$role.name|texttoimage( 'rotated' )}</th>
            {/foreach}
        </tr>
    </thead>
    <tbody>
        {foreach $userList as $group}
            <tr class="bggroup">
                <td colspan="{$roleList|count()|inc()|inc()|inc()|inc()|inc()}"><strong>{$group.name|wash()}</strong></td>
            </tr>
            {foreach $group.user as $user sequence array( 'bgdark', 'bglight' ) as $style}
                <tr class="{$style}">
                    <td>
                        <input type="checkbox" name="RemoveUser[]" value="{$user.node_id}"{if $teamroom.object.owner.id|eq($user.contentobject_id)} disabled="disabled"{/if} />
                    </td>

                    {def $userContentObjectId = $user.contentobject_id 
                         $thisUserRoleList   = $userRoleList[$userContentObjectId]}
                    <td>
                        {$user.name|wash()}
                    </td>
                    <td>
                        {if $user.data_map.user_account.content.is_enabled|not()}
                            <input type="image" name="RememberInviteButton[{$user.contentobject_id}]" 
                                                title="{'Send the invitation email to "%1" again'|i18n( 'ezteamroom/membership', , array( $user.name|wash() ) )}" 
                                                src={"mail-16x16.gif"|ezimage}/>
                        {/if}
                    </td>
                    <td width="15px">
                        {foreach $userList as $moveToGroup}
                            {if $moveToGroup.node_id|ne($group.node_id)}
                                {if $teamroom.object.owner.id|ne($user.contentobject_id)}
                                    <input type="image" name="MoveUser[{$user.node_id}_{$moveToGroup.node_id}]" 
                                                        title="{"Move to group '%1'"|i18n( 'ezteamroom/teamroom',, array( $moveToGroup.name ) )}"
                                                        src={"move.gif"|ezimage}/>
                                {/if}
                            {/if}
                        {/foreach}
                    </td>

                    <td width="15px">
                        <img onclick="ezteamroom_toggleCheckboxes( document.teamroom_manageusers, 'SelectedUserRoleMatrix', {$userContentObjectId} ); return false;" title="{'Invert selection'|i18n( 'ezteamroom/teamroom' )}" alt="toggle_button" src={"toggle-button-16x16.gif"|ezimage()} />
                            <input type="hidden"
                                    value="no"
                                    name="SelectedUserRoleMatrix[]"/>
                    </td>
                    {foreach $roleList as $role}
                        <td>
                            <input {if $thisUserRoleList|contains($role.id)}checked="checked"{/if}
                                    type="checkbox"
                                    value="yes"
                                    name="SelectedUserRoleMatrix[{$userContentObjectId}][{$role.id}]"/>
                            <input type="hidden"
                                    value="{if $thisUserRoleList|contains($role.id)}yes{else}no{/if}"
                                    name="UserRoleMatrix[{$userContentObjectId}][{$role.id}]"/>
                        </td>
                    {/foreach}
                    {undef}
                </tr>
            {/foreach}
        {/foreach}
    </tbody>
    </table>


    <input type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'ezteamroom/teamroom' )}" title="{'Remove selected'|i18n( 'ezteamroom/teamroom' )}" class="defaultbutton" />
    <input type="submit" name="StoreRoleChangesButton" value="{'Store changes'|i18n( 'ezteamroom/teamroom' )}" title="{'Store the changes.'|i18n( 'ezteamroom/teamroom' )}" class="defaultbutton" />
    <input type="submit" name="InviteButton" value="{'Invite new member'|i18n( 'ezteamroom/teamroom' )}" title="{'Invite selected'|i18n( 'ezteamroom/teamroom' )}" class="defaultbutton" />

</form>
</div>
