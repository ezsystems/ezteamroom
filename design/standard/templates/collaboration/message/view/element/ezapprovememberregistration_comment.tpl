<tr class="{$sequence}">
  <td style="white-space: nowrap;">
  {if $is_read|not}<b>{/if}{$item.created|l10n(shortdatetime)}{if $is_read|not} [new]</b>{/if}
  </td>
  <td style="white-space: nowrap;" title="{'Show detailed information about %user'|i18n( 'ezteamroom/collaboration', , hash( '%user', $item_link.participant.participant.contentobject.name|wash() ) )}">
    {collaboration_participation_view view=text_linked collaboration_participant=$item_link.participant}
  </td>
  <td>
  {$item.data_text1|wash()}
  </td>
</tr>
