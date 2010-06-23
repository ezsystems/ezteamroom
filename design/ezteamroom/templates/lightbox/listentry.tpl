{if $use_table}
<table style="width: 100%;">
{/if}

 <tr class="{$bg}">

  {if $content_object}
  {content_view_gui content_object = $content_object
                              view = lightbox_line
                         use_table = $use_table
                                bg = $bg
                    can_use_basket = $can_use_basket
                      lightboxList = $userLightboxList
                          lightbox = $selectedLightbox}
  {else}
    <td></td>
    <td><p>{"Content Object has been deleted."|i18n( 'ezteamroom/lightbox' )}</p></td>
  {/if}
  <td style="background-color: rgb( 255, 255, 255 ); padding-top: 0.5em;">
   <form action={'/content/action'|ezurl()} method="post">
    <input type="hidden" name="ContentObjectID" value="0" />
    <input type="hidden" name="ItemID" value="{$item_id}" />
    <input type="hidden" name="ItemType" value="{$item_type}" />
    <input type="hidden" name="ContentNodeID"   value="{cond( $object, $object.main_node.node_id )}" />

{if $lightbox.can_edit}

    {* Remove from lightbox *}
    <input type="image" src={'lightbox/action_lightbox_delete_medium.png'|ezimage()} title="{'Use this button to delete the asset from this lightbox'|i18n( 'ezteamroom/lightbox' )}" name="RemoveFromLightboxAction" alt="{'Remove'|i18n( 'ezteamroom/lightbox' )}" onclick="return confirm( '{'Are you sure you want to remove this entry?'|i18n( 'ezteamroom/lightbox' )}' )" />
    <input type="hidden" name="redirectAfterSelectionURI" value="{concat( "lightbox/view/list/", $lightbox.id )}" />

    {* Move from one lightbox to another *}
    {if and( $object, is_array( $lightboxList ), $lightboxList|count()|gt( 1 ) )}
    <input type="hidden" name="LightboxID" value="{$lightbox.id}" />
    <input type="image" src={'lightbox/action_lightbox_move_medium.png'|ezimage()} alt="{'Move'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to move the asset from this lightbox to the selected one'|i18n( 'ezteamroom/lightbox' )}" name="MoveToLightboxAction" style="padding-right: 0.5em;" />
    <select name="MoveToLightboxID">
    {foreach $lightboxList as $moveLightbox}
        {if $moveLightbox.id|ne( $lightbox.id )}
        <option value="{$moveLightbox.id}">{$moveLightbox.name|wash()}</option>
        {/if}
    {/foreach}
    </select>
    {/if}

{/if}

   </form>
  </td>
 </tr>

{if $use_table}
</table>
{/if}

