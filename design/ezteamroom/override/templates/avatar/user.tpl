<table class="avatar">
 <tr>
  <td class="image centrum">

{attribute_view_gui attribute = $node.data_map.image image_class='mini'}

  </td>
  <td class="info">
   <h3><a href={$node.url_alias|ezurl}>{$node.name|wash()}</a></h3>
   <p>
    <strong>{'Group'|i18n('ezteamroom/membership')}</strong>:

{$node.parent.name|wash()}

   </p>
   <p>
    <strong>{'Email'|i18n('ezteamroom/membership')}</strong>:

{$node.data_map.user_account.content.email|wash()}

   </p>

{def $currentTeamroomUser = fetch( 'user', 'current_user' )}

{if $node.contentobject_id|eq( $currentTeamroomUser.contentobject_id )}

   <p>
    <a href={concat( '/teamroom/resign/', $teamroomobjectid )|ezurl()}>{'Resign from this teamroom'|i18n( 'ezteamroom/teamroom' )}</a>
   </p>

{/if}

{undef $currentTeamroomUser}

  </td>

{if fetch( 'teamroom', 'has_access_to', hash( 'module', 'teamroom', 'function', 'manage', 'subtree', $teamroom_path_string ) )}

    {if and( $node.data_map.user_account.content.is_enabled|not() ,is_set( $teamroomobjectid ), is_numeric( $teamroomobjectid ) )}

    <td class="invite centrum">
    <form action={concat( '/teamroom/manage/', $teamroomobjectid )|ezurl()} method="post" id="{concat( 'invite_submit_form_', $node.data_map.user_account.contentobject_id )}">
        <input type="image" src={"mail.gif"|ezimage} alt="mail_icon"
            name="RememberInviteButton[{$node.contentobject_id}]"
            title="{'Send a remind invitation email to %1'|i18n( 'ezteamroom/membership', , array( $node.name|wash() ) )}" />

        {if is_set( $referrer )}

        <input type="hidden" name="RedirectIfDiscarded"     value="{$referrer}" />
        <input type="hidden" name="RedirectURIAfterPublish" value="{$referrer}" />

        {/if}

    </form>
    <p>
        <a href="#" onclick="document.getElementById( '{concat( 'invite_submit_form_', $node.data_map.user_account.contentobject_id )}' ).submit()">{'Invite again'|i18n( 'ezteamroom/membership' )}</a>
    </p>
    </td>

    {/if}

{/if}

  <td class="mail centrum">
{*if fetch( 'teamroom', 'has_access_to', hash( 'module', 'teamroom', 'function', 'messagecenter', 'subtree', $node.parent.path_string ) )}
   <a href={concat( '/teamroom/messagecenter/', $teamroomobjectid, '/send/', $node.contentobject_id )|ezurl()} title="{'Send an email to %1'|i18n( 'ezteamroom/membership', , array( $node.name|wash() ) )}">
{/if*}
    <a href={concat("mailto:",$node.data_map.user_account.content.email)|ezurl()} title="{'Send an email to %1'|i18n( 'ezteamroom/membership', , array( $node.name|wash() ) )}">
        <img src={"mail.gif"|ezimage} alt="mail_icon" title="{'Send an email to %1'|i18n( 'ezteamroom/membership', , array( $node.name|wash() ) )}" />
    <p>{'send message'|i18n('ezteamroom/membership')}</a></p>
    </a>
  </td>
 </tr>
</table>
