


{* set-block scope=root variable=cache_ttl}0{/set-block *} {* ab: Commented out to find a better way if possible *}




<div class="class-personal-frontpage">
 <div class="overflow-fix">

{def $prefs = ezpreference( concat( "personalfrontpage_widgetlist_", $node.node_id ) ) }

{if $prefs|not}

    {set $prefs = $node.object.data_map.default_arrangement.value}

{/if}

{def $show_descr = ezpreference( "personalfrontpage_displaydescription" )}

{if $show_descr|ne( '1' )}

    {set $show_descr = '2'}

{/if}

{def $current_user     = fetch( 'user', 'current_user' )
     $user_template    = ezini( "WidgetTemplateSettings",   "UseUserTemplate",               "personalfrontpage.ini" )
     $show_attributes  = ezini( "WidgetTemplateSettings",   "ShowAttributeFromContentClass", "personalfrontpage.ini" )
     $show_as_list     = ezini( "WidgetSettings",           "ShowAsList",                    "personalfrontpage.ini" )
     $disabled_widgets = ezini( "WidgetSettings",           "DisabledContentClasses",        "personalfrontpage.ini" )
     $box_overflow     = ezini( "WidgetSettings",           "BoxCSSOverflow",                "personalfrontpage.ini" )
     $widget_desc_attr = ezini( "WidgetOverview",           "WidgetDescriptionAttribute",    "personalfrontpage.ini" )
     $debug            = ezini( "PersonalFrontpage",        "JSDebug",                       "personalfrontpage.ini" )
     $debug_enabled    = "false"
     $container_name   = "DragContainer"
     $object           = false()
     $id               = false()
     $view_found       = false()
     $num_of_columns   = $node.object.data_map.num_of_columns.value
     $minimization     = $node.object.data_map.allow_minimization.value
     $list_name        = $node.object.data_map.title.value}

{if $debug|eq( "enabled" )}

  {set $debug_enabled = "true"}

{/if}

{* cache-block keys=array( $node.node_id, $current_user.contentobject_id, $show_descr ) *} {* ab: Commented out to find a better way instead of using ttl if possible *}

<div class="border-box" {if $show_descr|eq( '1' )}style="display:none;"{/if}>
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">
    <div class="class-personal-frontpage-header">
        <h1>{attribute_view_gui attribute=$node.data_map.title}</h1>

    {if $node.data_map.description.has_content}

        {attribute_view_gui attribute=$node.data_map.description}

    {/if}

    </div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
<div class="float-break"></div>
<div class="{cond( $show_descr|eq( '1' ), 'pfd_hide', 'pfd_show' )}">
 <a href={concat( '/user/preferences/set/','personalfrontpage_displaydescription', '/', cond( $show_descr|eq( '1' ), '2', '1' ) )|ezurl} title="{'Hide / Unhide description header.'|i18n( 'ezteamroom/frontpage' )}">{cond( $show_descr|eq( '1' ), 'Show header'|i18n( 'ezteamroom/frontpage' ), 'Hide header'|i18n( 'ezteamroom/frontpage' ) )}</a>
</div>
<div id="selectColumnPopup" style="display:none">
    <div class="border-left">
    <div class="border-right">
    <div class="border-content">
        <span>{"Insert into column:"|i18n('ezteamroom/frontpage')}</span>
        <a class="close-button" href="javascript:closeAddWidgetMenu();"></a>
        <ul class="sub-menu-list">

    {for 1 to $num_of_columns as $column_counter}

            <li>
                <a href="javascript:addWidget({$column_counter})"
                   id="add-widget-button-{$column_counter}">#{$column_counter}</a>
            </li>

    {/for}

        </ul>
    </div>
    </div>
    </div>
</div>

<div class="available-widgets border-box" id="available-widgets-list" style="display:none">

    {** BOX **}
    <div class="border-tl"><div class="border-tr"><div class="border-tc">

    <h2>{"Available widgets"|i18n('ezteamroom/frontpage')}:</h2>
    <a class="close-button" href="javascript:closeAvaibleWidgets();"></a>
    </div></div></div>
    <div class="border-ml">
    {** /BOX **}

    <div class="content">
    <ul>

    {def $box_folder       = false()
         $image_parameters = hash( 'size', 'tiny' )
         $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
         $box_folder_list  = fetch( 'content', 'list', hash( 'parent_node_id',     $node.node_id,
                                                             'class_filter_type',  'include',
                                                             'class_filter_array', array( $class_identifier_map['boxfolder'] ) ) )}
    {if $box_folder_list|count()}
        {set $box_folder=$box_folder_list.0}
    {/if}
    {if $box_folder.children|count()}
    {foreach $box_folder.children as $key => $relation}
        {set $object = $relation.object}

        {if $relation.data_map.check_access.has_content}
            {def $access_array = $relation.data_map.check_access.content|explode( '/' )}
            {if and( is_array($access_array), count($access_array)|eq(2) )}
                {if fetch( 'user', 'has_access_to', hash( 'module',   $access_array.0, 'function', $access_array.1 ) )|not()}
                    {continue}
                {/if}
            {/if}
            {undef $access_array}
        {/if}

        <li id="box_{$object.id}_listitem" class="box_{$object.id} {if $box_folder.children|count()|eq( $key|inc )} lastli{/if}" >
        <div class="widget-item float-break">
            {attribute_view_gui attribute=$relation.data_map.box_icon attr_view='embed' object_parameters=$image_parameters}
            <a href="javascript:toggleAddWidgetMenu({$object.id})" class="widget-name">{$object.name|wash()}</a>
        </div>
        </li>
    {/foreach}
    {/if}
    </ul>

    </div>
    {** BOX **}
    </div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    {** /BOX **}
