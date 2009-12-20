<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-browse">

{if is_set($browse.inviteUserList)}
{include uri='design:teamroom/invite.tpl'
         from_page=$browse.from_page
         inviteUserList=$browse.inviteUserList
         inviteUserListString=$browse.inviteUserListString
         createUserList=$browse.createUserList
         createUserListString=$browse.createUserListString}
{/if}

{def $number_of_items=10
     $browse_list_count=fetch( content, list_count, hash( parent_node_id, $node_id, depth, 1 ) )
     $node_array=fetch( content, list, hash( parent_node_id, $node_id, depth, 1, offset, $view_parameters.offset, limit, $number_of_items, sort_by, $main_node.sort_array ) )
     $select_name='SelectedObjectIDArray'
     $select_type='checkbox'
     $select_attribute='contentobject_id'}
{if eq( $browse.return_type, 'NodeID' )}
    {set $select_name='SelectedNodeIDArray'}
    {set $select_attribute='node_id'}
{/if}
{if eq( $browse.selection, 'single' )}
    {set $select_type='radio'}
{/if}

<form name="browse" action={$browse.from_page|ezurl} method="post">

{if $browse.description_template}
    {include name=Description uri=$browse.description_template browse=$browse main_node=$main_node}
{else}
    <div class="attribute-header">
    <h1 class="long">{'Browse'|i18n( 'ezteamroom/browse' )} - {$main_node.name|wash}</h1>
    </div>

    <p>{'To select objects, choose the appropriate radiobutton or checkbox(es), and click the "Select" button.'|i18n( 'ezteamroom/browse' )}</p>
    <p>{'To select an object that is a child of one of the displayed objects, click the parent object name to display a list of its children.'|i18n( 'ezteamroom/browse' )}</p>
{/if}

{def $current_node=fetch( content, node, hash( node_id, $browse.start_node ) )}
{if $browse.start_node|gt( 1 )}
    <h2 class="context-title">
    <a href={concat( '/content/browse/', $main_node.parent_node_id, '/' )|ezurl}><img src={'back-button-16x16.gif'|ezimage} alt="{'Up'|i18n( 'ezteamroom/browse' )|wash()}" /></a>
    {$current_node.name|wash}&nbsp;[{$current_node.children_count}]</h2>
{else}
    <h2 class="context-title"><img src={'back-button-16x16.gif'|ezimage} alt="{'Up'|i18n( 'ezteamroom/browse' )|wash()}" />&nbsp;{'Top level'|i18n( 'ezteamroom/browse' )}&nbsp;[{$current_node.children_count}]</h2>
{/if}

{include uri='design:content/browse_mode_list.tpl'}

{include name=Navigator
         uri='design:navigator/google.tpl'
         page_uri=concat('/content/browse/',$main_node.node_id)
         item_count=$browse_list_count
         view_parameters=$view_parameters
         item_limit=$number_of_items}


{if $browse.persistent_data|count()}
{foreach $browse.persistent_data as $key => $data_item}
    <input type="hidden" name="{$key|wash}" value="{$data_item|wash}" />
{/foreach}
{/if}

<input type="hidden" name="BrowseActionName" value="{$browse.action_name}" />
{if $browse.createUserListString}
<input type="hidden" name="createUserList" value="{$browse.createUserListString}" />
{/if}
{if $browse.browse_custom_action}
<input type="hidden" name="{$browse.browse_custom_action.name}" value="{$browse.browse_custom_action.value}" />
{/if}

    <div class="buttonblock">
            <input class="button" type="submit" name="SelectInviteUsersButton" value="{'Select'|i18n('ezteamroom/browse')}" />
            {if $cancel_action}
            <input type="hidden" name="BrowseCancelURI" value="{$cancel_action}" />
            {/if}
            <input class="button" type="submit" name="BrowseCancelButton" value="{'Cancel'|i18n( 'ezteamroom/browse' )}" />
</div>
</form>

</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
