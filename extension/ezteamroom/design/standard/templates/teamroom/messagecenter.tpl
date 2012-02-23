{literal}

<script type="text/javascript" language="javascript">

function eZTeamroomShowHide( tagId, aTagId, showText, hideText )
{
    if ( document.getElementById && document.getElementById( tagId ) && document.getElementById( aTagId ) )
    {
        tagObject = document.getElementById( tagId );
        aObject   = document.getElementById( aTagId );
        if ( tagObject.style.display == 'none' )
        {
            tagObject.style.display = 'block';
            aObject.innerHTML = hideText;
        }
        else
        {
            tagObject.style.display = 'none';
            aObject.innerHTML = showText;
        }
    }
}

function eZTeamroomInvertSelection( groupId )
{
    var spanId    = 'receiver_count_' + groupId;
    var inputName = 'userlist_' + groupId + '[]';
    if ( document.getElementsByName && document.getElementById( spanId ) && document.getElementsByName( spanId, inputName ) )
    {
        var count       = 0;
        var elementList = document.getElementsByName( inputName );
        for ( i = 0; i < elementList.length; ++ i )
        {
            if ( elementList[i].checked )
            {
                elementList[i].checked = false;
            }
            else
            {
                elementList[i].checked = true;
                ++count;
            }
        }
        document.getElementById( spanId ).innerHTML = count;
    }
}

function eZTeamroomUpdateReceiverCount( groupId )
{
    var spanId    = 'receiver_count_' + groupId;
    var inputName = 'userlist_' + groupId + '[]';
    if ( document.getElementById && document.getElementById( spanId ) && document.getElementsByName( inputName ) )
    {
        var count       = 0;
        var elementList = document.getElementsByName( inputName );
        for ( i = 0; i < elementList.length; ++ i )
        {
            if ( elementList[i].checked )
            {
                ++count;
            }
        }
        document.getElementById( spanId ).innerHTML = count;
    }
}

</script>

{/literal}

{def $showText = 'Show'|i18n( 'ezteamroom/messagecenter' )|wash()
     $hideText = 'Hide'|i18n( 'ezteamroom/messagecenter' )|wash()}

<div class="content-view-full">
 <form method="post" action={$url|ezurl()}>
  <fieldset>
   <legend>{'Member list'|i18n( 'ezteamroom/messagecenter' )|wash()} <a href="javascript:eZTeamroomShowHide( 'message-center-memberlist', 'message-center-showhide', '{$showText}', '{$hideText}' );" id="message-center-showhide">{cond( $show_member_list, $hideText, true(), $showText )}</a></legend>
   <div id="message-center-memberlist" style="{cond( $show_member_list, 'display: block; ', true(), 'display: none;' )}">
    <ul style="list-style-type: none;">

{def $itemCount  = 0
     $selectSize = 20
         $offset = 0
      $lastEntry = 0}

{foreach $user_information.userGroupList as $groupNodeID => $groupConfiguration}

    {set $offset    = 0
         $itemCount = $groupConfiguration.user|count()}

    {for 0 to $itemCount|div( $selectSize )|ceil()|dec() as $column}

        {if $offset|eq( 0 )}

     <li style="clear: both;">
      <div style="overflow: hidden;">
       <strong>{$groupConfiguration.name|wash()}</strong> ( <a href="javascript:eZTeamroomInvertSelection( {$groupNodeID} );">{'Invert selection'|i18n( 'ezteamroom/messagecenter' )|wash()}</a>)
      </div>
     </li>
     <li style="float: left; padding: 5px;">

        {else}

     <li style="float: left; padding: 5px;">

        {/if}

        {set $lastEntry = $offset|sum( $selectSize )|dec()}

        {if $lastEntry|gt( $itemCount )}

            {set $lastEntry = $itemCount|dec()}

        {/if}

        {for $offset to $lastEntry as $i}

      <input onchange="eZTeamroomUpdateReceiverCount( {$groupNodeID} );" type="checkbox" name="userlist_{$groupNodeID}[]" value="{$groupConfiguration.user[$i].data_map.user_account.content.email}" class="user_group_{$groupNodeID}" {cond( and( $process_name|eq( 'send' ), $process_id|eq( $groupConfiguration.user[$i].contentobject_id ) ), 'checked="checked"' )} />{$groupConfiguration.user[$i].name|wash()}<br />

        {/for}

     </li>

        {set $offset = $offset|sum( $selectSize )}

    {/for}

{/foreach}

    </ul>
   </div>
  </fieldset>
  <fieldset>
   <legend>{'Message form'|i18n( 'ezteamroom/messagecenter' )|wash()}</legend>
   <div id="message-center-messageform">
    <table style="width: 100%;">
     <tr>
      <td class="tight">
       <strong>{'Receiver'|i18n( 'ezteamroom/messagecenter' )|wash()}</strong>:
      </td>
      <td>

{foreach $user_information.userGroupList as $groupNodeID => $groupConfiguration}

       {$groupConfiguration.name|wash()} ( <span id="receiver_count_{$groupNodeID}">0</span> ){delimiter}, {/delimiter}

{/foreach}

      </td>
     </tr>
     <tr>
      <td class="tight">
       <strong>{'Subject'|i18n( 'ezteamroom/messagecenter' )|wash()}</strong>:
      </td>
      <td>
       <input type="text" name="subject" value="" style="width: 100%;" />
      </td>
     </tr>
     <tr>
      <td class="tight"><strong>{'Body'|i18n( 'ezteamroom/messagecenter' )|wash()}</strong>:</td>
      <td>
       <textarea name="body" style="width: 100%;" rows="30"></textarea>
      </td>
     </tr>
     <tr>
      <td colspan="2" style="padding-top: 0.5em;">
       <input type="submit" name="SendMessageButton" value="{'Send message'|i18n( 'ezteamroom/messagecenter' )|wash()}" class="button" />
       <input type="submit" name="BackButton" value="{'Back'|i18n( 'ezteamroom/messagecenter' )|wash()}" class="button" />
      </td>
     </tr>
    </table>
   </div>
  </fieldset>
 </form>
</div>