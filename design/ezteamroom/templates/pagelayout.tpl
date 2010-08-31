<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

{def $current_node_id             = first_set( $module_result.node_id, 0 )
     $user_hash                   = concat( $current_user.role_id_list|implode( ',' ), ',', $current_user.limited_assignment_value_list|implode( ',' ) )
     $lightboxSessionKey          = false()
     $classIdentifier      = first_set( $module_result.content_info.class_identifier, false() )}

{if and( $current_node_id|eq( 0 ), is_set( $module_result.path.0 ) , is_set( $module_result.path[$module_result.path|count()|dec()].node_id ) )}

    {set $current_node_id = $module_result.path[$module_result.path|count()|dec()].node_id}

{/if}

{if ezhttp_hasvariable( 'lightboxSessionKey', 'session' )|not()}

    {set $lightboxSessionKey = fetch( 'lightbox', 'sessionKey' )}

{else}

    {set $lightboxSessionKey = ezhttp( 'lightboxSessionKey', 'session' )}

{/if}

{cache-block keys = array( $uri_string, $current_node_id, $site.http_equiv.Content-language, $classIdentifier, $ui_context )
             ignore_content_expiry
             expiry = 604800}

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="{$site.http_equiv.Content-language|wash}" lang="{$site.http_equiv.Content-language|wash}">
 <head>

     {include uri = 'design:page_head.tpl'}
     {include uri='design:page_head_style.tpl'}
     {include uri='design:page_head_script.tpl'}

 </head>
 <body>

    {def $pagestyle            = 'nosidemenu noextrainfo'
         $path_normalized      = ''}

    {if ezini( 'MenuSettings', 'HideLeftMenuClasses', 'menu.ini' )|contains( $classIdentifier )}

        {set $pagestyle = 'nosidemenu noextrainfo'}

    {elseif and( eq( $ui_context, 'edit' ), $uri_string|contains( "content/versionview" )|not() )}

        {set $pagestyle = 'nosidemenu noextrainfo'}

    {elseif eq( $ui_context, 'browse' )}

        {set $pagestyle = 'nosidemenu noextrainfo'}

    {elseif $current_node_id}

        {if is_set( $module_result.path[1] )}

            {set $pagestyle = 'sidemenu extrainfo'}

        {/if}

    {/if}

    {if is_set( $module_result.section_id )}

        {set $pagestyle = concat( $pagestyle, " section_id_", $module_result.section_id )}

    {/if}

    {foreach $module_result.path as $index => $path}

        {if is_set( $path.node_id )}

            {set $path_normalized = $path_normalized|append( concat('subtree_level_', $index, '_node_id_', $path.node_id, ' ' ) )}

        {/if}

    {/foreach}

    {set $pagestyle = 'nosidemenu noextrainfo'}

  <div id="page" class="{$pagestyle} {$path_normalized|trim()} current_node_id_{$current_node_id}">
   <div id="header" class="float-break">

    {undef $pagestyle $path_normalized}

{/cache-block}

{include uri = 'design:parts/header.tpl'}

{cache-block ignore_content_expiry
             keys           = array( $uri_string, $current_node_id, $classIdentifier, $ui_context, $lightboxSessionKey )
             expiry         = 604800
             subtree_expiry = concat( '/content/view/full/', $current_node_id )}

    {def $pagerootdepth        = ezini( 'SiteSettings', 'RootNodeDepth', 'site.ini' )
         $nodeDepth            = first_set( $module_result.content_info.node_depth, false() )
         $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}

    {if $pagerootdepth|not()}

        {set $pagerootdepth = 1}

    {/if}

  </div>
  <div id="path_search" class="float-break">
   <div id="path">

    {include uri = 'design:parts/path.tpl'}

   </div>
   <div id="searchbox">
    <form action={"/content/search"|ezurl}>
     <label for="searchtext">{'Search'|i18n( 'ezteamroom/search' )}</label>

    {if eq( $ui_context, 'edit' )}

     <input id="searchtext" name="SearchText" type="text" value="" size="12" disabled="disabled" />
     <input id="searchbutton" class="button-disabled" type="submit" value="{'Go'|i18n('ezteamroom/search')}" alt="Submit" disabled="disabled" />

    {else}

     <input id="searchtext" name="SearchText" type="text" value="" size="12" />
     <input id="searchbutton" type="submit" value="{'Go'|i18n('ezteamroom/search')}" alt="Submit" />
     <input type="hidden" name="SubTreeArray" value="{ezini( 'TeamroomSettings', 'TeamroomPoolNodeID', 'teamroom.ini' )}" />

        {if eq( $ui_context, 'browse' )}

     <input name="Mode" type="hidden" value="browse" />

        {/if}

    {/if}

    </form>
   </div>
  </div>
  <div id="topmenu" class="float-break">

    {include uri = 'design:menu/flat_top.tpl' classIdentifier = $classIdentifier
             class_identifier_map = $class_identifier_map nodeDepth = $nodeDepth
             pagerootdepth = $pagerootdepth}

  </div>
  <div id="columns" class="float-break">
   <div id="sidemenu-position">
    <div id="sidemenu"></div>
   </div>
   <div id="main-position">
    <div id="main" class="float-break">
     <div class="overflow-fix">

    {undef $pagerootdepth $class_identifier_map $nodeDepth}

{/cache-block}

{$module_result.content}

{cache-block ignore_content_expiry
             keys    = array( $uri_string, $access_type.name, $current_node_id )
             expiry = 604800}

     </div>
    </div>
   </div>
   <div id="extrainfo-position">
    <div id="extrainfo">

    {if $current_node_id}

     <div class="teamroom_drag_container" id="FPDragContainer2"></div>

    {/if}

     </div>
    </div>
   </div>
  </div>

{/cache-block}

  <!--DEBUG_REPORT-->
 </body>
</html>