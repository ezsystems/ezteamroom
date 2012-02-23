{def $icon_size='normal'
     $attribute = $node.data_map.file
     $icon_title=$attribute.content.mime_type}
<span class="listitem_file">
    {* <span class="icon">{$attribute.content.mime_type|mimetype_icon( $icon_size )}</span> *}
    <span class="name"><strong>{$attribute.content.original_filename|wash()|shorten(20)}</strong> ({$attribute.content.filesize|si( byte )})</span>
    {*<br />
    <span class="date">{$node.object.published|l10n('shortdate')}</span>|
    <span class="owner"><strong>{'Owner'|i18n('ezteamroom/design')}</strong>&nbsp;{$node.object.owner.name|wash()|shorten(10)}</span>
    *}
</span>
