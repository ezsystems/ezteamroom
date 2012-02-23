{set-block scope=root variable=subject}{'[%sitename] Teamroom invitation'|i18n('ezteamroom/collaboration',,hash( '%sitename', ezini( 'SiteSettings', 'SiteName' ) ))}{/set-block}

{"You have been invited to join the teamroom '%teamroom'."|i18n( 'ezteamroom/membership',,hash('%teamroom', $teamroom.main_node.name ))|wash( 'email' )}
{'Therefore a user account was automatically created. If you do not login within the next two weeks your account will be deleted.'|i18n('ezteamroom/membership')|wash( 'email' )}

-----------------------------------------------------------
{'Account information'|i18n('ezteamroom/membership')|wash( 'email' )}

{'Username'|i18n('ezteamroom/membership')|wash( 'email' )}: {$receiverUserObject.login|wash( 'email' )}
{'Password'|i18n('ezteamroom/membership')|wash( 'email' )}: {$password|wash( 'email' )}
{'Email'|i18n('ezteamroom/membership')|wash( 'email' )}: {$receiverUserObject.email|wash( 'email' )}

{'Click the following URL to confirm your account'|i18n('ezteamroom/membership')|wash( 'email' )}

{concat( 'user/activate/', $hash, '/', $receiverUserObject.contentobject.main_node_id )|ezurl( 'no', 'full' )}

-----------------------------------------------------------

{"Use the following link to access the teamroom"|i18n("ezteamroom/collaboration")|wash( 'email' )}

{$teamroom.main_node.url_alias|ezurl( 'no', 'full' )}


{"If you do not want to be a member of this teamroom, you can resign using the following link"|i18n("ezteamroom/collaboration")|wash( 'email' )}

{concat( '/teamroom/resign/', $teamroom.id )|ezurl( 'no', 'full' )}

