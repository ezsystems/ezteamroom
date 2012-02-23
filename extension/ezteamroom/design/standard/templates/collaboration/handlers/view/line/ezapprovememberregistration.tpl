{def $group=fetch('content','object',hash('object_id',$item.content.teamroom_id))
     $user=fetch('content','object',hash('object_id',$item.content.user_id))}

<p>

{'%title for "%user" to access "%target"'|i18n( 'ezteamroom/collaboration', , hash( '%title',  $item.title|wash(),
                                                                                    '%user',   concat( '<a href=', $user.main_node.url_alias|ezurl(), ' title="', 'Show detailed information about %user'|i18n( 'ezteamroom/collaboration', , hash( '%user', $user.name|wash() ) ), '">', $user.name|wash(), '</a>' ),
                                                                                    '%target', concat( '<a href=', $group.main_node.url_alias|ezurl(), ' title="', 'Navigate to: %node'|i18n( 'ezteamroom/collaboration', , hash( '%node', $group.main_node.name|wash() ) ), '">', $group.main_node.name|wash(), '</a>' )
                                                                                  )
                                              )}

</p>

{undef $group}