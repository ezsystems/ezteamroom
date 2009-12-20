<div id="logo">
 <a href={"/"|ezurl} title="{ezini('SiteSettings','SiteName')}"><img src={'teamroom/logo.png'|ezimage()} alt="{'Teamroom Logo'|i18n('ezteamroom/teamroom')}" /></a>
</div>
<div id="links">
    <ul class="float-break">

{if $current_user.is_logged_in}

    {def $currentUserName = $current_user.contentobject.name}

            <li><div class="links_li">
                <a id="links_logout_a" href={"/user/logout"|ezurl} title="{'Logout'|i18n('ezteamroom/teamroom')} {$currentUserName|wash()}"></a>
                <div class="link-text">
                    <a href={"/user/logout"|ezurl} title="{'Logout'|i18n('ezteamroom/teamroom')} {$currentUserName|wash()}">{'Logout'|i18n('ezteamroom/teamroom')}</a>
                </div>
            </div></li>
            <li><div class="links_li">
                <a id="links_profile_a" href={concat( "/user/edit/", $current_user.contentobject_id )|ezurl} title="{'My profile'|i18n('ezteamroom/teamroom')} ({$currentUserName|wash()})"></a>
                <div class="link-text">
                    <a href={concat( "/user/edit/", $current_user.contentobject_id )|ezurl} title="{'My profile'|i18n('ezteamroom/teamroom')} ({$currentUserName|wash()})">{'My profile'|i18n('ezteamroom/teamroom')}</a>
                </div>
            </div></li>
            <li><div class="links_li">
                <a id="links_teamrooms_a" href={concat("content/view/teamrooms/",ezini( "TeamroomSettings", "TeamroomPoolNodeID", "teamroom.ini" ))|ezurl} title="{'My Teamrooms'|i18n('ezteamroom/teamroom')} ({$currentUserName|wash()})"></a>
                <div class="link-text">
                    <a href={concat("content/view/teamrooms/",ezini( "TeamroomSettings", "TeamroomPoolNodeID", "teamroom.ini" ))|ezurl} title="{'My Teamrooms'|i18n('ezteamroom/teamroom')} ({$currentUserName|wash()})">{'My Teamrooms'|i18n('ezteamroom/teamroom')}</a>
                </div>
            </div></li>
            <li><div class="links_li">
                <a id="links_sitemap_a" href={concat("/content/view/sitemap/", ezini( 'TeamroomSettings', 'TeamroomPoolNodeID', 'teamroom.ini' ) )|ezurl()} title="{'Sitemap'|i18n('ezteamroom/teamroom')}"></a>
                <div class="link-text">
                    <a href={concat("/content/view/sitemap/", ezini( 'TeamroomSettings', 'TeamroomPoolNodeID', 'teamroom.ini' ) )|ezurl()} title="{'Sitemap'|i18n('ezteamroom/teamroom')}">{'Sitemap'|i18n('ezteamroom/teamroom')}</a>
                </div>
            </div></li>

    {undef $currentUserName}

{else}

            <li><div class="links_li">
                <a id="links_login_a" href={"/user/login"|ezurl} title="{'Login'|i18n('ezteamroom/teamroom')}"></a>
                <div class="link-text">
                    <a href={"/user/login"|ezurl} title="{'Login'|i18n('ezteamroom/teamroom')}">{'Login'|i18n('ezteamroom/teamroom')}</a>
                </div>
            </div></li>
            <li><div class="links_li">
                <a id="links_register_a" href={"/user/register"|ezurl} title="{'Register'|i18n('ezteamroom/teamroom')}"></a>
                <div class="link-text">
                    <a href={"/user/register"|ezurl} title="{'Register'|i18n('ezteamroom/teamroom')}">{'Register'|i18n('ezteamroom/teamroom')}</a>
                </div>
            </div></li>

{/if}

{*

        <li><div class="links_li">

{def $helpuri = ezini( 'TeamroomSettings','HelpURI',  'teamroom.ini' )}

            <a id="links_help_a" href={$helpuri|ezurl()} title="{'Help'|wash()}"></a>
            <div class="link-text">
                <a href={$helpuri|ezurl()} title="{'Help'|wash()}">{"Help"|i18n( 'ezteamroom/teamroom' )}</a>
            </div>

{undef $helpuri}

        </div></li>

*}

    </ul>
</div>
<p class="hide"><a href="#main">#</a></p>

