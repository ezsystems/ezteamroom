{def $teamroom_pool_id     = ezini( 'TeamroomSettings', 'TeamroomPoolNodeID', 'teamroom.ini' )
     $teamroom_class_id    = ezini( 'TeamroomSettings', 'TeamroomClassID', 'teamroom.ini' )
     $teamroom_pool_node   = fetch( 'content', 'node', hash( 'node_id', $teamroom_pool_id ) )
     $teamroom_pool_object = $teamroom_pool_node.object
     $can_create_team_room = false()
     $current_user         = fetch( 'user', 'current_user' )}

{if $teamroom_pool_object.can_create}
    {foreach $teamroom_pool_object.can_create_class_list as $class}
        {if $class.id|eq($teamroom_class_id)}
            {set $can_create_team_room = true()}
            {break}
        {/if}
    {/foreach}
{/if}
<div class="create_new_teamroom content-view-embed">
    <div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

{if $teamroom_pool_node}
    {attribute_view_gui attribute=$node.data_map.content}

    <div class="create_new_teamroom">
        {if $can_create_team_room}
            <form action={"/content/action"|ezurl()} method="post" name="CreateNewTeamroom">
                <input type="hidden" value="{$teamroom_pool_id}" name="NodeID"/>
                <input type="hidden" value={$teamroom_pool_node.url_alias|ezurl()} name="RedirectURIAfterPublish"/>
                <input type="hidden" value={$teamroom_pool_node.url_alias|ezurl()} name="CancelURI"/>
                <input type="hidden" value="{$teamroom_class_id}" name="ClassID"/>
                <input type="hidden" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" name="ContentLanguageCode"/>
                <input type="hidden" value="Create a new teamroom" name="NewButton"/>
                <div class="infobox-link">
                    <a href="javascript:document.CreateNewTeamroom.submit();" title="{"Create a new teamroom"|i18n("ezteamroom/teamroom")}">{"Create a new teamroom"|i18n("ezteamroom/teamroom")}</a>
                </div>
            </form>
        {else}
            {if $current_user.is_logged_in}
                <p>{"You are not allowed to create new teamrooms."|i18n("ezteamroom/teamroom")}</p>
                <p>{"Please get in contact with the system administrator."|i18n("ezteamroom/teamroom")}</p>
            {else}
                <p>{"You are logged in yet."|i18n("ezteamroom/teamroom")}</p>
                <p><a href={"/user/register"|ezurl} title="{"Please register here"|i18n("ezteamroom/teamroom")}">{"Please register here."|i18n("ezteamroom/teamroom")}</a></p>
                <p><a href={"/user/login"|ezurl} title="{"Login here"|i18n("ezteamroom/teamroom")}">{"Login here."|i18n("ezteamroom/teamroom")}</a></p>
            {/if}
        {/if}
    </div>
{else}
    <div class="warning">
        <h2>{"System misconfiguration"|i18n("ezteamroom/teamroom")}</h2>
        <p>{"The teamroom extension seems to be not configured correctly."|i18n("ezteamroom/teamroom")}</p>
        <p>{"Please get in contact with the system administrator."|i18n("ezteamroom/teamroom")}</p>
    </div>
{/if}

    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>


</div>
