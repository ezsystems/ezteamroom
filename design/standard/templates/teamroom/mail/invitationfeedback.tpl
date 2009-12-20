{set-block scope=root variable=subject}{'[%siteurl] Teamroom invitation user account'|i18n('ezteamroom/membership',,hash( '%siteurl', $hostname ))}{/set-block}

{"You have been invited to join the teamroom '%teamroom'."|i18n( 'ezteamroom/membership',,hash('%teamroom', $teamroom.name))|wash( 'email' )}
{'Therefore a user account was automatically created. If you do not login within the next two weeks your account will be deleted.'|i18n('ezteamroom/membership')|wash( 'email' )}

{'Additional text:'|i18n('ezteamroom/membership')|wash( 'email' )}
{$mailtext|wash( 'email' )}

{'Account information'|i18n('ezteamroom/membership')|wash( 'email' )}
{'Username'|i18n('ezteamroom/membership','Login name')|wash( 'email' )}: {$user.login|wash( 'email' )}

{section show=$password}
{'Password'|i18n('ezteamroom/membership')}: {$password|wash( 'email' )}
{/section}

{'Email'|i18n('ezteamroom/membership')}: {$user.email|wash( 'email' )}

{section show=and( is_set( $hash ), $hash )}

{'Click the following URL to confirm your account'|i18n('ezteamroom/membership')|wash( 'email' )}
http://{$hostname}{concat( 'user/activate/', $hash, '/', $object.main_node_id )|ezurl(no)}
{/section}


{'Link to user information'|i18n('ezteamroom/membership')|wash( 'email' )}:
http://{$hostname}{concat('content/view/full/',$object.main_node_id)|ezurl(no)}
