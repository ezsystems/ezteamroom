<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="box_background">

<form action={$from_page|ezurl} method="post">

{if $teamroom.data_map.access_type.content.0|eq( 'public' )}

<h1>{"Join teamroom \"%name\""|i18n("ezteamroom/teamroom", '', hash("%name", $teamroom.name))}</h1>

{else}

<h1>{"Teamroom \"%name\" - Request for membership"|i18n("ezteamroom/teamroom", '', hash("%name", $teamroom.name))}</h1>

{/if}

<p>

{if $teamroom.data_map.access_type.content.0|eq( 'public' )}

    {'Are you sure you want to join the teamroom "%name"?'|i18n( "ezteamroom/teamroom", '', hash("%name", $teamroom.name ) )}

{else}

    {'Are you sure you want to request a membership for the teamroom "%name"?'|i18n( "ezteamroom/teamroom", '', hash("%name", $teamroom.name ) )}

{/if}

</p>
<input class="defaultbutton" type="submit" name="RegisterButton" value="{'Yes'|i18n('ezteamroom/teamroom')}" />
<input class="button" type="submit" name="CancelButton" value="{'No'|i18n('ezteamroom/teamroom')}" />
</form>

</div>
</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
