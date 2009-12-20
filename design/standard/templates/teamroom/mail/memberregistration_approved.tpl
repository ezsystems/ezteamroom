{set-block scope=root variable=subject}{"[%sitename] Teamroom memberregistration approved"|i18n("ezteamroom/collaboration",,hash( '%sitename', ezini( "SiteSettings", "SiteName" ) ))}{/set-block}

{if $teamroom.data_map.access_type.content.0|eq( 'public' )}
{"You have successfully joined the teamroom '%1'."|i18n( "ezteamroom/collaboration", ,array( $teamroom.name|wash() ) )}
{else}
{"Your memberregistration in the teamroom '%1' has been approved by a teamroom moderator."|i18n( "ezteamroom/collaboration",,array( $teamroom.name|wash() ) )}
{/if}

{"Use the following link to access the teamroom"|i18n("ezteamroom/collaboration")}

{$teamroom.main_node.url_alias|ezurl( 'no', 'full' )}

{'If do not want to be a member of this teamroom anymore you can use the following link to resign from the teamroom.'|i18n("ezteamroom/collaboration")}

http://{ezini( "SiteSettings", "SiteURL" )}/teamroom/resign/{$teamroom.main_node.node_id}

{include uri='design:teamroom/mail_footer.tpl'}
