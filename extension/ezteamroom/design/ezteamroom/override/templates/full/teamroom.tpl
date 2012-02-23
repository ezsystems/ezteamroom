

{* set-block scope=root variable=cache_ttl}0{/set-block *} {* ab: Commented out to find a better way if possible *}

{def $widgetURLParameter = concat( '/(teamroomNodeID)/', $node.node_id )
     $user_list       = fetch( 'content', 'tree', hash( 'parent_node_id',    $node.node_id,
                                                        'depth', 3,
                                                        'limitation', array(),
                                                        'class_filter_type', 'include',
                                                        'class_filter_array', array( 'user' ) ) )
     $current_user    = fetch( 'user', 'current_user' )
     $is_group_member = false()
     $is_public = first_set( $node.data_map.access_type.content.0|eq( 'public' ), false() )}

{foreach $user_list as $user}

    {if $user.contentobject_id|eq( $current_user.contentobject_id )}

        {set $is_group_member = true()}

        {break}

    {/if}

{/foreach}

{undef $user_list}

<div class="class-personal-frontpage">
<div class="overflow-fix">

{def $frontpagestyle = 'leftcolumn rightcolumn'}

<div class="class-teamroom-header {$frontpagestyle}">
    <div class="columns-teamroom-header float-break">
        <div class="left-column-position">
            <div class="left-column">
            <!-- Content: START -->
                <h2><strong>{'Name'|i18n( 'ezteamroom/teamroom' )} </strong></h2><h1>{$node.name|wash()}</h1><br />
                <h2><strong>{'Owner'|i18n( 'ezteamroom/teamroom' )}</strong> {$node.object.owner.name|wash()}</h2>
                <h2><strong>{'Created'|i18n( 'ezteamroom/teamroom' )}</strong> {$node.object.current.created|l10n('shortdatetime')}</h2>
            <!-- Content: END -->
            </div>
        </div>
        <div class="center-column-position">
            <div class="center-column float-break">
                <div class="overflow-fix">
                <!-- Content: START -->
                    <div class="title">{'Description'|i18n( 'ezteamroom/teamroom' )}</div>
                    <div class="content">{attribute_view_gui attribute=$node.data_map.description}</div>
                <!-- Content: END -->
                </div>
            </div>
        </div>
        <div class="right-column-position">
            <div class="right-column">
            <!-- Content: START -->
                {attribute_view_gui attribute=$node.data_map.access_type}
            <!-- Content: END -->
            </div>
        </div>
    </div>
</div>

{if $current_user.is_logged_in|not}

    <div class="attribute-join float-break">
        <form method="post" action={"/user/login/"|ezurl} name="loginform">
        <div class="block">
        <label for="id1">{"Username"|i18n("ezteamroom/teamroom",'User name')}</label><div class="labelbreak"></div>
        <input class="halfbox" type="text" size="10" name="Login" id="id1" value="{$User:login|wash}" tabindex="1" />
        </div>

        <div class="block">
        <label for="id2">{"Password"|i18n("ezteamroom/teamroom")}</label><div class="labelbreak"></div>
        <input class="halfbox" type="password" size="10" name="Password" id="id2" value="" tabindex="1" />
        </div>
        <div class="buttonblock">
        <input class="defaultbutton" type="submit" name="LoginButton" value="{'Login'|i18n('ezteamroom/teamroom','Button')}" tabindex="1" />
        <input class="button" type="submit" name="RegisterButton" id="RegisterButton" value="{'Sign up'|i18n('ezteamroom/teamroom','Button')}" tabindex="1" />
        </div>
            <input type="hidden" name="RedirectURI" value={$node.url_alias} />
    </form >
        <p>
        {'You are not logged in or you do not have access. Please use your existing user account (login and password combination) and press the "Login" button. If you do not have a user account yet, you can press the "Sign up" button to register yourself.'|i18n( 'ezteamroom/teamroom' )}
        </p>
    </div>

{elseif and( $is_group_member, count( $node.children )|gt( 0 ) )}

