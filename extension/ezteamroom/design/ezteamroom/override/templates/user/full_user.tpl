<div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>

    <form action={concat($module.functions.edit.uri,"/",$userID)|ezurl} method="post" name="Edit">

    <div class="border-ml">
      <div class="border-mr">
        <div class="border-mc float-break">

            {def $frontpagestyle='noleftcolumn norightcolumn'}
            <div class="content-view-full">
                <div class="class-user_group {$frontpagestyle}">

                <div class="attribute-header">
                    <h1>{"User profile"|i18n("ezteamroom/membership")}</h1>
                </div>

                <div class="columns-frontpage float-break">
                    <div class="center-column-position">

                        <div class="user-edit">

                            <div style="background: url({'user/header_orange_background.jpg'|ezimage(single)}) repeat-x top;position:relative;">

                                <div style="position:absolute;top:0px;right:0px;">
                                  <img src={'user/profile_header_logo.jpg'|ezimage()} alt="header_logo" />
                                </div>

                                <div style="position:absolute;height:263px;width:186px;background: url({'user/profile_photo_background.jpg'|ezimage(single)});">
                                    <div style="padding:24px;">
                                        {attribute_view_gui attribute=$node.data_map.image image_class='profile'}
                                    </div>
                                </div>

                                <div style="padding-left:190px;">
                                    <div style="background: url({'user/header_orange_background.jpg'|ezimage(single)}) repeat-x top; padding-top: 7px;">
                                     <div style="height: 38px;">
                                      <span style="font-size:17px;font-weight:bold;color:#fff;">{$node.name|wash} ({$node.data_map.user_account.content.login|wash})</span>
                                     </div>
                                    </div>

                                    <div class="block box_background">
                                        <label>{"Username"|i18n("ezteamroom/membership")}</label><div class="labelbreak"></div>
                                        <p class="box">{$node.data_map.user_account.content.login|wash}</p>
                                    </div>

                                    <div class="block box_background">
                                        <label>{"Email"|i18n("ezteamroom/membership")}</label><div class="labelbreak"></div>
                                        <p class="box">{$node.data_map.user_account.content.email|wash(email)}</p>
                                    </div>

                                    <div class="block box_background">
                                        <label>{"Name"|i18n("ezteamroom/membership")}</label><div class="labelbreak"></div>
                                        <p class="box">{$node.name|wash}</p>
                                    </div>


                                </div>

                            </div>
                        </div>

                    </div>

              </div>
            </div>
          </div>

        </div>
      </div>
    </div>

    </form>

    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
<br style="clear:both" />
