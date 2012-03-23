{set-block scope=root variable=subject}{'[%sitename] Member has resigned from teamroom'|i18n('ezteamroom/collaboration',,hash( '%sitename', ezini( 'SiteSettings', 'SiteName' ) ) )}{/set-block}


{'The member "%1" has resigned from the teamroom "%2".'|i18n('ezteamroom/collaboration',,array( $member.contentobject.name|wash(), $teamroom.name|wash() ) )}

{*include uri='design:teamroom/mail_footer.tpl'*}
