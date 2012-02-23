{set-block scope=root variable=subject}{'[%sitename] Teamroom membership resigned'|i18n('ezteamroom/collaboration',,hash( '%sitename', ezini( 'SiteSettings', 'SiteName' ) ))}{/set-block}


{'You have successfully resigned from the teamroom "%1".'|i18n('ezteamroom/collaboration',,array( $teamroom.name|wash ) )}

{*include uri='design:teamroom/mail_footer.tpl'*}

