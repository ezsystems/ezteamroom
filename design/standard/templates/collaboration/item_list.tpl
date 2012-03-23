<table class="list" width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
  <th colspan="2">{"Subject"|i18n('ezteamroom/collaboration')}</th>
  <th>{"Date"|i18n('ezteamroom/collaboration')}</th>
</tr>
{section name=Item loop=$item_list sequence=array( bglight, bgdark )}
{let item_class="status_read"}
<tr>
  <td class="{$:sequence}" width="1">
    {section show=$:item.user_status.is_active}
      {section show=$:item.user_status.is_read}
      <img src={"collaboration/status_read.png"|ezimage} alt="{'Read'|i18n('ezteamroom/collaboration')}" />
      {section-else}
      {set item_class="status_unread"}
      <img src={"collaboration/status_unread.png"|ezimage} alt="{'Unread'|i18n('ezteamroom/collaboration')}" />
      {/section}
    {section-else}
    {set item_class="status_inactive"}
    <img src={"collaboration/status_inactive.png"|ezimage} alt="{'Inactive'|i18n('ezteamroom/collaboration')}" />
    {/section}
  </td>
  <td class="{$:sequence}">
    {collaboration_view_gui view=line item_class=$:item_class collaboration_item=$:item}
    {section show=and($:item.use_messages,$:item.unread_message_count)}
    <p><b><a href={concat("collaboration/item/full/",$:item.id)|ezurl}>({$:item.unread_message_count})</a></b></p>
    {section-else}
    &nbsp;
    {/section}
    <a href={concat("collaboration/item/full/",$:item.id)|ezurl} title="{'Show detailed information about open task'|i18n( 'ezteamroom/collaboration' )}">{"[more]"|i18n( 'ezteamroom/collaboration' )}</a>
  </td>
  <td class="{$:sequence}" width="1">
    <p style="white-space: nowrap;">{$:item.created|l10n(shortdatetime)}</p>
  </td>
</tr>
{/let}
{/section}
</table>
