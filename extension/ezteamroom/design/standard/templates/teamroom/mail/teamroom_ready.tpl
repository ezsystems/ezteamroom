{set-block scope=root variable=subject}{"[%sitename] Teamroom created"|i18n("ezteamroom/collaboration",,hash( '%sitename', ezini( "SiteSettings", "SiteURL" ) ))}{/set-block}
{def $site_url = ezini("SiteSettings","SiteURL")
     $access_type = ezini( concat( "VisibilitySettings_", $node.data_map.access_type.content.0 ), "Title", "teamroom.ini" )}

{"Your teamroom '%1' (visibility '%2') has been created successfully."|i18n("ezteamroom/collaboration",,array( $node.name|wash(), $access_type|wash() ))}
{"The following features are enabled in your new teamroom"|i18n("ezteamroom/collaboration")}:


{foreach $node.data_map.feature_list.content.installed_feature_list as $key}{$node.data_map.feature_list.content.availible_feature_list[$key].title|wash()}{delimiter}, {/delimiter}{/foreach}


{"To access the new teamroom you can use the following link"|i18n("ezteamroom/collaboration")}

http://{$site_url}{$node.url_alias|ezurl( 'no' )}

{"If an 'Access denied' message is displayed you are not logged in yet. The following link can be used to login"|i18n("ezteamroom/collaboration")}

http://{$site_url}/user/login

{if $node.data_map.access_type.content.0|ne( 'public' )}

    {'If you want to be notified about new members requesting access to your teamroom you can adjust the notification settings using the following link.'|i18n("ezteamroom/collaboration")}

http://{$site_url}/notification/settings

{/if}

{include uri='design:teamroom/mail_footer.tpl'}
