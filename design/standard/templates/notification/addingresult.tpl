{def $node=fetch( content, node, hash( node_id, $node_id) )}
<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="notification-addtonotification">

<div class="attribute-header">
<h1>
    {'Add to my notifications'|i18n( 'ezteamroom/notification')} nom nom nom
</h1>
</div>

<p>
{if $already_exists}
    {"Notification for node <%node_name> already exists."
    |i18n( 'ezteamroom/notification',,
           hash( '%node_name', $node.name ) )|wash}
{else}
    {"Notification for node <%node_name> was added successfully."
    |i18n( 'ezteamroom/notification',,
           hash( '%node_name', $node.name ) )|wash}
{/if}
</p>

<div class="buttonblock">
<form method="post" action={$redirect_url|ezurl}>
    <input class="button" type="image" src={"buttons/ok_button.jpg"|ezimage()} name="OK" value="{'OK'|i18n('ezteamroom/notification')}" />
</form>
</div>

</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