</div>

<div class="addWidget">
 <a href="javascript:showAvaibleWidgets()" id="addNewWidgetButton" class="pfd_offset">{"Add new widget"|i18n('ezteamroom/frontpage')}</a>
</div>

<div id="TempContainer" style="display:none">
    {if $box_folder.children|count}
    {foreach $box_folder.children as $relation}
        {set $object = $relation.object}
        {set $id     = $relation.class_identifier}

    {if $relation.data_map.check_access.has_content}
        {def $access_array = $relation.data_map.check_access.content|explode( '/' )}
        {if and( is_array($access_array), count($access_array)|eq(2) )}
            {if fetch( 'user', 'has_access_to', hash( 'module',   $access_array.0, 'function', $access_array.1 ) )|not()}
                {continue}
            {/if}
        {/if}
        {undef $access_array}
    {/if}
    <div id="box_{$object.id}" class="widget-box">
        <div class="widget-dragbar-handler" id="dragbar_{$object.id}"></div>

        <div class="widget-dragbar float-break">
            <div class="icon">{attribute_view_gui attribute=$relation.data_map.box_icon attr_view='embed'}</div>
            <div class="title"><h3 title="{$object.name|wash()}">{$object.name|wash()|shorten( 18 )}</h3></div>
            <div class="widget-menu">
                {if $minimization}
                    <a href="#" class="maxmin-button" onclick="toggleWidget({$object.id}); return false;" id="maxmin_{$object.id}"></a>
                {/if}
                <a href="#" class="close-button" onclick="closeWidget({$object.id}); return false;"></a>
            </div>
        </div>
        <div class="widget-content" id="content_box_{$object.id}">
                {node_view_gui view="pf_box" content_node=$relation}

            {if $debug_enabled|eq( "true" )}
                <hr />
                <span>[typ={$id}][id={$object.id}]</span>
            {/if}
        <div class="widget-footer">&nbsp;</div>
        </div>
    </div>
    {/foreach}
    {/if}
</div>

<div class="ContainerContainer">
{for 1 to $num_of_columns as $column_counter}
    <div class="DragContainer" id="{$container_name}{$column_counter}">&nbsp;</div>
{/for}
</div>

<br style="clear:both" />

{if $debug_enabled|eq( "true" )}
<fieldset>
    <legend>{"Debug"|i18n('ezteamroom/frontpage')}</legend>
    <div class="history" id="History"></div>
</fieldset>
{/if}

<div id="DragHelper" style="position:absolute; display:none;"></div>
<div id="PFLoadingError" style="display:none">
    <div class="box-loading-error">
        <h3>{'Error loading box'|i18n("ezteamroom/frontpage")}</h3>
        <input type="button" class="text-button" value="{"Reload"|i18n('ezteamroom/frontpage')}"
               onclick="javascript:LoadModule( '#ID#', '(pfbox)/1' );" />
    </div>
</div>
<div id="PFAccessDenied" style="display:none">
    <div class="box-loading-error">
        <h3>{'Access Denied'|i18n("ezteamroom/frontpage")}</h3>
        <p>{"You are not logged in or you do not have access."|i18n("ezteamroom/frontpage")}</p>
        <p><a href={"/user/register"|ezurl} title="{"Please register here"|i18n("ezteamroom/frontpage")}">{"Please register here."|i18n("ezteamroom/frontpage")}</a></p>
        <p><a href={"/user/login"|ezurl} title="{"Login here"|i18n("ezteamroom/frontpage")}">{"Login here."|i18n("ezteamroom/frontpage")}</a></p>
    </div>
</div>

{* /cache-block *}  {* ab: Commented out to find a better way instead of using ttl if possible *}

<script type="text/javascript">
var gPrefs               = '{$prefs}';
var gNumOfColumns        = {$num_of_columns};
var gContainerName       = '{$container_name}';
var gPreferencesHostUrl  = '{"/user/preferences/set/"|ezurl(no,"full")}';
var gHostUrl             = '{"/"|ezurl(no, "full")}';
var gUserID              = '{$current_user.contentobject_id}';
var gPreferenceParameter = 'personalfrontpage_widgetlist_{$node.node_id}';
var gActivateExtension   = true;
var gDebugEnabled        = {$debug_enabled};
</script>

<noscript>
<div id="warning-nojs">
{"You have to enable JavaScript in your web browser."|i18n('ezteamroom/frontpage')}
</div>
</noscript>
</div>
</div>
