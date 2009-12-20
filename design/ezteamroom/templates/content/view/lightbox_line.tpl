<td class="" style="text-align: center;">
  {if $object}
    <h3><a style="font-size:1.1em;color:gray" href={$object.main_node.url_alias|ezurl}>{$object.name|wash()}</a></h3>
  {else}
    <h3 style="white-space: nowrap;">{'Object ID %1 not available'|i18n( 'ezteamroom/lightbox', , array( $object_id ) )}</h3>
  {/if}
</td>
<td class="tight nowrap" style="vertical-align: top;">
  <p style="padding-top: 0.6em;">{cond( $object, $object.published|l10n( 'date' ) )}</p>
</td>