{def $prefs = ezpreference( concat( "personalfrontpage_widgetlist_", $node.node_id ) )}

{if $prefs|not}

    {set $prefs = $node.object.data_map.default_arrangement.value}

{/if}

{def $user_template    = ezini( "WidgetTemplateSettings",   "UseUserTemplate",               "personalfrontpage.ini" )
     $show_attributes  = ezini( "WidgetTemplateSettings",   "ShowAttributeFromContentClass", "personalfrontpage.ini" )
     $show_as_list     = ezini( "WidgetSettings",           "ShowAsList",                    "personalfrontpage.ini" )
     $disabled_widgets = ezini( "WidgetSettings",           "DisabledContentClasses",        "personalfrontpage.ini" )
     $box_overflow     = ezini( "WidgetSettings",           "BoxCSSOverflow",                "personalfrontpage.ini" )
     $widget_desc_attr = ezini( "WidgetOverview",           "WidgetDescriptionAttribute",    "personalfrontpage.ini" )
     $debug            = ezini( "PersonalFrontpage",        "JSDebug",                       "personalfrontpage.ini" )
     $container_name   = "DragContainer"
     $debug_enabled    = "false"
     $object         = false()
     $id             = false()
     $view_found     = false()
     $num_of_columns = 4
     $minimization   = true()
     $list_name      = $node.object.data_map.name.value}

{if $debug|eq( "enabled" )}

  {def $debug_enabled = "true"}

{/if}

{* cache-block keys=array( $node.node_id, $current_user.contentobject_id ) *}   {* ab: Commented out to find a better way instead of using ttl if possible *}

<div id="selectColumnPopup" style="display:none">
    <div class="border-left">
    <div class="border-right">
    <div class="border-content">
        <span>{"Insert into column:"|i18n('ezteamroom/teamroom')}</span>
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
    <h2>{"Available widgets:"|i18n('ezteamroom/teamroom')}</h2>
    <a class="close-button" href="javascript:closeAvaibleWidgets();"></a>
    </div></div></div>
    <div class="border-ml">
    {** /BOX **}

    <div class="content">

    <ul>
    {def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
         $box_folder       = false()
         $access_array     = array()
         $image_parameters = hash( 'size', 'tiny' )
         $box_folder_list  = fetch( 'content', 'list', hash( 'parent_node_id',     $node.node_id,
                                                             'class_filter_type',  'include',
                                                             'class_filter_array', array( $class_identifier_map['boxfolder'] ) ) )}

    {undef $class_identifier_map}
    {if $box_folder_list|count}
         {set $box_folder=$box_folder_list.0}
    {/if}
    {if $box_folder.children|count}
    {foreach $box_folder.children as $key => $relation}
        {set $object = $relation.object}

        {if $relation.data_map.check_access.has_content}
            {set $access_array = $relation.data_map.check_access.content|explode( '/' )}
            {if and( is_array($access_array), count($access_array)|eq(2) )}
                {if fetch( 'user', 'has_access_to', hash( 'module',   $access_array.0, 'function', $access_array.1, 'subtree', $node.path_string ) )|not()}
                    {continue}
                {/if}
            {/if}
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
 <a href="javascript:showAvaibleWidgets()" id="addNewWidgetButton" class="pfd_offset">{"Add new widget"|i18n('ezteamroom/teamroom')}</a>
</div>

<div id="TempContainer" style="display:none">

    {if $box_folder.children|count}
    {foreach $box_folder.children as $relation}
        {set $object = $relation.object}
        {set $id     = $relation.class_identifier}

    {if $relation.data_map.check_access.has_content}
        {set $access_array = $relation.data_map.check_access.content|explode( '/' )}
        {if and( is_array($access_array), count($access_array)|eq(2) )}
            {if fetch( 'user', 'has_access_to', hash( 'module',   $access_array.0, 'function', $access_array.1, 'subtree', $node.path_string ) )|not()}
                {continue}
            {/if}
        {/if}
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
                {node_view_gui view="pf_box" content_node=$relation addStringToURL=$widgetURLParameter}

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
{undef $access_array}

