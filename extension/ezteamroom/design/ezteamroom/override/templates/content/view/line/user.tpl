<td class="tight lightbox-line-user">
    <a href={$object.main_node.url_alias|ezurl()}>
        {attribute_view_gui attribute=$object.data_map.image image_class='mini'}
    </a>
</td>
<td class="tight nowrap" style="vertical-align: top;">
   <h3>{$object.name|wash()}</h3>
   <p><strong>{'Email'|i18n('ezteamroom/membership')}</strong>:
        {$object.data_map.user_account.content.email|wash()}</p>
   <a href={concat("mailto:",$object.data_map.user_account.content.email)|ezurl()}>{'send message'|i18n('ezteamroom/membership')}</a>
   <p style="padding-top: 0.6em;">{$object.published|l10n( 'date' )}</p>
</td>
