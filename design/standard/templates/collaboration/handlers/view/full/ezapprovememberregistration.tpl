<div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>

    <form name="teamroom_manageusers" method="post" action={"/collaboration/action/"|ezurl}>

    <div class="border-ml">
      <div class="border-mr">
        <div class="border-mc float-break">

            {def $frontpagestyle='noleftcolumn rightcolumn'}
            <div class="content-view-full">
                <div class="class-user_group {$frontpagestyle}">

                <div class="attribute-header">
                    <h1>{"User profile"|i18n("ezteamroom/membership")}</h1>
                </div>

                <div class="columns-frontpage float-break">
                    <div class="center-column-position">
                        <div class="user-edit">

{let $message_limit=2
     $message_offset=0
     $approval_content=$collab_item.content
     $current_participant=fetch("collaboration","participant",hash("item_id",$collab_item.id))
     $participant_list=fetch("collaboration","participant_map",hash("item_id",$collab_item.id))
     $message_list=fetch("collaboration","message_list",hash("item_id",$collab_item.id,"limit",$message_limit,"offset",$message_offset))
     $group=fetch('content','object', hash('object_id', $approval_content.teamroom_id))
     $author=fetch('content','object', hash('object_id', $approval_content.user_id))}

<div class="context-block">

{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">

<h1 class="context-title">{"Memberregistration approval"|i18n('ezteamroom/collaboration')}</h1>

{* DESIGN: Mainline *}<div class="header-mainline"></div>

{* DESIGN: Header END *}</div></div></div></div></div></div>

{* DESIGN: Content START *}<div class="box-ml"><div class="box-mr"><div class="box-content">

<div class="context-attributes">

{switch match=$collab_item.content.approval_status}
{case match=0}

{if $collab_item.is_creator}
{'Your membership request for the teamroom "%groupname" is awaiting approval. You can use the comment text field and the "Add comment" button to provide further information to the owner of the teamroom.'|i18n( 'ezteamroom/collaboration', '', hash( '%groupname', $group.main_node.name|wash() ) )}
{else}
{'The membership request of %authorname for the teamroom "%groupname" requires your approval. You can use the comment text field and the "Add comment" button to provide additional information to %authorname. Use the "Approve" button to grant the membership and the "Deny" button to reject the membership.'|i18n('ezteamroom/collaboration', '', hash( '%authorname', $author.name|wash, '%groupname', $group.main_node.name|wash ))}
{/if}

{/case}
{case match=1}
{if $collab_item.is_creator}
{'Your membership request for the teamroom "%groupname" has been approved. You are now able to access the teamroom. Please keep in mind that it could take some time until the approval is active and you are able to access the teamroom.'|i18n('ezteamroom/collaboration', '', hash( '%groupname', $group.main_node.name|wash() ))}
{else}
{'You have approved the membership request of %authorname for the "%groupname" group.'|i18n('ezteamroom/collaboration', '', hash( '%authorname', $author.name|wash, '%groupname', $group.main_node.name|wash ))}
{/if}
{/case}
{case}
{if $collab_item.is_creator}
{'Your membership request for the teamroom "%groupname" has been denied. Please have a look at the comments on the bottom of this page if the teamroom owner has left a message for you.'|i18n( 'ezteamroom/collaboration', '', hash( '%groupname', $group.main_node.name|wash() ) )}
{else}
{'You have denied the membership request of %authorname for the teamroom "%groupname". Please make sure that you left a message for %authorname so that he is informed about the reason for the rejection.'|i18n('ezteamroom/collaboration', '', hash( '%authorname', $author.name|wash, '%groupname', $group.main_node.name|wash ))}
{/if}
{/case}
{/switch}
</div>

<div class="context-attributes">

{if $approval_content.approval_status|eq(0)}
    <label>{"Comment"|i18n('ezteamroom/collaboration')}:</label>
    <textarea class="box" name="Collaboration_ApproveComment" cols="40" rows="5"></textarea>
{/if}
</div>

{def $defaultRoleIdList=ezini( 'PermissionSettings', 'TeamroomDefaultRoleList', 'teamroom.ini' )}
{def $roleIdList=ezini( 'PermissionSettings', 'TeamroomRoleList', 'teamroom.ini' )}
{if and($roleIdList|count(),$approval_content.approval_status|eq(0))}
<div class="context-attributes">
<table>
    <tr>
    <td colspan="2">
        <img onclick="ezteamroom_toggleCheckboxes( document.teamroom_manageusers, 'Collaboration_SelectedRoleList', false ); return false;" title="Invert selection" alt="Invert selection" src={"toggle-button-16x16.gif"|ezimage} />
        <strong>{'Select permissions for the user'|i18n('ezteamroom/collaboration')}</strong>
    </td></tr>
    <tr>
    {foreach $roleIdList as $key => $role_id}
        {if  and( not( $key|eq(0)), eq($key|mod(2),0 ) )}</tr><tr>{/if}
        {def $role=fetch( 'role', 'role', hash( 'role_id', $role_id ) )}
        {if $role}
            <td>
                <input {if $defaultRoleIdList|contains($role.id)}checked="checked"{/if}
                        type="checkbox"
                        value="yes"
                        name="Collaboration_SelectedRoleList[{$role.id}]"/>
                {str_replace( 'Teamroom ', '', $role.name )|wash()}
            </td>
        {/if}
        {undef $role}
    {/foreach}
    </tr>
    </table>
</div>
{/if}

{* DESIGN: Content END *}</div></div></div>

<div class="controlbar">

{* DESIGN: Control bar START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-tc"><div class="box-bl"><div class="box-br">

<input type="hidden" name="CollaborationActionCustom" value="custom" />
<input type="hidden" name="CollaborationTypeIdentifier" value="ezapprovememberregistration" />

<input type="hidden" name="CollaborationItemID" value="{$collab_item.id}" />


<div class="block">
{if $approval_content.approval_status|eq(0)}

    <input class="button" type="submit" name="CollaborationAction_Comment" value="{'Add comment'|i18n('ezteamroom/collaboration')}" />

    {if $collab_item.is_creator|not}
    <input class="button" type="submit" name="CollaborationAction_Approve" value="{'Approve'|i18n('ezteamroom/collaboration')}" />
    <input class="button" type="submit" name="CollaborationAction_Deny" value="{'Deny'|i18n('ezteamroom/collaboration')}" />
    {/if}
{/if}
</div>

{* DESIGN: Control bar END *}</div></div></div></div></div></div>
</div>

</div>

<div class="context-block">

{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">

<h2 class="context-title">{"User info"|i18n('ezteamroom/collaboration')}</h2>

{* DESIGN: Mainline *}<div class="header-subline"></div>

{* DESIGN: Header END *}</div></div></div></div></div></div>

<div class="box-ml"><div class="box-mr">

<div class="context-information">
    <p class="modified"><strong>{'Registered at'|i18n( 'ezteamroom/collaboration' )}:</strong> {$author.published|l10n(shortdatetime)}</p>
    <div class="break"></div>
</div>

{* DESIGN: Content START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-bl"><div class="box-br"><div class="box-content">

<div class="mainobject-window" title="{'Show detailed information about %user'|i18n( 'ezteamroom/collaboration', , hash( '%user', $author.name|wash() ) )}">
    {content_view_gui view=text_linked content_object=$author}
</div>

</div></div>

{* DESIGN: Content END *}</div></div></div></div></div></div>

</div>


<div class="context-block">

{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">

<h2 class="context-title">{"Participants"|i18n('ezteamroom/collaboration')}</h2>

{* DESIGN: Mainline *}<div class="header-subline"></div>

{* DESIGN: Header END *}</div></div></div></div></div></div>

{* DESIGN: Content START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-bl"><div class="box-br"><div class="box-content">

<div class="block">
 <table class="list" cellspacing="0">
  <tr>
   <th class="tight">{'Role'|i18n( 'ezteamroom/collaboration' )}</th>
   <th>{'User list'|i18n( 'ezteamroom/collaboration' )}</th>
  </tr>

{foreach $participant_list as $role sequence array('bglight','bgdark') as $sequence}
  <tr class="{$sequence}">
   <td style="white-space: nowrap;">{$role.name|wash}</td>
   <td>
{foreach $role.items as $participant}
    <div title="{'Show detailed information about %user'|i18n( 'ezteamroom/collaboration', , hash( '%user', $participant.participant.contentobject.name|wash() ) )}">
    {collaboration_participation_view view=text_linked collaboration_participant=$participant}
    </div>
{/foreach}
   </td>
  </tr>
{/foreach}
 </table>
</div>

{* DESIGN: Content END *}</div></div></div></div></div></div>

</div>

{if $message_list}

<div class="context-block">

{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">

<h2 id="messages" class="context-title">{"Comments"|i18n('ezteamroom/collaboration')}</h2>

{* DESIGN: Mainline *}<div class="header-subline"></div>

{* DESIGN: Header END *}</div></div></div></div></div></div>

{* DESIGN: Content START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-bl"><div class="box-br"><div class="box-content">

  <table class="list" cellspacing="0">
   <tr>
    <th class="tight">{'Date'|i18n('ezteamroom/collaboration')}</th>
    <th class="tight">{'User'|i18n('ezteamroom/collaboration')}</th>
    <th>{'Comment'|i18n('ezteamroom/collaboration')}</th>
   </tr>
  {foreach $message_list as $message_link sequence array('bglight','bgdark') as $sequence}

      {collaboration_simple_message_view view=element sequence=$sequence is_read=$current_participant.last_read|gt($message_link.modified) item_link=$message_link collaboration_message=$message_link.simple_message}

  {/foreach}
  </table>

{* DESIGN: Content END *}</div></div></div></div></div></div>

</div>

{/if}

{/let}

    </form>

                        </div>

                    </div>

                    <div class="right-column-position">
                        <div class="right-column">

{include uri='design:user/edit_menu.tpl' add_form = true()}

                        </div>
                    </div>

              </div>
            </div>
          </div>

        </div>
      </div>
    </div>

    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>

