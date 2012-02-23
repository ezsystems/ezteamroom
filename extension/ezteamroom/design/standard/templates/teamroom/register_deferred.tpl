<div class="teamroom-register-deferred">
<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="box_background">
<h1>{"Teamroom \"%name\" - Request for membership"|i18n("ezteamroom/membership", '', hash("%name", $teamroom.name|wash()))}</h1>

<div id="message_infocontent">
    <div class="message-icon float-left">
        <img src={'icons/icon_ok.jpg'|ezimage()} alt="" />
    </div>
    <div class="message-textcontent float-left">
        <div class="message-infoline-border">
            <div class="message-infoline">

<div class="message-feedback">
<p>{"Your request for membership has been succesfully submitted and is now waiting for approval. You will receive status updates by e-mail."|i18n("ezteamroom/membership")}</p>
</div>

            </div>
        </div>
    </div>
    <div class="float-break"></div>
    <form action={'/'|ezurl()} method="post">
    <input type="submit" name="ContinueButton" value="{'Ok'|i18n( 'ezteamroom/membership' )}"
           title="{'Use this button to go back.'|i18n( 'ezteamroom/membership' )}" class="button" />
    </form>
</div>
</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
</div>
