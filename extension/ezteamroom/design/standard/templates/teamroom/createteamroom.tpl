{set $availible_feature_list = hash( 'tasks',       hash( 'title', 'Tasks'|i18n('ezteamroom/creation'),         'default', true()  ),
                                     'milestones',  hash( 'title', 'Milestones'|i18n('ezteamroom/creation'),    'default', true()  ),
                                     'files',       hash( 'title', 'Files'|i18n('ezteamroom/creation'),         'default', true()  ),
                                     'forum',       hash( 'title', 'Message Board'|i18n('ezteamroom/creation'), 'default', false() ),
                                     'blog',        hash( 'title', 'Blog'|i18n('ezteamroom/creation'),          'default', true()  ),
                                     'calendar',    hash( 'title', 'Calendar'|i18n('ezteamroom/creation'),      'default', true()  ),
                                     'wiki',        hash( 'title', 'Wiki'|i18n('ezteamroom/creation'),          'default', true()  ) )
                   $tpl_info = hash( 'main_node_id', hash( 'info',     'Node ID of the teamroom'|i18n('ezteamroom/creation'),
                                                           'type',     'integer'
                                                         ),
                                     'install_features', hash( 'info',     'Which features should be installed'|i18n('ezteamroom/creation'),
                                                               'type',     'array',
                                                               'default',  array( 'tasks', 'milestones', 'files', 'forum', 'blog', 'calendar', 'wiki' )
                                                             ),
                                     'owner_object_id',  hash( 'info',     'ObjectID of the teamroom owner'|i18n('ezteamroom/creation'),
                                                               'type',     'integer'
                                                             )
                                   )}
{def      $publicSectionID = ezini( 'TeamroomSettings', 'PublicSectionID', 'teamroom.ini' )
     $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}
{set-block variable='xml_data'}
<eZXMLImporter>
    <ProccessInformation comment="Create teamroom content" />
    <CreateContent parentNode="{$main_node_id}">
        <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="user_group" section="{$publicSectionID}" remoteID="{$main_node_id}_team_member">
            <Attributes>
                <name>{'Team member'|i18n('ezteamroom/creation')}</name>
                <description>{'The following users are currently members of this teamroom. You can get detailed information about a user within his profile and send an email to each of the users. Using the link in the menu on the right you can invite new users to the teamroom. If you have the required rights you can configure the permissions of the teamroom members by using the link in the menu on the right.'|i18n('ezteamroom/creation')}</description>
                <website_toolbar_access>0</website_toolbar_access>
            </Attributes>
            <SetReference attribute="object_id" value="TEAM_MEMBER_GROUP_OBJECT_ID" />
            <SetReference attribute="node_id" value="TEAM_MEMBER_GROUP_NODE_ID" />
            <Childs>
                <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="user_group" section="{$publicSectionID}" remoteID="{$main_node_id}_team_leader">
                    <Attributes>
                        <name>{'Moderators'|i18n('ezteamroom/creation')}</name>
                        <description>{'The following users are currently moderators of this teamroom.'|i18n('ezteamroom/creation')}</description>
                        <website_toolbar_access>0</website_toolbar_access>
                    </Attributes>
                    <SetReference attribute="object_id" value="TEAM_LEADER_GROUP_OBJECT_ID" />
                    <SetReference attribute="node_id" value="TEAM_LEADER_GROUP_NODE_ID" />
                </ContentObject>
            </Childs>
        </ContentObject>
        <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['task_list']}" section="{$publicSectionID}" remoteID="{$main_node_id}_tasks">
            <Attributes>
                <name>{'Tasks'|i18n('ezteamroom/creation')}</name>
                <description>
                 {'The following list gives an overview over the teamroom related tasks and their status. To create a new task use the "Add new task button". A click on the info icon of an existing task will show more detailed information about it. A click on the progress meter will change the current progress of the task. Use the edit icon to edit the details of a task and the trash icon to delete it. Using the link shown below "Filter" will toggle between two modes: one mode shows the finished tasks and one mode shows the unfinished tasks. The links shown below "Sort by" can be used to sort the task in different orders. By clicking on the same link two times, the sorting order will be reverted. A click on one of the keywords shown below "Keywords" will filter the displayed tasks and show only those having the selected keyword.'|i18n('ezteamroom/creation')}
                </description>
            </Attributes>
            <SetReference attribute="object_id" value="TASK_LIST_OBJECT_ID" />
            <SetReference attribute="node_id" value="TASK_LIST_NODE_ID" />
        </ContentObject>
        <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['file_folder']}" section="{$publicSectionID}" remoteID="{$main_node_id}_files">
            <Attributes>
                <name>{'Files'|i18n('ezteamroom/creation')}</name>
                <short_name>{'Files'|i18n('ezteamroom/creation')}</short_name>
                <description>
                 {'The following list shows the files related to this teamroom. To upload single files the button "Upload new file" can be used. Furthermore it is possible to upload multiple files at the same time by using the "Multi upload" button. For uploading multiple files at the same time it is required to use the "Ctrl" key when selecting the files. To add an existing lightbox to the list of files the button "Add lightbox" can be used. The links shown below "Sort by" can be used to sort the files in different orders. By clicking on the same link two times, the sorting order will be reverted. The links shown below "Categories" can be used to filter the list of shown files by the categories they belong to. A click on one of the keywords shown below "Keywords" will filter the displayed tasks and show only those having the selected keyword.'|i18n('ezteamroom/creation')}
                </description>
                <tags></tags>
            </Attributes>
            <SetReference attribute="object_id" value="FILE_LIST_OBJECT_ID" />
            <SetReference attribute="node_id" value="FILE_LIST_NODE_ID" />
        </ContentObject>
        <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['milestone_folder']}" section="{$publicSectionID}" remoteID="{$main_node_id}_milestones">
            <Attributes>
                <name>{'Milestones'|i18n('ezteamroom/creation')}</name>
                <short_name>{'Milestones'|i18n('ezteamroom/creation')}</short_name>
                <short_description></short_description>
                <description>{'The following list shows the milestones that have been created within this teamroom. A milestone is a collection of tasks and has a date that indicates when the milestone should be reached. You can use the button "New milestone" to create a new milestone. The links shown below "Sort by" can be used to sort the milestones in different orders. By clicking on the same link two times, the sorting order will be reverted. A click on one of the tags shown below "Tags" will filter the displayed milestones and show only those having the selected tag.'|i18n('ezteamroom/creation')}</description>
                <tags></tags>
            </Attributes>
            <SetReference attribute="object_id" value="MILESTONE_LIST_OBJECT_ID" />
            <SetReference attribute="node_id" value="MILESTONE_LIST_NODE_ID" />
        </ContentObject>
        <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['forum']}" section="{$publicSectionID}" remoteID="{$main_node_id}_forum">
            <Attributes>
                <name>{'Message Board'|i18n('ezteamroom/creation')}</name>
                <description>{'This message board can be used for teamroom related discussions. You can add a new post using the button "Add new topic". If you want to read the content of a topic you can click on the title. This will also enable you to reply to that topic.'|i18n('ezteamroom/creation')}</description>
            </Attributes>
            <SetReference attribute="object_id" value="MESSAGE_BOARD_OBJECT_ID" />
            <SetReference attribute="node_id" value="MESSAGE_BOARD_NODE_ID" />
        </ContentObject>
        <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['blog']}" section="{$publicSectionID}" remoteID="{$main_node_id}_blog">
            <Attributes>
                <name>{'Blog'|i18n('ezteamroom/creation')}</name>
                <description>{'This blog can be used to post teamroom related messages in form of a diary. To create a new blog entry you can use the button "Add new entry". If you click on the title of an entry the full article will be shown and you are enabled to write a comment to the article.'|i18n('ezteamroom/creation')}</description>
                <tags></tags>
            </Attributes>
            <SetReference attribute="object_id" value="BLOG_OBJECT_ID" />
            <SetReference attribute="node_id" value="BLOG_NODE_ID" />
        </ContentObject>
        <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['event_calendar']}" section="{$publicSectionID}" remoteID="{$main_node_id}_calendar">
            <Attributes>
                <title>{'Calendar'|i18n('ezteamroom/creation')}</title>
                <short_title>{'Calendar'|i18n('ezteamroom/creation')}</short_title>
                <view>0</view>
            </Attributes>
            <SetReference attribute="object_id" value="EVENT_CALENDAR_OBJECT_ID" />
            <SetReference attribute="node_id" value="EVENT_CALENDAR_NODE_ID" />
        </ContentObject>
        <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['documentation_page']}" section="{$publicSectionID}" remoteID="{$main_node_id}_wiki">
            <Attributes>
                <title>{'Wiki'|i18n('ezteamroom/creation')}</title>
                <body>&lt;header level=&quot;1&quot;&gt;{'Wiki'|i18n('ezteamroom/creation')}&lt;/header&gt;</body>
                <tags></tags>
                <show_children>1</show_children>
            </Attributes>
            <SetReference attribute="object_id" value="WIKI_OBJECT_ID" />
            <SetReference attribute="node_id" value="WIKI_NODE_ID" />
        </ContentObject>
    </CreateContent>
    <ProccessInformation comment="Create teamroom boxes" />
    <CreateContent parentNode="{$main_node_id}">
        <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['boxfolder']}" section="{$publicSectionID}" remoteID="{$main_node_id}_box_folder">
            <Attributes>
                <name>{'Boxes'|i18n('ezteamroom/creation')}</name>
            </Attributes>
            <SetReference attribute="object_id" value="BOX_FOLDER_OBJECT_ID" />
            <Childs>
                <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['infobox']}" section="{$publicSectionID}" remoteID="{$main_node_id}_box_folder_calendar">
                    <Attributes>
                        <header>{'Calendar'|i18n('ezteamroom/creation')}</header>
                        <box_icon>{ezini( "TeamroomIconSettings", "Icon678", "teamroom.ini" )}</box_icon>
                        <content></content>
                        <url></url>
                        <module_url parseReferences="true">ezjscore/run/content/view/module_widget/[internal:EVENT_CALENDAR_NODE_ID]</module_url>
                        <check_access></check_access>
                        <relates_to>internal:EVENT_CALENDAR_OBJECT_ID</relates_to>
                    </Attributes>
                    <SetReference attribute="object_id" value="TEAMROOM_CALENDAR_BOX_OBJECT_ID" />
                    <SetReference attribute="node_id" value="TEAMROOM_CALENDAR_BOX_NODE_ID" />
                </ContentObject>
                <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['infobox']}" section="{$publicSectionID}" remoteID="{$main_node_id}_box_folder_latestfiles">
                    <Attributes>
                        <header>{'Latest Files'|i18n('ezteamroom/creation')}</header>
                        <box_icon>{ezini( "TeamroomIconSettings", "Icon677", "teamroom.ini" )}</box_icon>
                        <content></content>
                        <url></url>
                        <module_url parseReferences="true">ezjscore/run/content/view/module_widget/[internal:FILE_LIST_NODE_ID]</module_url>
                        <check_access></check_access>
                        <relates_to>internal:FILE_LIST_OBJECT_ID</relates_to>
                    </Attributes>
                    <SetReference attribute="object_id" value="LATEST_FILES_BOX_OBJECT_ID" />
                    <SetReference attribute="node_id" value="LATEST_FILES_BOX_NODE_ID" />
                </ContentObject>
                <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['infobox']}" section="{$publicSectionID}" remoteID="{$main_node_id}_box_folder_bookmarks">
                    <Attributes>
                        <header>{'Current Lightbox'|i18n('ezteamroom/creation')}</header>
                        <box_icon>{ezini( "TeamroomIconSettings", "Icon619", "teamroom.ini" )}</box_icon>
                        <content></content>
                        <url></url>
                        <module_url>ezjscore/run/lightbox/view/currentlightbox</module_url>
                        <check_access>lightbox/view</check_access>
                        <relates_to></relates_to>
                    </Attributes>
                    <SetReference attribute="object_id" value="TEAMROOM_LIGHTBOX_BOX_OBJECT_ID" />
                </ContentObject>
                <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['infobox']}" section="{$publicSectionID}" remoteID="{$main_node_id}_box_folder_latest_member">
                    <Attributes>
                        <header>{'Latest Member'|i18n('ezteamroom/creation')}</header>
                        <box_icon>{ezini( "TeamroomIconSettings", "Icon003", "teamroom.ini" )}</box_icon>
                        <content></content>
                        <url></url>
                        <module_url parseReferences="true">ezjscore/run/content/view/module_widget/[internal:TEAM_MEMBER_GROUP_NODE_ID]</module_url>
                        <check_access></check_access>
                        <relates_to></relates_to>
                    </Attributes>
                    <SetReference attribute="object_id" value="LATEST_MEMBER_BOX_OBJECT_ID" />
                    <SetReference attribute="node_id" value="LATEST_MEMBER_BOX_NODE_ID" />
                </ContentObject>
                <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['infobox']}" section="{$publicSectionID}" remoteID="{$main_node_id}_box_folder_lastblog">
                    <Attributes>
                        <header>{'Last Blog Entry'|i18n('ezteamroom/creation')}</header>
                        <box_icon>{ezini( "TeamroomIconSettings", "Icon673", "teamroom.ini" )}</box_icon>
                        <content></content>
                        <url></url>
                        <module_url parseReferences="true">ezjscore/run/content/view/module_widget/[internal:BLOG_NODE_ID]</module_url>
                        <check_access></check_access>
                        <relates_to>internal:BLOG_OBJECT_ID</relates_to>
                    </Attributes>
                    <SetReference attribute="object_id" value="LAST_BLOG_BOX_OBJECT_ID" />
                    <SetReference attribute="node_id" value="LAST_BLOG_BOX_NODE_ID" />
                </ContentObject>
{*
                <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['infobox']}" section="{$publicSectionID}" remoteID="{$main_node_id}_box_folder_help">
                    <Attributes>
                        <header>{'Help'|i18n('ezteamroom/creation')}</header>
                        <box_icon>{ezini( "TeamroomIconSettings", "Icon168", "teamroom.ini" )}</box_icon>
                        <url></url>
                        <module_url></module_url>
                        <check_access></check_access>
                        <relates_to></relates_to>
                    </Attributes>
                    <SetReference attribute="object_id" value="TEAMROOM_HELP_BOX_OBJECT_ID" />
                </ContentObject>
