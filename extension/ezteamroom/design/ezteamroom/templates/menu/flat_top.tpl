{* set-block scope=root variable=cache_ttl}0{/set-block *} {* ab: Commented out to find a better way if possible *}

{def $teamroom_node_id = false()
     $teamroom_node    = false()
            $path_node = false()}

{if and( ezhttp_hasvariable( 'CurrentTeamroom', 'session' ), or( $nodeDepth|gt( 2 ), $nodeDepth|not() ) )}

    {set $teamroom_node_id = ezhttp( 'CurrentTeamroom', 'session' )
            $teamroom_node = fetch( 'content', 'node', hash( 'node_id', $teamroom_node_id ) )}

{elseif $classIdentifier|eq( $class_identifier_map['teamroom'] )}

    {set $teamroom_node_id = $module_result.content_info.node_id
            $teamroom_node = fetch( 'content', 'node', hash( 'node_id', $teamroom_node_id ) )}

{else}

    {foreach $module_result.path as $path_node_info}
        {if is_set($path_node_info.node_id)}
            {set $path_node = fetch( 'content', 'node', hash( 'node_id', $path_node_info.node_id ) )}

            {if and($path_node,$path_node.class_identifier|eq( $class_identifier_map['teamroom'] ))}

                {set $teamroom_node_id = $path_node.node_id}

                {break}

            {/if}
        {/if}
    {/foreach}

{/if}

{undef $path_node}

{if and( $teamroom_node|eq(false()), $teamroom_node_id|ne(false()) )}

    {set $teamroom_node = fetch( 'content', 'node', hash( 'node_id', $teamroom_node_id ) )}

{/if}

{undef $teamroom_node_id}

{if $teamroom_node}

<div class="topmenu-design">
 <ul>

    {def $top_menu_items = fetch( 'content', 'list', hash( 'parent_node_id', $teamroom_node.node_id,
                                                           'class_filter_type', 'include',
                                                           'class_filter_array', ezini( 'MenuContentSettings', 'TopIdentifierList', 'menu.ini' ),
                                                           'sort_by', $teamroom_node.sort_array
                                                         )
                                )
        $top_menu_items_count = $top_menu_items|count()
        $current_node_in_path = cond( and( $current_node_id, gt( $module_result.path|count, $pagerootdepth ) ), $module_result.path[$pagerootdepth].node_id, 0 )
         $current_path_string = '/1/'
         $item_class = false()}

    {foreach $module_result.path as $pathitem}

        {set $current_path_string = concat( $current_path_string, $pathitem.node_id, '/' )}

    {/foreach}

    {if $top_menu_items_count}

        {foreach $top_menu_items as $key => $item}

            {set $item_class = cond( $current_node_in_path|eq( $item.node_id ), array( "selected" ), array() )}

            {if $key|eq( 0 )}

                {set $item_class = $item_class|append("firstli")}

            {/if}

            {if $top_menu_items_count|eq( $key|inc )}

                {set $item_class = $item_class|append("lastli")}

            {/if}

            {if or( $item.node_id|eq( $current_node_id ),
                    $current_path_string|contains( $item.path_string ) )}

                {set $item_class = $item_class|append("current")}

            {/if}

            {if eq( $item.class_identifier, 'link' )}

  <li id="node_id_{$item.node_id}"{if $item_class} class="{$item_class|implode(" ")}"{/if}>
   <div>
    <a href={if eq( $ui_context, 'browse' )}{concat("content/browse/", $item.node_id)|ezurl}{else}{$item.data_map.location.content|ezurl}{/if} target="_blank"{if eq( $ui_context, 'edit' )} onclick="return false;"{/if}><span>{$item.name|wash()}</span></a>
   </div>
  </li>

            {else}

  <li id="node_id_{$item.node_id}"{if $item_class} class="{$item_class|implode(" ")}"{/if}>
   <div>
    <a href={if eq( $ui_context, 'browse' )}{concat("content/browse/", $item.node_id)|ezurl}{else}{$item.url_alias|ezurl}{/if}{if eq( $ui_context, 'edit' )} onclick="return false;"{/if}><span>{$item.name|wash()}</span></a>
   </div>
  </li>

            {/if}

        {/foreach}

    {/if}

    {undef $top_menu_items $item_class $top_menu_items_count $current_node_in_path $item_class}

 </ul>

    {if array( $class_identifier_map['teamroom'], $class_identifier_map['personal_frontpage'] )|contains( $classIdentifier )|not()}

 <div class="home-box float-break">
  <div class="home-box-icon">
   <a href={$teamroom_node.url_alias|ezurl()} title="{$teamroom_node.name|wash}">{$teamroom_node.name|wash()|shorten( 17, '...' )}</a>
  </div>

        {if is_set($module_result.content_info.node_id)}

            {def $lightbox_count              = fetch( 'lightbox', 'count' )
                 $current_lightbox_id         = ezpreference( 'currentLightboxID' )
                 $current_lightbox            = false()
                 $current_lightbox_item_count = 0
                 $can_create_lightbox         = fetch( 'user', 'has_access_to',
                                                       hash( 'module', 'lightbox', 'function', 'create' )
                                                     )}

            {if $current_lightbox_id|gt( 0 )}

                {set $current_lightbox            = fetch( 'lightbox', 'object', hash( 'id', $current_lightbox_id, 'asObject', true ) )
                     $current_lightbox_item_count = $current_lightbox.item_count}

            {/if}

            {include uri = 'design:lightbox/lightbox-head.tpl' lightbox_count = $lightbox_count}

        {/if}

 </div>

    {/if}

</div>

{/if}

{undef $teamroom_node}