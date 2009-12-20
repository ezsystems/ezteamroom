<div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>

    <div class="border-ml">
      <div class="border-mr">
        <div class="border-mc float-break">

            {def $frontpagestyle='noleftcolumn rightcolumn'}
            <div class="content-view-full">
                <div class="class-user_group {$frontpagestyle}">

                <div class="attribute-header">
                    <h1>{"User profile"|i18n("ezteamroom/membership")}</h1>
                </div>

                <div class="columns-frontpage float-break">
                    <div class="center-column-position">
                        <div class="user-edit">

    <form method="post" action={"/notification/settings/"|ezurl} style="display: inline;">



















<div class="notification-settings">
<div class="box_background">
<div class="maincontentheader">

<h1>{"Notification settings"|i18n('ezteamroom/notification')}</h1>
</div>

{def $handlers = fetch( 'notification','handler_list' )}

{foreach $handlers as $handler}

    {include handler=$handler uri=concat( "design:notification/handler/",$handler.id_string,"/settings/edit.tpl")}

    {delimiter}<br/>{/delimiter}

{/foreach}

<div class="buttonblock">
 <input class="button" type="submit" name="Store" value="{'Store'|i18n('ezteamroom/notification')}" />
</div>
</div>
</div>


















    </form>

                        </div>

                    </div>

                    <div class="right-column-position">
                        <div class="right-column">

{include uri='design:user/edit_menu.tpl' add_form = true()}

                        </div>
                    </div>

              </div>
            </div>
          </div>

        </div>
      </div>
    </div>

    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
