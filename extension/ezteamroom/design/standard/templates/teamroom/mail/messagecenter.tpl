{set-block scope=root variable=subject}[{ezini( 'SiteSettings', 'SiteURL' )}] {$subject|wash( 'email' )}{/set-block}

{'An email has been send using the teamroom "%1". The message is included below.'|i18n( 'ezteamroom/messagecenter', , array( $teamroom.main_node.name ) )|wash( 'email' )}

---

{$body|wash( 'email' )}

---

{'Use the following link to access the teamroom'|i18n( 'ezteamroom/messagecenter' )|wash( 'email' )}

http://{ezini( 'SiteSettings', 'SiteURL' )}{$teamroom.main_node.url_alias|ezurl( 'no' )}