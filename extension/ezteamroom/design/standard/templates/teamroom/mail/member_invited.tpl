{set-block scope=root variable=subject}{'[%sitename] Teamroom invitation'|i18n('ezteamroom/collaboration',,hash( '%sitename', ezini( 'SiteSettings', 'SiteName' ) ))}{/set-block}

{"A teamroom moderator has invited you to be a member of the teamroom '%1'."|i18n("ezteamroom/collaboration",,array($teamroom.main_node.name|wash() ) )}
{"Use the following link to access the teamroom"|i18n("ezteamroom/collaboration")}

{$teamroom.main_node.url_alias|ezurl( 'no', 'full' )}


{"If you do not want to be a member of this teamroom, you can resign using the following link"|i18n("ezteamroom/collaboration")}

{concat( '/teamroom/resign/', $teamroom.id )|ezurl( 'no', 'full' )}