*}
                <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['infobox']}" section="{$publicSectionID}" remoteID="{$main_node_id}_box_folder_manageteamroom">
                    <Attributes>
                        <header>{'This Teamroom'|i18n('ezteamroom/creation')}</header>
                        <box_icon>{ezini( "TeamroomIconSettings", "Icon226", "teamroom.ini" )}</box_icon>
                        <content></content>
                        <url></url>
                        <module_url parseReferences="true">ezjscore/run/content/view/manage/[node_id:{$main_node_id}]</module_url>
                        <check_access>teamroom/manage</check_access>
                        <relates_to></relates_to>
                    </Attributes>
                    <SetReference attribute="object_id" value="MANAGE_TEAMROOM_BOX_OBJECT_ID" />
                </ContentObject>
                <ContentObject owner="{$owner_object_id}" creator="{$owner_object_id}" contentClass="{$class_identifier_map['infobox']}" section="{$publicSectionID}" remoteID="{$main_node_id}_box_folder_teamroomleader">
                    <Attributes>
                        <header>{'Teamroom Moderators'|i18n('ezteamroom/creation')}</header>
                        <box_icon>{ezini( "TeamroomIconSettings", "Icon674", "teamroom.ini" )}</box_icon>
                        <content></content>
                        <url></url>
                        <module_url parseReferences="true">ezjscore/run/content/view/module_widget/[internal:TEAM_LEADER_GROUP_NODE_ID]</module_url>
                        <check_access></check_access>
                        <relates_to></relates_to>
                    </Attributes>
                    <SetReference attribute="object_id" value="TEAMROOM_LEADER_BOX_OBJECT_ID" />
                </ContentObject>
            </Childs>
        </ContentObject>
    </CreateContent>
    <ProccessInformation comment="Setting Teamroom Startpage" />
    <ModifyContent nodeID="{$main_node_id}" creator="{$owner_object_id}"  owner="{$owner_object_id}">
        <Attributes>
            <default_arrangement parseReferences="true">[[[internal:TEAMROOM_LEADER_BOX_OBJECT_ID]],[[internal:MANAGE_TEAMROOM_BOX_OBJECT_ID]],[[internal:TEAMROOM_LIGHTBOX_BOX_OBJECT_ID]],[[internal:LATEST_MEMBER_BOX_OBJECT_ID]]]</default_arrangement>
        </Attributes>
    </ModifyContent>
    <ProccessInformation comment="Add owner to leader group" />
    <AddLocation contentObject="{$owner_object_id}" addToNode="internal:TEAM_LEADER_GROUP_NODE_ID" />
    <ProccessInformation comment="Assigning roles to user groups" />
    <AssignRoles>
        <RoleAssignment roleID="{ezini( "PermissionSettings", "TeamroomLeaderGroupRole", "teamroom.ini" )}"  assignTo="internal:TEAM_LEADER_GROUP_OBJECT_ID" subtreeLimitation="node_id:{$main_node_id}" />
        <RoleAssignment roleID="{ezini( "PermissionSettings", "TeamroomMemberGroupRole", "teamroom.ini" )}"  assignTo="internal:TEAM_MEMBER_GROUP_OBJECT_ID" subtreeLimitation="node_id:{$main_node_id}" />

    {foreach ezini( "PermissionSettings", "TeamroomRoleList", "teamroom.ini" ) as $roleID}

        <RoleAssignment roleID="{$roleID}"  assignTo="{$owner_object_id}" subtreeLimitation="node_id:{$main_node_id}" />

    {/foreach}

    </AssignRoles>
    <ProccessInformation comment="Hide unused features" />

    {if $install_features|contains('tasks')|not}

        <HideUnhide nodeID="internal:TASK_LIST_NODE_ID" action="hide" />

    {/if}

    {if $install_features|contains('milestones')|not}

        <HideUnhide nodeID="internal:MILESTONE_LIST_NODE_ID" action="hide" />

    {/if}

    {if $install_features|contains('files')|not}

        <HideUnhide nodeID="internal:FILE_LIST_NODE_ID" action="hide" />
        <HideUnhide nodeID="internal:LATEST_FILES_BOX_NODE_ID" action="hide" />

    {/if}

    {if $install_features|contains('forum')|not}

        <HideUnhide nodeID="internal:MESSAGE_BOARD_NODE_ID" action="hide" />

    {/if}

    {if $install_features|contains('blog')|not}

        <HideUnhide nodeID="internal:BLOG_NODE_ID" action="hide" />
        <HideUnhide nodeID="internal:LAST_BLOG_BOX_NODE_ID" action="hide" />

    {/if}

    {if $install_features|contains('calendar')|not}

        <HideUnhide nodeID="internal:EVENT_CALENDAR_NODE_ID" action="hide" />
        <HideUnhide nodeID="internal:TEAMROOM_CALENDAR_BOX_NODE_ID" action="hide" />

    {/if}

    {if $install_features|contains('wiki')|not}

        <HideUnhide nodeID="internal:WIKI_NODE_ID" action="hide" />

    {/if}

    <ProccessInformation comment="Sending mail to owner" />

    {if ezini_hasvariable( 'ContentSettings', 'CachedViewPreferences', 'site.ini' )}

        {def $cachedViewPreferences = ezini( 'ContentSettings', 'CachedViewPreferences', 'site.ini' )}

        {if is_set( $cachedViewPreferences['full'] )}

    <ProccessInformation comment="Update settings" />
    <SetSettings>
      <SettingsFile name="site.ini" location="settings/siteaccess/ezteamroom">
        <SettingsBlock name="ContentSettings">
            <CachedViewPreferences>
              <value key="full">{$cachedViewPreferences['full']};personalfrontpage_widgetlist_{$main_node_id}=[[[internal:TEAMROOM_LEADER_BOX_OBJECT_ID]],[[internal:MANAGE_TEAMROOM_BOX_OBJECT_ID]],[[internal:TEAMROOM_LIGHTBOX_BOX_OBJECT_ID]],[[internal:LATEST_MEMBER_BOX_OBJECT_ID]]]</value>
            </CachedViewPreferences>
        </SettingsBlock>
      </SettingsFile>
    </SetSettings>

        {/if}

    {/if}

    <SendMail receiver="{$owner_object_id}" template="teamroom/mail/teamroom_ready.tpl" node="{$main_node_id}" />
</eZXMLImporter>

{/set-block}
