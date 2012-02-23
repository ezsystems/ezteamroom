{def $icon_size='normal'
     $attribute = $object.data_map.file
     $icon_title=$attribute.content.mime_type}
<td class="tight lightbox-line-file">
   <a href={concat( $object.main_node.parent.url_alias, '#Node', $object.main_node_id )|ezurl()}>
   {$attribute.content.mime_type|mimetype_icon( $icon_size )}
   </a><br />
   {$attribute.content.mime_type_part|wash()|upcase()|shorten(4,'')} ({$attribute.content.filesize|si( byte )})
</td>
<td class="tight nowrap" style="vertical-align: top;">
   <h3>{$object.name|wash()}</h3>
   <p><strong>{'Filename'|i18n('ezteamroom/files')}</strong>:
        {$attribute.content.original_filename|wash()|shorten(30)}</p>
   <p><strong>{'Owner'|i18n('ezteamroom/files')}</strong>:
        {$object.owner.name|wash()}</p>
   <p style="padding-top: 0.6em;">{$object.published|l10n( 'date' )}</p>
</td>