<div class="ContainerContainer">
{for 1 to $num_of_columns as $column_counter}
    <div class="DragContainer" id="{$container_name}{$column_counter}">&nbsp;</div>
{/for}
</div>

<br style="clear:both" />

{if $debug_enabled|eq( "true" )}
<fieldset>
    <legend>{"Debug"|i18n('ezteamroom/teamroom')}</legend>
    <div class="history" id="History"></div>
</fieldset>
{/if}

<div id="DragHelper" style="position:absolute; display:none;"></div>
<div id="PFLoadingError" style="display:none">
    <div class="box-loading-error">
        <h3>{'Error loading box'|i18n("ezteamroom/teamroom")}</h3>
        <input type="button" class="text-button" value="{"Reload"|i18n('ezteamroom/teamroom')}"
               onclick="javascript:LoadModule( '#ID#' );" />
    </div>
</div>
<div id="PFAccessDenied" style="display:none">
    <div class="box-loading-error">
        <h3>{'Access Denied'|i18n("ezteamroom/teamroom")}</h3>
        <p>{"You are not logged in or you do not have access."|i18n("ezteamroom/teamroom")}</p>
        <p><a href={"/user/register"|ezurl} title="{"Please register here"|i18n("ezteamroom/teamroom")}">{"Please register here."|i18n("ezteamroom/teamroom")}</a></p>
        <p><a href={"/user/login"|ezurl} title="{"Login here"|i18n("ezteamroom/teamroom")}">{"Login here."|i18n("ezteamroom/teamroom")}</a></p>
    </div>
</div>

{* /cache-block *}   {* ab: Commented out to find a better way instead of using ttl if possible *}

{* cache-block keys=array( $node.node_id, $prefs, $current_user.contentobject_id ) *}   {* ab: Commented out to find a better way instead of using ttl if possible *}

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
{"You have to enable JavaScript in your web browser."|i18n('ezteamroom/teamroom')}
</div>
</noscript>

{* /cache-block *}   {* ab: Commented out to find a better way instead of using ttl if possible *}

{elseif fetch( 'content', 'list_count', hash( 'parent_node_id',    $node.node_id, 'limitation', array()))|eq(0)}

    <div class="attribute-join float-break">
        <h2>{'The teamroom has not been setup yet.'|i18n( 'ezteamroom/teamroom' )}</h2>
        <p>{'Please be patient. The teamroom should be ready in a few minutes.'|i18n( 'ezteamroom/teamroom' )}</p>
    </div>

{elseif join_teamroom_in_progress($node.node_id, $current_user.contentobject_id )}

    <div class="attribute-join float-break">
        <h2>{'Membership in progess.'|i18n( 'ezteamroom/teamroom' )}</h2>
        <p>{'Your membership request is in progress. An Email will send to you when your membership has been approved by a moderator.'|i18n( 'ezteamroom/teamroom' )}</p>
    </div>

{else}

    {def   $infoText = 'A membership is required to access this teamroom. If you want to become a member of this teamroom you can request a membership for this teamroom. After a moderator has approved your membership you will get further access to this teamroom.'|i18n( 'ezteamroom/teamroom' )
         $buttonText = 'Request membership'|i18n( 'ezteamroom/teamroom' )}

    {if $is_public}

        {set   $infoText = 'Even if this is a public teamroom and you can read most of its content, it is possible to join this teamroom to become a permanent member. This will enable to better participate in teamroom activities. After you have joined this teamroom you will be able to make use of the teamroom.'|i18n( 'ezteamroom/teamroom' )
             $buttonText = 'Join this teamroom'|i18n( 'ezteamroom/teamroom' )}

    {/if}

    <div class="attribute-join float-break">
        <form method="post" action={concat( "/teamroom/register/", $node.object.id )|ezurl()}>
         <input class="button" type="submit" value="{$buttonText|wash()}"/>
        </form>
        <p>

    {$infoText|wash()}

        </p>
    </div>

{/if}

</div>
</div>