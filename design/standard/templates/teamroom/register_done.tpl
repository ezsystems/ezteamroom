<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="box_background">

{if $teamroom.data_map.access_type.content.0|eq( 'public' )}

    <h1>{"Join teamroom \"%name\""|i18n("ezteamroom/teamroom", '', hash("%name", $teamroom.name))}</h1>

{else}

    <h1>{"Teamroom \"%name\" - Request for membership"|i18n("ezteamroom/membership", '', hash("%name", $teamroom.name|wash()))}</h1>

{/if}

    <div id="message_infocontent">
        <div class="message-icon float-left">
            <img src={'icons/icon_ok.jpg'|ezimage()} alt="" />
        </div>
        <div class="message-textcontent">
            <div class="message-infoline-border">
                <div class="message-infoline">
                 <p>

{if $teamroom.data_map.access_type.content.0|eq( 'public' )}

    {"You have successfully joined the teamroom \"%name\" and are now member of this teamroom."|i18n("ezteamroom/membership", '', hash("%name", $teamroom.name|wash()) )}

{else}

    {"Your membership of the teamroom \"%name\" has been approved. You are now member of this teamroom."|i18n("ezteamroom/membership", '', hash("%name", $teamroom.name|wash()) )}

{/if}

                 </p>
                 <a href={$teamroom.url_alias|ezurl()}>{'To the teamroom'|i18n( "ezteamroom/membership" )}</a>
                </div>
            </div>
        </div>
        <div class="float-break"></div>
    </div>

</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
