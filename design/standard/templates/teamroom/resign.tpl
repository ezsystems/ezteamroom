<div class="border-box">
 <div class="border-tl">
  <div class="border-tr">
   <div class="border-tc"></div>
  </div>
 </div>
 <div class="border-ml">
  <div class="border-mr">
   <div class="border-mc float-break">
    <div class="box_background">
     <form action={$from_page|ezurl()} method="post">
      <h1>{'Resign from Teamroom \"%name\"'|i18n('ezteamroom/membership', '', hash('%name', $teamroom.name))}</h1>
      <p>{'Do you really want to cancel your membership of this teamroom?'|i18n('ezteamroom/membership')}</p>
      <input class="defaultbutton" type="submit" name="ResignButton" value="{'Yes'|i18n('ezteamroom/membership')}" />
      <input class="button" type="submit" name="CancelButton" value="{'No'|i18n('ezteamroom/membership')}" />
     </form>
    </div>
   </div>
  </div>
 </div>
 <div class="border-bl">
  <div class="border-br">
   <div class="border-bc"></div>
  </div>
 </div>
</div>
