{set-block scope=root variable=subject}{'[%sitename] Teamroom membership terminated'|i18n('ezteamroom/collaboration',,hash( '%sitename', ezini( 'SiteSettings', 'SiteName' ) ))}{/set-block}

{"Your membership of the teamroom '%1' has been terminated by a teamroom moderator."|i18n("ezteamroom/collaboration",,array( $teamroom.name|wash() ) )}

{"If you are thinking this was done by a mistake, please get in contact with the owner '%1' of the teamroom."|i18n("ezteamroom/collaboration",,array( $owner.contentobject.name|wash() ) )}

{include uri='design:teamroom/mail_footer.tpl'}
