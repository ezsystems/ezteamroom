<?php /* #?ini charset="utf-8"?

[DefaultMailServerSettings]
Server[POP3]=your.pop.server.net
Port[POP3]=
Username[POP3]=no@spam.net
Password[POP3]=secret
UseSSL[POP3]=disabled

[TeamroomSettings]
TeamroomPathDepth=3
PrivateSectionID=8
MaxEntryCount=6
FileLockFeature=disabled
LightboxFeature=enabled
# Choose between single or multiple
TaskToUserAssignment=multiple
HelpURI=/help
ClassIdentifiersMap[]
ClassIdentifiersMap[blog]=teamroom_blog
ClassIdentifiersMap[blog_post]=teamroom_blog_post
ClassIdentifiersMap[boxfolder]=teamroom_box_folder
ClassIdentifiersMap[comment]=teamroom_comment
ClassIdentifiersMap[documentation_page]=teamroom_documentation_page
ClassIdentifiersMap[event_calendar]=teamroom_event_calendar
ClassIdentifiersMap[event]=teamroom_event
ClassIdentifiersMap[file_folder]=teamroom_file_folder
ClassIdentifiersMap[file_subfolder]=teamroom_file_subfolder
ClassIdentifiersMap[file]=teamroom_file
ClassIdentifiersMap[forum]=teamroom_forum
ClassIdentifiersMap[forum_topic]=teamroom_forum_topic
ClassIdentifiersMap[forum_reply]=teamroom_forum_reply
ClassIdentifiersMap[frontpage]=teamroom_frontpage
ClassIdentifiersMap[image]=image
ClassIdentifiersMap[infobox]=teamroom_infobox
ClassIdentifiersMap[lightbox]=teamroom_lightbox
ClassIdentifiersMap[milestone_folder]=teamroom_milestone_folder
ClassIdentifiersMap[milestone]=teamroom_milestone
ClassIdentifiersMap[news_folder]=teamroom_news_folder
ClassIdentifiersMap[personal_frontpage]=teamroom_personal_frontpage
ClassIdentifiersMap[task_list]=teamroom_task_list
ClassIdentifiersMap[task]=teamroom_task
ClassIdentifiersMap[teamroom]=teamroom_room
# Not supported yet
#ClassIdentifiersMap[flash]=flash
ClassIdentifiersMap[quicktime]=quicktime
ClassIdentifiersMap[real_video]=real_video
ClassIdentifiersMap[windows_media]=windows_media

# Will be overwritten in settings/override
VisibilityList[]
VisibilityList[]=private
#VisibilityList[]=internal
VisibilityList[]=protected
VisibilityList[]=public

#[VisibilitySettings_<EXAMPLE>]
# Title of the visibility
#Title=Some useful title
# CSS class used to display the icon. A '_active' will be added automatically
# if the teamroom has configured this visibility.
#CSSClass=css_class_name
# The title text of the icon
#IconTitle=A descriptive tool tip title
# ID of the section for the teamroom node
# This can be the numeric id of an existing section or
# 'group_mapping'.
#TeamroomSection=<SECTION_ID>
# ID of the section for the teamroom content
#SubTreeSection=<SECTION_ID>
# If 'group_mapping' is set you can use the SectionGroupMapping setting
# to define the section depending on the group member ship of the current user.
# Usage:
# SectionGroupMapping[<USER_GROUP_OBJECT_ID>]=<SECTION_ID>
# Example:
#SectionGroupMapping[]
# If user in Guest group use Standard section
#SectionGroupMapping[11]=1
# If user in Adminstrator group use Media section
#SectionGroupMapping[12]=3


# Do not change the title of the configuration block
[VisibilitySettings_private]
Title=Private
CSSClass=access_type_private
IconTitle=This teamroom is not visible and accessable
# will be set automatically in settings/override/
#TeamroomSection=8
#SubTreeSection=8

# Do not change the title of the configuration block
[VisibilitySettings_public]
Title=Public
CSSClass=access_type_public
IconTitle=This teamroom is accessable for everybody
# will be set automatically in settings/override/
#TeamroomSection=1
#SubTreeSection=1

# Do not change the title of the configuration block
[VisibilitySettings_internal]
Title=Internal
CSSClass=access_type_internal
IconTitle=This teamroom is only visible for your group
TeamroomSection=8
SubTreeSection=group_mapping
SectionGroupMapping[]

# Do not change the title of the configuration block
[VisibilitySettings_protected]
Title=Protected
CSSClass=access_type_protected
IconTitle=This teamroom is visible for everybody, but not accessable
# will be set automatically in settings/override/
#TeamroomSection=1
#SubTreeSection=8

[MilestoneSettings]
DefaultSortField=date
SortFieldList[]
SortFieldList[]=date
SortFieldList[]=title

[SortField_milestone_date]
SortField=teamroom_milestone/date

[SortField_milestone_title]
SortField=teamroom_milestone/title

[TaskListSettings]
DefaultSortField=priority
SortFieldList[]
SortFieldList[]=priority
SortFieldList[]=name
SortFieldList[]=status
SortFieldList[]=progress
SortFieldList[]=plan
SortFieldList[]=end
SortFieldList[]=type

[SortField_task_priority]
SortField=teamroom_task/priority

[SortField_task_name]
SortField=teamroom_task/title

[SortField_task_status]
SortField=teamroom_task/title

[SortField_task_progress]
SortField=teamroom_task/progress

[SortField_task_plan]
SortField=teamroom_task/planned_end_date

[SortField_task_end]
SortField=teamroom_task/end_date

[SortField_task_type]
SortField=teamroom_task/access_type

[TeamroomlistSettings]
DefaultSortField=name
SortFieldList[]
SortFieldList[]=access_type
SortFieldList[]=name
SortFieldList[]=date

[SortField_access_type]
SortField=teamroom_room/access_type

[SortField_name]
SortField=teamroom_room/name
IsAttribute=true

[SortField_date]
IsAttribute=false
SortField=published

[PermissionSettings]
TeamroomRoleList[]

*/ ?>
