<?php /* #?ini charset="utf-8"?

[edit_box_icon_infobox]
Source=content/datatype/edit/ezobjectrelation.tpl
MatchFile=attribute/edit/ezobjectrelation.tpl
Subdir=templates
Match[attribute_identifier]=box_icon
Match[class_identifier]=teamroom_infobox

[teamroom_event_cal_line_view]
Source=content/view/cal_line.tpl
MatchFile=cal_line/event.tpl
Subdir=templates/
Match[class_identifier]=teamroom_event

[teamroom_task_cal_line_view]
Source=content/view/cal_line.tpl
MatchFile=cal_line/task.tpl
Subdir=templates/
Match[class_identifier]=teamroom_task

[teamroom_milestone_cal_line_view]
Source=content/view/cal_line.tpl
MatchFile=cal_line/milestone.tpl
Subdir=templates/
Match[class_identifier]=teamroom_milestone

[edit_lightbox]
Source=content/edit.tpl
MatchFile=lightbox/edit_lightbox.tpl
Subdir=templates
Match[class_identifier]=teamroom_lightbox

[edit_task_list]
Source=content/edit.tpl
MatchFile=edit/task_list.tpl
Subdir=templates
Match[class_identifier]=teamroom_task_list

[edit_milestone_folder]
Source=content/edit.tpl
MatchFile=edit/milestone_folder.tpl
Subdir=templates
Match[class_identifier]=teamroom_milestone_folder

[edit_file_folder]
Source=content/edit.tpl
MatchFile=edit/file_folder.tpl
Subdir=templates
Match[class_identifier]=teamroom_file_folder

[full_user]
Source=node/view/full.tpl
MatchFile=user/full_user.tpl
Subdir=templates
Match[class_identifier]=user

[full_image]
Source=node/view/full.tpl
MatchFile=full/image.tpl
Subdir=templates
Match[class_identifier]=image

[full_quicktime]
Source=node/view/full.tpl
MatchFile=full/quicktime.tpl
Subdir=templates
Match[class_identifier]=quicktime

[full_real_video]
Source=node/view/full.tpl
MatchFile=full/real_video.tpl
Subdir=templates
Match[class_identifier]=real_video

[full_windows_media]
Source=node/view/full.tpl
MatchFile=full/windows_media.tpl
Subdir=templates
Match[class_identifier]=windows_media

[edit_user]
Source=content/edit.tpl
MatchFile=edit/user.tpl
Subdir=templates
Match[class_identifier]=user

[content_search]
Source=content/search.tpl
MatchFile=content/search.tpl
Subdir=templates

[edit_access_type_teamroom]
Source=content/datatype/edit/ezselection.tpl
MatchFile=attributes/edit/access_type_teamroom.tpl
Subdir=templates
Match[attribute_identifier]=access_type
Match[class_identifier]=teamroom_room

[view_access_type_teamroom]
Source=content/datatype/view/ezselection.tpl
MatchFile=attributes/view/access_type_teamroom.tpl
Subdir=templates
Match[attribute_identifier]=access_type
Match[class_identifier]=teamroom_room

[edit_access_type_task_users]
Source=content/datatype/edit/ezobjectrelationlist.tpl
MatchFile=attributes/edit/users.tpl
Subdir=templates
Match[attribute_identifier]=users
Match[class_identifier]=teamroom_task

[edit_task_milestone]
Source=content/datatype/edit/ezobjectrelationlist.tpl
MatchFile=attributes/edit/task_milestone.tpl
Subdir=templates
Match[attribute_identifier]=milestone
Match[class_identifier]=teamroom_task

[view_access_type_task_planned_end_date]
Source=content/datatype/view/ezdatetime.tpl
MatchFile=attributes/view/planned_end_date.tpl
Subdir=templates
Match[attribute_identifier]=planned_end_date
Match[class_identifier]=teamroom_task

[related_tasks_milestone]
Source=content/datatype/view/ezobjectrelationlist.tpl
MatchFile=attributes/view/milestone_related_tasks.tpl
Subdir=templates
Match[attribute_identifier]=related_tasks
Match[class_identifier]=teamroom_milestone

[related_files_milestone]
Source=content/datatype/view/ezobjectrelationlist.tpl
MatchFile=attributes/view/milestone_related_files.tpl
Subdir=templates
Match[attribute_identifier]=related_files
Match[class_identifier]=teamroom_milestone


[view_access_type_task_users]
Source=content/datatype/view/ezobjectrelationlist.tpl
MatchFile=attributes/view/users.tpl
Subdir=templates
Match[attribute_identifier]=users
Match[class_identifier]=teamroom_task

[view_task_milestone]
Source=content/datatype/view/ezobjectrelationlist.tpl
MatchFile=attributes/view/task_milestone.tpl
Subdir=templates
Match[attribute_identifier]=milestone
Match[class_identifier]=teamroom_task


[edit_access_type_task_documents]
Source=content/datatype/edit/ezobjectrelationlist.tpl
MatchFile=attributes/edit/documents.tpl
Subdir=templates
Match[attribute_identifier]=documents
Match[class_identifier]=teamroom_task

[view_access_type_task_documents]
Source=content/datatype/view/ezobjectrelationlist.tpl
MatchFile=attributes/view/documents.tpl
Subdir=templates
Match[attribute_identifier]=documents
Match[class_identifier]=teamroom_task

[view_access_type_task_selection]
Source=content/datatype/view/ezselection.tpl
MatchFile=attributes/view/access_type.tpl
Subdir=templates
Match[attribute_identifier]=access_type
Match[class_identifier]=teamroom_task

[view_priority_task_selection]
Source=content/datatype/view/ezinteger.tpl
MatchFile=attributes/view/priority.tpl
Subdir=templates
Match[attribute_identifier]=priority
Match[class_identifier]=teamroom_task

[edit_priority_task_selection]
Source=content/datatype/edit/ezinteger.tpl
MatchFile=attributes/edit/priority.tpl
Subdir=templates
Match[attribute_identifier]=priority
Match[class_identifier]=teamroom_task

[full_milestone_folder]
Source=node/view/full.tpl
MatchFile=full/milestone_folder.tpl
Subdir=templates
Match[class_identifier]=teamroom_milestone_folder

[full_file_folder]
Source=node/view/full.tpl
MatchFile=full/file_folder.tpl
Subdir=templates
Match[class_identifier]=teamroom_file_folder

[full_file_subfolder]
Source=node/view/full.tpl
MatchFile=full/file_folder.tpl
Subdir=templates
Match[class_identifier]=teamroom_file_subfolder

[fileline_folder]
Source=node/view/fileline.tpl
MatchFile=fileline/folder.tpl
Subdir=templates
Match[class_identifier]=teamroom_folder

[fileline_file_subfolder]
Source=node/view/fileline.tpl
MatchFile=fileline/folder.tpl
Subdir=templates
Match[class_identifier]=teamroom_file_subfolder

[fileline_file]
Source=node/view/fileline.tpl
MatchFile=fileline/file.tpl
Subdir=templates
Match[class_identifier]=teamroom_file

[fileline_lightbox]
Source=node/view/fileline.tpl
MatchFile=fileline/lightbox.tpl
Subdir=templates
Match[class_identifier]=teamroom_lightbox

[fileline_image]
Source=node/view/fileline.tpl
MatchFile=fileline/image.tpl
Subdir=templates
Match[class_identifier]=image

[fileline_quicktime]
Source=node/view/fileline.tpl
MatchFile=fileline/quicktime.tpl
Subdir=templates
Match[class_identifier]=quicktime

[fileline_real_video]
Source=node/view/fileline.tpl
MatchFile=fileline/real_video.tpl
Subdir=templates
Match[class_identifier]=real_video

[fileline_windows_media]
Source=node/view/fileline.tpl
MatchFile=fileline/windows_media.tpl
Subdir=templates
Match[class_identifier]=windows_media

[full_teamroom]
Source=node/view/full.tpl
MatchFile=full/teamroom.tpl
Subdir=templates
Match[class_identifier]=teamroom_room

[full_task_list]
Source=node/view/full.tpl
MatchFile=full/task_list.tpl
Subdir=templates
Match[class_identifier]=teamroom_task_list

[table_line_task]
Source=node/view/table_line.tpl
MatchFile=table_line/task.tpl
Subdir=templates
Match[class_identifier]=teamroom_task

[full_user_group]
Source=node/view/full.tpl
MatchFile=full/user_group.tpl
Subdir=templates
Match[class_identifier]=user_group

[avatar_user]
Source=node/view/avatar.tpl
MatchFile=avatar/user.tpl
Subdir=templates
Match[class_identifier]=user

[smallline_task]
Source=content/view/smallline.tpl
MatchFile=smallline/task.tpl
Subdir=templates
Match[class_identifier]=teamroom_task

[node_line_teamroom]
Source=node/view/line.tpl
MatchFile=line/teamroomnode.tpl
Subdir=templates
Match[class_identifier]=teamroom_room

[line_teamroom]
Source=content/view/line.tpl
MatchFile=line/teamroom.tpl
Subdir=templates
Match[class_identifier]=teamroom_room

[listitem_teamroom]
Source=node/view/listitem.tpl
MatchFile=listitem/teamroom.tpl
Subdir=templates
Match[class_identifier]=teamroom_room

[listitem_user]
Source=node/view/listitem.tpl
MatchFile=listitem/user.tpl
Subdir=templates
Match[class_identifier]=user

[listitem_blog_post]
Source=node/view/listitem.tpl
MatchFile=listitem/blog_post.tpl
Subdir=templates
Match[class_identifier]=teamroom_blog_post

[listitem_file]
Source=node/view/listitem.tpl
MatchFile=listitem/file.tpl
Subdir=templates
Match[class_identifier]=teamroom_file

[edit_task]
Source=content/edit.tpl
MatchFile=edit/task.tpl
Subdir=templates
Match[class_identifier]=teamroom_task

[edit_teamroom]
Source=content/edit.tpl
MatchFile=edit/teamroom.tpl
Subdir=templates
Match[class_identifier]=teamroom_room

[module_widget_pagelayout]
Source=pagelayout.tpl
MatchFile=module_widget_pagelayout.tpl
Subdir=templates
Match[viewmode]=module_widget

[manage_pagelayout]
Source=pagelayout.tpl
MatchFile=module_widget_pagelayout.tpl
Subdir=templates
Match[viewmode]=manage

[latestmessages_pagelayout]
Source=pagelayout.tpl
MatchFile=module_widget_pagelayout.tpl
Subdir=templates
Match[viewmode]=latestmessages

[myteamrooms_pagelayout]
Source=pagelayout.tpl
MatchFile=module_widget_pagelayout.tpl
Subdir=templates
Match[viewmode]=myteamrooms

[createteamroom_pagelayout]
Source=pagelayout.tpl
MatchFile=module_widget_pagelayout.tpl
Subdir=templates
Match[viewmode]=createteamroom

[bookmarks_pagelayout]
Source=pagelayout.tpl
MatchFile=module_widget_pagelayout.tpl
Subdir=templates
Match[viewmode]=bookmarks

[usertaskslist_pagelayout]
Source=pagelayout.tpl
MatchFile=module_widget_pagelayout.tpl
Subdir=templates
Match[viewmode]=usertaskslist

[teamroomlist_pagelayout]
Source=pagelayout.tpl
MatchFile=module_widget_pagelayout.tpl
Subdir=templates
Match[viewmode]=teamroomlist

[lightboxlist_pagelayout]
Source=pagelayout.tpl
MatchFile=module_widget_pagelayout.tpl
Subdir=templates
Match[viewmode]=lightboxlist
Match[module]=lightbox

[lightboxselection_pagelayout]
Source=pagelayout.tpl
MatchFile=module_widget_pagelayout.tpl
Subdir=templates
Match[viewmode]=lightboxselection
Match[module]=lightbox

[currrentlightbox_pagelayout]
Source=pagelayout.tpl
MatchFile=module_widget_pagelayout.tpl
Subdir=templates
Match[viewmode]=currentlightbox
Match[module]=lightbox

[lightboxlist]
Source=lightbox/views/list.tpl
MatchFile=lightbox/views/list.tpl
Subdir=templates
Match[viewmode]=list
Match[module]=lightbox

[module_widget_event_calendar]
Source=node/view/module_widget.tpl
MatchFile=module_widget/event_calendar.tpl
Subdir=templates
Match[class_identifier]=teamroom_event_calendar

[module_widget_blog]
Source=node/view/module_widget.tpl
MatchFile=module_widget/blog.tpl
Subdir=templates
Match[class_identifier]=teamroom_blog

[module_widget_user_group]
Source=node/view/module_widget.tpl
MatchFile=module_widget/user_group.tpl
Subdir=templates
Match[class_identifier]=user_group


[module_widget_file_folder]
Source=node/view/module_widget.tpl
MatchFile=module_widget/file_folder.tpl
Subdir=templates
Match[class_identifier]=teamroom_file_folder

[module_widget_pagelayout_test]
Source=pagelayout.tpl
MatchFile=module_widget_pagelayout.tpl
Subdir=templates
Match[error_type]=kernel
Match[viewmode]=module_result

[pf_box_infobox]
Source=node/view/pf_box.tpl
MatchFile=pf_box/infobox.tpl
Subdir=templates
Match[class_identifier]=teamroom_infobox

[full_personal_frontpage]
Source=node/view/full.tpl
MatchFile=full/personal_frontpage.tpl
Subdir=templates
Match[class_identifier]=teamroom_personal_frontpage

[line_milestone]
Source=node/view/line.tpl
MatchFile=line/milestone.tpl
Subdir=templates
Match[class_identifier]=teamroom_milestone

[full_forum]
Source=node/view/full.tpl
MatchFile=full/forum.tpl
Subdir=templates
Match[class_identifier]=teamroom_forum

[full_forum_reply]
Source=node/view/full.tpl
MatchFile=full/forum_reply.tpl
Subdir=templates
Match[class_identifier]=teamroom_forum_reply

[full_forum_topic]
Source=node/view/full.tpl
MatchFile=full/forum_topic.tpl
Subdir=templates
Match[class_identifier]=teamroom_forum_topic

[teamroom_cal_line_event]
Source=node/view/cal_line.tpl
MatchFile=cal_line/event.tpl
Subdir=templates
Match[class_identifier]=teamroom_event

[teamroom_cal_line_milestone]
Source=node/view/cal_line.tpl
MatchFile=cal_line/milestone.tpl
Subdir=templates
Match[class_identifier]=teamroom_milestone

[teamroom_cal_line_task]
Source=node/view/cal_line.tpl
MatchFile=cal_line/task.tpl
Subdir=templates
Match[class_identifier]=teamroom_task

[image_lightbox_line]
Source=content/view/lightbox_line.tpl
MatchFile=content/view/line/image.tpl
Subdir=templates
Match[class_identifier]=image

[file_lightbox_line]
Source=content/view/lightbox_line.tpl
MatchFile=content/view/line/file.tpl
Subdir=templates
Match[class_identifier]=teamroom_file

[user_lightbox_line]
Source=content/view/lightbox_line.tpl
MatchFile=content/view/line/user.tpl
Subdir=templates
Match[class_identifier]=user

[embed_image]
Source=content/view/embed.tpl
MatchFile=embed/image.tpl
Subdir=templates
Match[class_identifier]=image

[full_teamroom_documentation_page]
Source=node/view/full.tpl
MatchFile=full/documentation_page.tpl
Subdir=templates
Match[class_identifier]=teamroom_documentation_page

[line_teamroom_documentation_page]
Source=node/view/line.tpl
MatchFile=line/documentation_page.tpl
Subdir=templates
Match[class_identifier]=teamroom_documentation_page

[full_teamroom_blog]
Source=node/view/full.tpl
MatchFile=full/blog.tpl
Subdir=templates
Match[class_identifier]=teamroom_blog

#[line_teamroom_blog]
#Source=node/view/line.tpl
#MatchFile=line/blog.tpl
#Subdir=templates
#Match[class_identifier]=teamroom_blog

[full_teamroom_blog_post]
Source=node/view/full.tpl
MatchFile=full/blog_post.tpl
Subdir=templates
Match[class_identifier]=teamroom_blog_post

[line_teamroom_blog_post]
Source=node/view/line.tpl
MatchFile=line/blog_post.tpl
Subdir=templates
Match[class_identifier]=teamroom_blog_post

[full_teamroom_event_calendar]
Source=node/view/full.tpl
MatchFile=full/event_calendar.tpl
Subdir=templates
Match[class_identifier]=teamroom_event_calendar

#[line_teamroom_event_calendar]
#Source=node/view/line.tpl
#MatchFile=line/event_calendar.tpl
#Subdir=templates
#Match[class_identifier]=teamroom_event_calendar

[full_teamroom_event]
Source=node/view/full.tpl
MatchFile=full/event.tpl
Subdir=templates
Match[class_identifier]=teamroom_event

#[line_teamroom_event]
#Source=node/view/line.tpl
#MatchFile=line/event.tpl
#Subdir=templates
#Match[class_identifier]=teamroom_event

[line_teamroom_comment]
Source=node/view/line.tpl
MatchFile=line/comment.tpl
Subdir=templates
Match[class_identifier]=teamroom_comment

##################################################
# OVERRIDES FROM EZWEBIN
#
# TAKEN FOR COMPABILITY REASONS
# PLACED HERE FOR AN EASY INSTALLATION
##################################################

#[full_article]
#Source=node/view/full.tpl
#MatchFile=full/article.tpl
#Subdir=templates
#Match[class_identifier]=article

#[full_article_mainpage]
#Source=node/view/full.tpl
#MatchFile=full/article_mainpage.tpl
#Subdir=templates
#Match[class_identifier]=article_mainpage

#[full_article_subpage]
#Source=node/view/full.tpl
#MatchFile=full/article_subpage.tpl
#Subdir=templates
#Match[class_identifier]=article_subpage

#[full_banner]
#Source=node/view/full.tpl
#MatchFile=full/banner.tpl
#Subdir=templates
#Match[class_identifier]=banner

#[full_blog]
#Source=node/view/full.tpl
#MatchFile=full/blog.tpl
#Subdir=templates
#Match[class_identifier]=blog

#[full_blog_post]
#Source=node/view/full.tpl
#MatchFile=full/blog_post.tpl
#Subdir=templates
#Match[class_identifier]=blog_post

#[full_comment]
#Source=node/view/full.tpl
#MatchFile=full/comment.tpl
#Subdir=templates
#Match[class_identifier]=comment

#[full_documentation_page]
#Source=node/view/full.tpl
#MatchFile=full/documentation_page.tpl
#Subdir=templates
#Match[class_identifier]=documentation_page

#[full_event_calendar]
#Source=node/view/full.tpl
#MatchFile=full/event_calendar.tpl
#Subdir=templates
#Match[class_identifier]=event_calendar

#[full_event]
#Source=node/view/full.tpl
#MatchFile=full/event.tpl
#Subdir=templates
#Match[class_identifier]=event

#[full_feedback_form]
#Source=node/view/full.tpl
#MatchFile=full/feedback_form.tpl
#Subdir=templates
#Match[class_identifier]=feedback_form

#[full_file]
#Source=node/view/full.tpl
#MatchFile=full/file.tpl
#Subdir=templates
#Match[class_identifier]=file

#[full_flash]
#Source=node/view/full.tpl
#MatchFile=full/flash.tpl
#Subdir=templates
#Match[class_identifier]=flash

#[full_folder]
#Source=node/view/full.tpl
#MatchFile=full/file_folder.tpl
#Subdir=templates
#Match[class_identifier]=folder

#[full_forum]
#Source=node/view/full.tpl
#MatchFile=full/forum.tpl
#Subdir=templates
#Match[class_identifier]=forum

#[full_forum_reply]
#Source=node/view/full.tpl
#MatchFile=full/forum_reply.tpl
#Subdir=templates
#Match[class_identifier]=forum_reply

#[full_forum_topic]
#Source=node/view/full.tpl
#MatchFile=full/forum_topic.tpl
#Subdir=templates
#Match[class_identifier]=forum_topic

#[full_forums]
#Source=node/view/full.tpl
#MatchFile=full/forums.tpl
#Subdir=templates
#Match[class_identifier]=forums

#[full_frontpage]
#Source=node/view/full.tpl
#MatchFile=full/frontpage.tpl
#Subdir=templates
#Match[class_identifier]=frontpage

#[full_gallery]
#Source=node/view/full.tpl
#MatchFile=full/gallery.tpl
#Subdir=templates
#Match[class_identifier]=gallery

#[full_image]
#Source=node/view/full.tpl
#MatchFile=full/image.tpl
#Subdir=templates
#Match[class_identifier]=image

#[full_infobox]
#Source=node/view/full.tpl
#MatchFile=full/infobox.tpl
#Subdir=templates
#Match[class_identifier]=infobox

#[full_link]
#Source=node/view/full.tpl
#MatchFile=full/link.tpl
#Subdir=templates
#Match[class_identifier]=link

#[full_multicalendar]
#Source=node/view/full.tpl
#MatchFile=full/multicalendar.tpl
#Subdir=templates
#Match[class_identifier]=multicalendar

#[full_poll]
#Source=node/view/full.tpl
#MatchFile=full/poll.tpl
#Subdir=templates
#Match[class_identifier]=poll

#[full_product]
#Source=node/view/full.tpl
#MatchFile=full/product.tpl
#Subdir=templates
#Match[class_identifier]=product

#[full_quicktime]
#Source=node/view/full.tpl
#MatchFile=full/quicktime.tpl
#Subdir=templates
#Match[class_identifier]=quicktime

#[full_real_video]
#Source=node/view/full.tpl
#MatchFile=full/real_video.tpl
#Subdir=templates
#Match[class_identifier]=real_video

#[full_windows_media]
#Source=node/view/full.tpl
#MatchFile=full/windows_media.tpl
#Subdir=templates
#Match[class_identifier]=windows_media

#[line_article]
#Source=node/view/line.tpl
#MatchFile=line/article.tpl
#Subdir=templates
#Match[class_identifier]=article

#[line_article_mainpage]
#Source=node/view/line.tpl
#MatchFile=line/article_mainpage.tpl
#Subdir=templates
#Match[class_identifier]=article_mainpage

#[line_article_subpage]
#Source=node/view/line.tpl
#MatchFile=line/article_subpage.tpl
#Subdir=templates
#Match[class_identifier]=article_subpage

#[line_banner]
#Source=node/view/line.tpl
#MatchFile=line/banner.tpl
#Subdir=templates
#Match[class_identifier]=banner

#[line_blog]
#Source=node/view/line.tpl
#MatchFile=line/blog.tpl
#Subdir=templates
#Match[class_identifier]=blog

#[line_blog_post]
#Source=node/view/line.tpl
#MatchFile=line/blog_post.tpl
#Subdir=templates
#Match[class_identifier]=blog_post

#[line_comment]
#Source=node/view/line.tpl
#MatchFile=line/comment.tpl
#Subdir=templates
#Match[class_identifier]=comment

#[line_documentation_page]
#Source=node/view/line.tpl
#MatchFile=line/documentation_page.tpl
#Subdir=templates
#Match[class_identifier]=documentation_page

#[line_event_calendar]
#Source=node/view/line.tpl
#MatchFile=line/event_calendar.tpl
#Subdir=templates
#Match[class_identifier]=event_calendar

#[line_event]
#Source=node/view/line.tpl
#MatchFile=line/event.tpl
#Subdir=templates
#Match[class_identifier]=event

#[line_feedback_form]
#Source=node/view/line.tpl
#MatchFile=line/feedback_form.tpl
#Subdir=templates
#Match[class_identifier]=feedback_form

#[line_file]
#Source=node/view/line.tpl
#MatchFile=line/file.tpl
#Subdir=templates
#Match[class_identifier]=file

#[line_flash]
#Source=node/view/line.tpl
#MatchFile=line/flash.tpl
#Subdir=templates
#Match[class_identifier]=flash

#[line_folder]
#Source=node/view/line.tpl
#MatchFile=line/folder.tpl
#Subdir=templates
#Match[class_identifier]=folder

#[line_forum]
#Source=node/view/line.tpl
#MatchFile=line/forum.tpl
#Subdir=templates
#Match[class_identifier]=forum

#[line_forum_reply]
#Source=node/view/line.tpl
#MatchFile=line/forum_reply.tpl
#Subdir=templates
#Match[class_identifier]=forum_reply

#[line_forum_topic]
#Source=node/view/line.tpl
#MatchFile=line/forum_topic.tpl
#Subdir=templates
#Match[class_identifier]=forum_topic

#[line_forums]
#Source=node/view/line.tpl
#MatchFile=line/forums.tpl
#Subdir=templates
#Match[class_identifier]=forums

#[line_gallery]
#Source=node/view/line.tpl
#MatchFile=line/gallery.tpl
#Subdir=templates
#Match[class_identifier]=gallery

#[line_image]
#Source=node/view/line.tpl
#MatchFile=line/image.tpl
#Subdir=templates
#Match[class_identifier]=image

#[line_infobox]
#Source=node/view/line.tpl
#MatchFile=line/infobox.tpl
#Subdir=templates
#Match[class_identifier]=infobox

#[line_link]
#Source=node/view/line.tpl
#MatchFile=line/link.tpl
#Subdir=templates
#Match[class_identifier]=link

#[line_multicalendar]
#Source=node/view/line.tpl
#MatchFile=line/multicalendar.tpl
#Subdir=templates
#Match[class_identifier]=multicalendar

#[line_poll]
#Source=node/view/line.tpl
#MatchFile=line/poll.tpl
#Subdir=templates
#Match[class_identifier]=poll

#[line_product]
#Source=node/view/line.tpl
#MatchFile=line/product.tpl
#Subdir=templates
#Match[class_identifier]=product

#[line_quicktime]
#Source=node/view/line.tpl
#MatchFile=line/quicktime.tpl
#Subdir=templates
#Match[class_identifier]=quicktime

#[line_real_video]
#Source=node/view/line.tpl
#MatchFile=line/real_video.tpl
#Subdir=templates
#Match[class_identifier]=real_video

#[line_windows_media]
#Source=node/view/line.tpl
#MatchFile=line/windows_media.tpl
#Subdir=templates
#Match[class_identifier]=windows_media

#[edit_comment]
#Source=content/edit.tpl
#MatchFile=edit/comment.tpl
#Subdir=templates
#Match[class_identifier]=comment

#[edit_file]
#Source=content/edit.tpl
#MatchFile=edit/file.tpl
#Subdir=templates
#Match[class_identifier]=file

#[edit_forum_topic]
#Source=content/edit.tpl
#MatchFile=edit/forum_topic.tpl
#Subdir=templates
#Match[class_identifier]=forum_topic

#[edit_forum_reply]
#Source=content/edit.tpl
##MatchFile=edit/forum_reply.tpl
#Subdir=templates
#Match[class_identifier]=forum_reply

#[highlighted_object]
#Source=content/view/embed.tpl
#MatchFile=embed/highlighted_object.tpl
#Subdir=templates
#Match[classification]=highlighted_object

#[embed_task]
#Source=content/view/embed.tpl
#MatchFile=embed/task.tpl
#Subdir=templates
#Match[class_identifier]=task

#[embed_article]
#Source=content/view/embed.tpl
#MatchFile=embed/article.tpl
#Subdir=templates
#Match[class_identifier]=article

#[embed_banner]
#Source=content/view/embed.tpl
#MatchFile=embed/banner.tpl
#Subdir=templates
#Match[class_identifier]=banner

#[embed_file]
#Source=content/view/embed.tpl
#MatchFile=embed/file.tpl
#Subdir=templates
#Match[class_identifier]=file

#[embed_flash]
#Source=content/view/embed.tpl
#MatchFile=embed/flash.tpl
#Subdir=templates
#Match[class_identifier]=flash

#[itemized_sub_items]
#Source=content/view/embed.tpl
#MatchFile=embed/itemized_sub_items.tpl
#Subdir=templates
#Match[classification]=itemized_sub_items

#[vertically_listed_sub_items]
#Source=content/view/embed.tpl
#MatchFile=embed/vertically_listed_sub_items.tpl
#Subdir=templates
#Match[classification]=vertically_listed_sub_items

#[horizontally_listed_sub_items]
#Source=content/view/embed.tpl
#MatchFile=embed/horizontally_listed_sub_items.tpl
#Subdir=templates
#Match[classification]=horizontally_listed_sub_items

#[itemized_subtree_items]
#Source=content/view/embed.tpl
#MatchFile=embed/itemized_subtree_items.tpl
#Subdir=templates
#Match[classification]=itemized_subtree_items

#[embed_folder]
#Source=content/view/embed.tpl
#MatchFile=embed/folder.tpl
#Subdir=templates
#Match[class_identifier]=folder

#[embed_forum]
#Source=content/view/embed.tpl
#MatchFile=embed/forum.tpl
#Subdir=templates
#Match[class_identifier]=forum

#[embed_gallery]
#Source=content/view/embed.tpl
#MatchFile=embed/gallery.tpl
#Subdir=templates
#Match[class_identifier]=gallery

#[embed_image]
#Source=content/view/embed.tpl
#MatchFile=embed/image.tpl
#Subdir=templates
#Match[class_identifier]=image

#[embed_poll]
#Source=content/view/embed.tpl
#MatchFile=embed/poll.tpl
#Subdir=templates
#Match[class_identifier]=poll

#[embed_product]
#Source=content/view/embed.tpl
#MatchFile=embed/product.tpl
#Subdir=templates
#Match[class_identifier]=product

#[embed_quicktime]
#Source=content/view/embed.tpl
#MatchFile=embed/quicktime.tpl
#Subdir=templates
#Match[class_identifier]=quicktime

#[embed_real_video]
#Source=content/view/embed.tpl
#MatchFile=embed/real_video.tpl
#Subdir=templates
#Match[class_identifier]=real_video

#[embed_windows_media]
#Source=content/view/embed.tpl
#MatchFile=embed/windows_media.tpl
#Subdir=templates
#Match[class_identifier]=windows_media

#[embed_inline_image]
#Source=content/view/embed-inline.tpl
#MatchFile=embed-inline/image.tpl
#Subdir=templates
#Match[class_identifier]=image

#[embed_itemizedsubitems_gallery]
#Source=content/view/itemizedsubitems.tpl
#MatchFile=itemizedsubitems/gallery.tpl
#Subdir=templates
#Match[class_identifier]=gallery

#[embed_itemizedsubitems_forum]
#Source=content/view/itemizedsubitems.tpl
#MatchFile=itemizedsubitems/forum.tpl
#Subdir=templates
#Match[class_identifier]=forum

#[embed_itemizedsubitems_folder]
#Source=content/view/itemizedsubitems.tpl
#MatchFile=itemizedsubitems/folder.tpl
#Subdir=templates
#Match[class_identifier]=folder

#[embed_itemizedsubitems_event_calendar]
#Source=content/view/itemizedsubitems.tpl
#MatchFile=itemizedsubitems/event_calendar.tpl
#Subdir=templates
#Match[class_identifier]=event_calendar

#[embed_itemizedsubitems_documentation_page]
#Source=content/view/itemizedsubitems.tpl
#MatchFile=itemizedsubitems/documentation_page.tpl
#Subdir=templates
#Match[class_identifier]=documentation_page

#[embed_itemizedsubitems_itemized_sub_items]
#Source=content/view/itemizedsubitems.tpl
#MatchFile=itemizedsubitems/itemized_sub_items.tpl
#Subdir=templates

#[embed_event_calendar]
#Source=content/view/embed.tpl
#MatchFile=embed/event_calendar.tpl
#Subdir=templates
#Match[class_identifier]=event_calendar

#[embed_horizontallylistedsubitems_article]
#Source=node/view/horizontallylistedsubitems.tpl
#MatchFile=horizontallylistedsubitems/article.tpl
#Subdir=templates
#Match[class_identifier]=article

#[embed_horizontallylistedsubitems_event]
#Source=node/view/horizontallylistedsubitems.tpl
#MatchFile=horizontallylistedsubitems/event.tpl
#Subdir=templates
#Match[class_identifier]=event

#[embed_horizontallylistedsubitems_image]
#Source=node/view/horizontallylistedsubitems.tpl
#MatchFile=horizontallylistedsubitems/image.tpl
#Subdir=templates
#Match[class_identifier]=image

#[embed_horizontallylistedsubitems_product]
#Source=node/view/horizontallylistedsubitems.tpl
#MatchFile=horizontallylistedsubitems/product.tpl
#Subdir=templates
#Match[class_identifier]=product

#[factbox]
#Source=content/datatype/view/ezxmltags/factbox.tpl
#MatchFile=datatype/ezxmltext/factbox.tpl
#Subdir=templates

#[quote]
#Source=content/datatype/view/ezxmltags/quote.tpl
#MatchFile=datatype/ezxmltext/quote.tpl
#Subdir=templates

#[table_cols]
#Source=content/datatype/view/ezxmltags/table.tpl
#MatchFile=datatype/ezxmltext/table_cols.tpl
#Subdir=templates
#Match[classification]=cols

#[table_comparison]
#Source=content/datatype/view/ezxmltags/table.tpl
#MatchFile=datatype/ezxmltext/table_comparison.tpl
#Subdir=templates
#Match[classification]=comparison

#[image_galleryline]
#Source=node/view/galleryline.tpl
#MatchFile=galleryline/image.tpl
#Subdir=templates
#Match[class_identifier]=image

#[image_galleryslide]
#Source=node/view/galleryslide.tpl
#MatchFile=galleryslide/image.tpl
#Subdir=templates
#Match[class_identifier]=image

#[article_listitem]
#Source=node/view/listitem.tpl
#MatchFile=listitem/article.tpl
#Subdir=templates
#Match[class_identifier]=article

#[image_listitem]
#Source=node/view/listitem.tpl
#MatchFile=listitem/image.tpl
#Subdir=templates
#Match[class_identifier]=image

#[billboard_banner]
#Source=content/view/billboard.tpl
#MatchFile=billboard/banner.tpl
#Subdir=templates
#Match[class_identifier]=banner

#[billboard_flash]
#Source=content/view/billboard.tpl
#MatchFile=billboard/flash.tpl
#Subdir=templates
#Match[class_identifier]=flash

#[tiny_image]
#Source=content/view/tiny.tpl
#MatchFile=tiny_image.tpl
#Subdir=templates
#Match[class_identifier]=image

*/ ?>
