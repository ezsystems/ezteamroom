<div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>

    <form action={concat($module.functions.edit.uri,"/",$userID)|ezurl} method="post" name="Edit">

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

                            <div class="user-edit-profile">

                                <div class="profile-header">
                                  <img src={'user/profile_header_logo.jpg'|ezimage()} alt="header_logo" />
                                </div>

                                <div class="profile-image">
                                    <div>
                                        {attribute_view_gui attribute=$userAccount.contentobject.data_map.image image_class='profile'}
                                    </div>
                                </div>

                                <div class="profile-content">
                                    <div>
                                        <span class="profile-name">
                                            {$userAccount.contentobject.name|wash} ({$userAccount.login|wash})
                                        </span>
                                    </div>

                                    <div class="block box_background">
                                        <label>{"Username"|i18n("ezteamroom/membership")}</label><div class="labelbreak"></div>

                                        <p class="box">{$userAccount.login|wash}</p>
                                    </div>

                                    <div class="block box_background">
                                        <label>{"Email"|i18n("ezteamroom/membership")}</label><div class="labelbreak"></div>
                                        <p class="box">{$userAccount.email|wash(email)}</p>
                                    </div>

                                    <div class="block box_background">
                                        <label>{"Name"|i18n("ezteamroom/membership")}</label><div class="labelbreak"></div>
                                        <p class="box">{$userAccount.contentobject.name|wash}</p>
                                    </div>


                                </div>

                            </div>
                        </div>

                    </div>

                    <div class="right-column-position">
                        <div class="right-column">

{include uri='design:user/edit_menu.tpl'}

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
