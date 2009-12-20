{def $subscribed_nodes = $handler.rules
     $tmpDivID = ''}

<fieldset>
 <legend>{'Item notifications'|i18n( 'ezteamroom/collaboration' )}</legend>

{if $subscribed_nodes|count()|gt( 0 )}

 <table class="list" width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
   <th class="tight">&nbsp;</th>
   <th>

    {"Name"|i18n( 'ezteamroom/collaboration' )}

   </th>
   <th>

    {"Class"|i18n( 'ezteamroom/collaboration' )}

   </th>
  </tr>

    {foreach $subscribed_nodes as $node sequence array( bgdark, bglight ) as $bg}

        {set $tmpDivID = concat( 'node_info_', $node.node.node_id )}

  <tr class="{$bg}">
   <td>
    <input type="checkbox" name="SelectedRuleIDArray_{$handler.id_string}[]" value="{$node.id}" />
   </td>
   <td>
    <a href={concat( "/content/view/full/", $node.node.node_id, "/" )|ezurl()} onmouseover="document.getElementById( '{$tmpDivID}' ).style.display = 'block';" onmouseout="document.getElementById( '{$tmpDivID}' ).style.display = 'none';">{$node.node.name|wash()}</a>
    <div id="{$tmpDivID}" style="display:none;">{$node.node.path_with_names|explode( '/' )|implode( ' / ' )}</div>
   </td>
   <td>

        {$node.node.object.content_class.name|wash()}

   </td>
  </tr>

    {/foreach}

 </table>

{else}

    {'You have not subscribed to receive notifications about any items.'|i18n( 'ezteamroom/notification' )}

{/if}

<div class="buttonblock">

{if $subscribed_nodes|count()|gt( 0 )}

 <input class="button" type="submit" name="RemoveRule_{$handler.id_string}" value="{'Remove items'|i18n( 'ezteamroom/notification' )}" title="{'Remove selected items from your personal notification list.'|i18n( 'ezteamroom/notification' )}" />

{/if}

 <input class="button" type="submit" name="NewRule_{$handler.id_string}" value="{'Add items'|i18n( 'ezteamroom/notification' )}" title="{'Add items to your personal notification list.'|i18n( 'ezteamroom/notification' )}" />
</div>

</fieldset>

