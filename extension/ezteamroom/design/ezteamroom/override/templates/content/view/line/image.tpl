<td class="tight lightbox-line-image">
{if and( $object.data_map.image.has_content, is_set( $object.data_map.image.content.small ) )}
   {def $image = $object.data_map.image.content.small}
   <a href={concat( $object.main_node.parent.url_alias, '#Node', $object.main_node_id )|ezurl()}>
      <img src={$image.url|ezroot()} width="{$image.width}" height="{$image.height}" alt="{$image.text|wash()}" title="{$image.text|wash()}" />
   </a>
{else}
    {'No image available'|i18n( 'ezteamroom/files' )}
{/if}
</td>
<td class="tight nowrap" style="vertical-align: top;">
   <h3>{$object.name|wash()}</h3>
   <p><strong>{'Filename'|i18n('ezteamroom/files')}</strong>:
        {$attribute.content.original_filename|wash()|shorten(30)}</p>
   <p><strong>{'Owner'|i18n('ezteamroom/files')}</strong>:
        {$object.owner.name|wash()}</p>
   <p style="padding-top: 0.6em;">{$object.published|l10n( 'date' )}</p>
</td>
