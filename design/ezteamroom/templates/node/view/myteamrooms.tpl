{def $teamroom_pool_id     = ezini( 'TeamroomSettings', 'TeamroomPoolNodeID', 'teamroom.ini' )
     $teamroom_class_id    = ezini( 'TeamroomSettings', 'TeamroomClassID', 'teamroom.ini' )
     $teamroom_pool_node   = fetch( 'content', 'node', hash( 'node_id', $teamroom_pool_id ) )
     $teamroom_pool_object = $teamroom_pool_node.object
     $can_create_team_room = false()
     $current_user         = fetch( 'user', 'current_user' )
     $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
     $hasPFBox             = false()}

{if is_set( $view_parameters.pfbox )}

    {if $view_parameters.pfbox|eq( '1' )}

        {set $hasPFBox = true()}

<!--PFBOXCONTENT-->
<div class="pf_box">

    {/if}

{/if}

<div class="teamroom-list itemized_sub_items">
<div class="content-view-embed">

    <div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

{def $children  = fetch( content, list, hash( 'parent_node_id', $node.node_id,
                                              'class_filter_type', 'include',
                                              'class_filter_array', array( $class_identifier_map['teamroom'] ),
                                              'sort_by', $node.sort_array ) )
    $ownerships = array()}

{undef $class_identifier_map}

{if $current_user.is_logged_in}
    {foreach $children as $child}
        {if $child.object.owner_id|eq( $current_user.contentobject_id )}
            {set $ownerships=$ownerships|append($child)}
            {continue}
        {/if}

        {def $members=fetch( 'content', 'tree', hash( 'parent_node_id',     $child.node_id,
                                                      'limitation',         array(),
                                                      'class_filter_type',  'include',
                                                      'class_filter_array', array( 'user' ) ) )}
        {foreach $members as $member}
            {if $member.object.id|eq( $current_user.contentobject_id )}
                {if $ownerships|contains($child)|not}
                    {set $ownerships=$ownerships|append($child)}
                {/if}
                {continue}
            {/if}
        {/foreach}
        {undef $members}
    {/foreach}
    {if $ownerships|count()}
        <ul>
        {foreach $ownerships as $child}
            <li><div><a href={$child.url_alias|ezurl}>{node_view_gui content_node=$child view='listitem'}</a></div></li>
        {/foreach}
        </ul>
    {else}
        <p>{"You are not a member of any teamroom."|i18n("ezteamroom/teamroom")}</p>
    {/if}
{else}
    <p>{"You are not logged in or you do not have access."|i18n("ezteamroom/teamroom")}</p>
    <p><a href={"/user/register"|ezurl} title="{"Please register here"|i18n("ezteamroom/teamroom")}">{"Please register here."|i18n("ezteamroom/teamroom")}</a></p>
    <p><a href={"/user/login"|ezurl} title="{"Login here"|i18n("ezteamroom/teamroom")}">{"Login here."|i18n("ezteamroom/teamroom")}</a></p>
{/if}

    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>

</div>
</div>

{if $hasPFBox}

</div>

{/if}
