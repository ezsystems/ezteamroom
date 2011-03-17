{set-block scope=root variable=subject}{"[%sitename] Teamroom member registration denied"|i18n("ezteamroom/collaboration",,hash( '%sitename', ezini( "SiteSettings", "SiteName" ) ))}{/set-block}

{"Your member registration in the teamroom '%1' has been denied by a teamroom moderator."|i18n("ezteamroom/collaboration",,array($teamroom.name|wash))}


{include uri='design:teamroom/mail_footer.tpl'}
