{set-block scope=root variable=subject}{'[%siteurl] New user registered'|i18n('ezteamroom/collaboration',,hash('%siteurl',ezini('SiteSettings','SiteURL')))}{/set-block}
{'A new user has registered.'|i18n('ezteamroom/collaboration')|wash( 'email' )}

{'Account information.'|i18n('ezteamroom/collaboration')|wash( 'email' )}
{'Username'|i18n('ezteamroom/collaboration','Login name')}: {$user.login|wash( 'email' )}
{'Email'|i18n('ezteamroom/collaboration')}: {$user.email|wash( 'email' )}

{'Link to user information'|i18n('ezteamroom/collaboration')|wash( 'email' )}:
http://{$hostname}{concat('content/view/full/',$object.main_node_id)|ezurl(no)}

{include uri='design:teamroom/mail_footer.tpl'}
