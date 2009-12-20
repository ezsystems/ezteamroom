{def $settings = $handler.settings}
<div class="block">
 <fieldset>
  <legend>
   <input type="checkbox" name="ReceiveDigest_{$handler.id_string}" {$settings.receive_digest|choose( '', checked)} /> {'Receive all messages combined in one digest'|i18n( 'ezteamroom/collaboration' )}
  </legend>
  <table cellspacing="4">
   <tr>
    <td>
     <input type="radio" name="DigestType_{$handler.id_string}" value="3" {eq($settings.digest_type,3)|choose('',checked)} />
    </td>
    <td>

{'Daily, at'|i18n( 'ezteamroom/collaboration' )}

    </td>
    <td>
     <select name="Time_{$handler.id_string}">

{foreach $handler.available_hours as $key => $time}

      <option value="{$time}" {if eq( $time, $settings.time )}selected="selected"{/if}>{$time}</option>

{/foreach}

     </select>
    </td>
   </tr>
   <tr>
    <td>
     <input type="radio" name="DigestType_{$handler.id_string}" value="1" {eq( $settings.digest_type, 1 )|choose( '', checked )} />
    </td>
    <td>

{'Once per week, on '|i18n( 'ezteamroom/collaboration' )}

    </td>
    <td>
     <select name="Weekday_{$handler.id_string}">

{foreach $handler.all_week_days as $key => $weekdays}

      <option value="{$weekdays}" {if eq( $weekdays, $settings.day )}selected="selected"{/if}>{$weekdays}</option>

{/foreach}

     </select>
    </td>
   </tr>
   <tr>
    <td>
     <input type="radio" name="DigestType_{$handler.id_string}" value="2" {eq( $settings.digest_type, 2)|choose( '', checked )} />
    </td>
    <td>

{'Once per month, on day number'|i18n( 'ezteamroom/collaboration' )}

    </td>
    <td>
     <select name="Monthday_{$handler.id_string}">

{foreach $handler.all_month_days as $key => $monthdays}

      <option value="{$monthdays}" {if eq( $monthdays, $settings.day )}selected="selected"{/if}>{$monthdays}</option>

{/foreach}

     </select>
    </td>
   </tr>
  </table>

{'If day number is larger than the number of days within the current month, the last day of the current month will be used.'|i18n( 'ezteamroom/collaboration' )}

 </fieldset>
</div>

