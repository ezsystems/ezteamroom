{def $approval_content=$collaboration_item.content
     $teamroom=fetch('content','object', hash('object_id', $approval_content.teamroom_id))}
{set-block scope=root variable=subject}{'Membership registration for teamroom "%groupname" awaits approval'
                                        |i18n( "ezteamroom/collaboration",,
                                               hash( '%sitename', ezini( "SiteSettings", "SiteName" ),
                                                     '%groupname', $teamroom.main_node.name|wash ) )}{/set-block}
{'You have requested to join the teamroom "%groupname" at %sitename.
Your request is waiting for approval. To view the status of your request or to add a comment, visit the URL below.'
 |i18n( 'ezteamroom/collaboration',,
        hash( '%sitename', ezini( "SiteSettings", "SiteName" ),
              '%groupname', $teamroom.main_node.name|wash ) )}
http://{ezini( "SiteSettings", "SiteURL" )}/collaboration/item/full/{$collaboration_item.id}

{include uri='design:teamroom/mail_footer.tpl'}
