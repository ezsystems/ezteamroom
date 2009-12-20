<td class="tight" style="text-align: center;">
{if and( $object.data_map.thumbnail.has_content, is_set( $object.data_map.thumbnail.content.search-thumbnail ) )}
   {def $image = $object.data_map.thumbnail.content.search-thumbnail}
   <a href="/{$object.main_node.url_alias}"><img src={$image.url|ezroot()} width="{$image.width}" height="{$image.height}" alt="{$image.text|wash()}" title="{$image.text|wash()}" /></a>
{else}
    {'No cover available'|i18n( 'ezteamroom/files' )}
{/if}
</td>
<td class="tight nowrap" style="vertical-align: top;">
   <h3>{$object.name|wash()}</h3>
   <p>{xmp_view_gui tag=$object.data_map.xmp.content.ezdc.type view='default'}</p>
   <p>{xmp_view_gui tag=$object.data_map.xmp.content.ezdc.rights view='default'}</p>
   <p style="padding-top: 0.6em;">{$object.published|l10n( 'date' )}</p>
</td>
