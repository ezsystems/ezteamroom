{def $approval_content=$collaboration_item.content
     $teamroom=fetch('content','object', hash('object_id', $approval_content.teamroom_id))
     $author=fetch('content','object', hash('object_id', $approval_content.user_id))}
{set-block scope='root' variable='subject'}{'[%sitename] Membership registration for teamroom "%groupname" waits for approval'
                                        |i18n( "ezteamroom/collaboration",,
                                               hash( '%sitename', ezini( "SiteSettings", "SiteName" ),
                                                     '%groupname', $teamroom.main_node.name|wash ) )}{/set-block}
{'%authorname has requested to join the teamroom "%groupname" at %sitename.
You need to approve or deny this request by using the URL below.'
 |i18n( 'ezteamroom/collaboration',,
        hash( '%sitename', ezini( "SiteSettings", "SiteName" ),
              '%groupname', $teamroom.main_node.name|wash,
              '%authorname', $author.name|wash ) )}
http://{ezini( "SiteSettings", "SiteURL" )}/collaboration/item/full/{$collaboration_item.id}

{include uri='design:teamroom/mail_footer.tpl'}
