{def $site_url=ezini('SiteSettings','SiteURL')}
{set-block scope=root variable=subject}{'[%1] Registration info'|i18n('ezteamroom/collaboration',,array( ezini( "SiteSettings", "SiteURL" ), $site_url))}{/set-block}
{'Thank you for registering at %siteurl.'|i18n('ezteamroom/collaboration',,hash('%siteurl',$site_url))|wash( 'email' )}

{'Your account information'|i18n('ezteamroom/collaboration')|wash( 'email' )}
{'Username'|i18n('ezteamroom/collaboration')|wash( 'email' )}: {$user.login|wash( 'email' )}
{'Email'|i18n('ezteamroom/collaboration')|wash( 'email' )}: {$user.email|wash( 'email' )}

{section show=$password}
{'Password'|i18n('ezteamroom/collaboration')}: {$password}
{/section}


{section show=and( is_set( $hash ), $hash )}

{'Click the following URL to confirm your account'|i18n('ezteamroom/collaboration')|wash( 'email' )}
http://{$hostname}{concat( 'user/activate/', $hash, '/', $object.main_node_id )|ezurl(no)}

{/section}


{'Link to user information'|i18n('ezteamroom/collaboration')|wash( 'email' )}:
http://{$hostname}{concat('content/view/full/',$object.main_node_id)|ezurl(no)}

{include uri='design:teamroom/mail_footer.tpl'}
