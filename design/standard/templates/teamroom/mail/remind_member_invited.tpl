{set-block scope=root variable=subject}{'[%sitename] Teamroom invitation reminder'|i18n('ezteamroom/collaboration',,hash( '%sitename', ezini( 'SiteSettings', 'SiteName' ) ))}{/set-block}

{"A teamroom moderator has invited you to be a member of the teamroom '%1'."|i18n("ezteamroom/collaboration",,array($teamroom.main_node.name|wash() ) )}
{"If you do not have a user account yet, you received your account information in a separate email. You will find further information in this email about how to activate your user account to be able to use the teamroom."|i18n("ezteamroom/collaboration")}

-----------------------------------------------------------
{'Account information'|i18n('ezteamroom/membership')|wash( 'email' )}

{'Username'|i18n('ezteamroom/membership')|wash( 'email' )}: {$receiverUserObject.login|wash( 'email' )}
{'Email'|i18n('ezteamroom/membership')|wash( 'email' )}: {$receiverUserObject.email|wash( 'email' )}

{if $hash}
{'Click the following URL to confirm your account'|i18n('ezteamroom/membership')|wash( 'email' )}

{concat( 'user/activate/', $hash, '/', $receiverUserObject.contentobject.main_node_id )|ezurl( 'no', 'full' )}

{/if}

{'If you forgot your password, use the following link to get a new password'|i18n('ezteamroom/membership')|wash( 'email' )}

{'/user/forgotpassword'|ezurl( 'no', 'full' )}

-----------------------------------------------------------

{"Use the following link to access the teamroom"|i18n("ezteamroom/collaboration")}

{$teamroom.main_node.url_alias|ezurl( 'no', 'full' )}


{"If you do not want to be a member of this teamroom, you can resign using the following link"|i18n("ezteamroom/collaboration")}

{concat( '/teamroom/resign/', $teamroom.id, '/', $receiverUserObject.contentobject_id )|ezurl( 'no', 'full' )}
