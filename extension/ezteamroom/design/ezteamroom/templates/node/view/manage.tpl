{def $hasPFBox = false()}

{if is_set( $view_parameters.pfbox )}

    {if $view_parameters.pfbox|eq( '1' )}

        {set $hasPFBox = true()}

<!--PFBOXCONTENT-->
<div class="pf_box">

    {/if}

{/if}

<div class="create_new_teamroom content-view-embed">
    <div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

    <div class="itemized_sub_items">
    <div class="content-view-embed">

    {if $node.can_remove}

    <form action={'/content/action'|ezurl()} id="manage_teamroom_remove_node" method="post">
     <input type="hidden" name="RemoveButton" value="1" />
     <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
     <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
     <input type="hidden" name="DeleteIDArray[]" value="{$node.node_id}" />
    </form>

    {/if}


    <ul>
    {if $node.can_edit}
        <li>
            <a href={concat("content/edit/",$node.object.id,'/f/',ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini'))|ezurl}>
                {"Modify teamroom"|i18n("ezteamroom/teamroom")}
            </a>
        </li>
    {/if}
    {if fetch( 'teamroom', 'has_access_to', hash( 'module', 'teamroom', 'function', 'manage', 'subtree', $node.path_string ) )}
        <li>
            <a href={concat("teamroom/manage/",$node.object.id)|ezurl}>
                {"Manage member"|i18n("ezteamroom/teamroom")}
            </a>
        </li>
        <li>
            <a href={concat("teamroom/invite/",$node.object.id)|ezurl}>
                {"Invite new member"|i18n("ezteamroom/teamroom")}
            </a>
        </li>
    {/if}
    {def $current_user=fetch( 'user', 'current_user' )}
    {if and( $node.object.owner.id|ne($current_user.contentobject_id), fetch( 'teamroom', 'has_access_to', hash( 'module', 'teamroom', 'function', 'resign', 'subtree', $node.path_string ) ) )}
        <li>
            <a href={concat("teamroom/resign/",$node.object.id,'/',$current_user.contentobject_id)|ezurl}>
                {"Resign from this teamroom"|i18n("ezteamroom/teamroom")}
            </a>
        </li>
    {/if}
    {if $node.can_remove}
        <li>
            <a href="javascript: document.getElementById( 'manage_teamroom_remove_node' ).submit()">
                {"Remove this teamroom"|i18n("ezteamroom/teamroom")}
            </a>
        </li>
    {/if}
    </ul>
    </div>
    </div>

    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>

</div>

{if $hasPFBox}

</div>

{/if}

