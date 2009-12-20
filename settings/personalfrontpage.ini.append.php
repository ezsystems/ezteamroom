<?php /* #?ini charset="utf-8"?
# Settings related to Personal Frontpage

# General settings
[PersonalFrontpage]

# Enables JavaScript debug output
JSDebug=disabled


# Settings concerning the widget overview,
# which is shown when clicking to "Add Widget"
[WidgetOverview]

# WidgetDescriptionAttribute is a content object attribute,
# which is shown as description in the widget overview.
# If the attribute is not found the next one will be selected.
# e.g.:
# WidgetDescriptionAttribute[]=name
# WidgetDescriptionAttribute[]=intro
# First 'name' is display as description. If it can not be found
# 'intro' will be chosen. If neither name nor intro is found
# nothing will be shown.
WidgetDescriptionAttribute[]
WidgetDescriptionAttribute[]=name
WidgetDescriptionAttribute[]=intro
WidgetDescriptionAttribute[]=description


# Settings concerning the widget boxes
[WidgetSettings]

# Content classes having children can be shown as list.
# If no template is defined, a default template will be used.
ShowAsList[]
ShowAsList[]=folder

# Content classes which should not be shown as widgets
DisabledContentClasses[]
DisabledContentClasses[]=frontpage
DisabledContentClasses[]=personal_frontpage
DisabledContentClasses[]=teamroom_frontpage
DisabledContentClasses[]=teamroom_personal_frontpage

# If BoxCSSOverflow is true, widgets will obtain a scroll bar
# when more HTML content is shown as the size of the box allows.
BoxCSSOverflow=true


# Template settings
[WidgetTemplateSettings]

# For each content class a template can be defined,
# which is used when showing the content class within a dragable box.
# e.g. UseUserTemplate[]=article
# will use article.tpl as template to display all content
# classes of type 'article'
#
# UseUserTemplate[]=event_calendar;calendar
# will override all content classes of type 'event_calendar'
# and use 'calendar.tpl' as template.
#
# Templates should be placed in:
# extension\ezpersonalfrontpage\design\ezpersonalfrontpage\templates\content\view
UseUserTemplate[]
UseUserTemplate[]=module_widget
UseUserTemplate[]=article
UseUserTemplate[]=news_folder
UseUserTemplate[]=event_calendar;calendar
UseUserTemplate[]=teamroom_event_calendar;calendar
UseUserTemplate[]=multicalendar;show_attributes

# It is possible to show only one attribute from a content class.
# The content class and the attribute to show are separated by
# a semicolon. (The attribute will be displayed by using 'attribute_view_gui')
#
# e.g ShowAttributeFromContentClass[]=article;body
# will only show the attribute 'body' if the content class
# 'article' is displayed.
ShowAttributeFromContentClass[]
ShowAttributeFromContentClass[]=article;body
ShowAttributeFromContentClass[]=documentation;body
#ShowAttributeFromContentClass[]=foo;bar

# If a content class is shown as list, a user template
# can be defined here.
# e.g. UseUserTemplateAsList[folder]=folder_line
# will create a HTML ul tag, but for each child the template
# 'folder_line.tpl' is processed.
UseUserTemplateAsList[folder]=folder_line


*/ ?>
