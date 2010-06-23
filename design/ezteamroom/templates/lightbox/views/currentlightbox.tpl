{def $hasPFBox = false()}

{if is_set( $viewParameters.pfbox )}

    {if $viewParameters.pfbox|eq( '1' )}

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

{def $current_user        = fetch( 'user', 'current_user' )
     $current_lightbox_id = ezpreference( 'currentLightboxID' )
     $current_lightbox    = false()}

{if $current_user.is_logged_in}
    {if $current_lightbox_id|gt( 0 )}
        {set $current_lightbox = fetch( 'lightbox', 'object', hash( 'id', $current_lightbox_id, 'asObject', true ) )}
    {/if}
    {if is_object( $current_lightbox )}
        {def $isForeignLightbox = $current_lightbox.owner_id|ne( $current_user.contentobject_id )}

        <strong>{$current_lightbox.name|shorten( 30 )|wash()}</strong>
        {if $isForeignLightbox}<div class="lightbox-owner">( {$current_lightbox.owner.contentobject.name|wash()} )</div>{/if}

        {if $current_lightbox.item_id_list|count()|gt( 0 )}
            {def $content_object = false()
                    $item_object = false()}
            <ul>
            {foreach $current_lightbox.item_id_list as $item_id => $type_id sequence array( 'bglight', 'bgdark' ) as $bg}
                {if $type_id|eq( 1 )}
                    {set $content_object = fetch( 'content', 'object', hash( 'object_id', $item_id ) )
                         $object_id      = $item_id}
                {elseif $type_id|eq( 2 )}
                    {set $item_object    = fetch( 'content', 'node', hash( 'node_id', $item_id ) )
                         $content_object = $item_object.object
                         $object_id      = $item_object.object.id}
                {/if}
                {if is_object( $content_object )}
                    <li>
                    {if eq( $content_object.node.class_identifier, 'file' )}
                        {attribute_view_gui attribute=$content_object.main_node.data_map.file shorten=20}
                    {else}
                        <a href={$content_object.main_node.url_alias|ezurl}>{node_view_gui content_node=$content_object.main_node view='listitem'}</a>
                    {/if}
                    </li>
                {/if}
            {/foreach}
            {undef $content_object $item_object}
            </ul>
        {else}
            <p>{'This lightbox is empty.'|i18n( 'ezteamroom/lightbox' )}</p>
        {/if}
    {else}

        {def $teamroomNode = false()}

        {if is_set( $viewParameters.teamroomNodeID )}

            {set $teamroomNode = fetch( 'content', 'node', hash( 'node_id', $viewParameters.teamroomNodeID ) )}

        {/if}

        <p>{'You do not have a current lightbox yet.'|i18n( 'ezteamroom/lightbox' )}</p>
<div class="infobox-link">
 <form class="inline" action={'/lightbox/create'|ezurl()} method="post">
    <div class="add-current-page">

        {if and( is_object( $teamroomNode ), is_set( $teamroomNode.url_alias ), $teamroomNode.url_alias|ne( '' ) )}

        <input type="hidden" name="redirectURI" value="{$teamroomNode.url_alias}" />

        {else}

        <input type="hidden" name="redirectURI" value="/" />

        {/if}

        <input type="submit"
               class="add-current-page-button"
               title="{'Create new lightbox'|i18n( 'ezteamroom/lightbox' )}"
               value="{'Create new lightbox'|i18n( 'ezteamroom/lightbox' )}"
               name="CreateNewLightbox" style="font-weight: bold;" />
    </div>
 </form>
</div>

    {/if}
{else}
    <p>{"You are not logged in."|i18n("ezteamroom/lightbox")}</p>
    <p><a href={"/user/register"|ezurl} title="{"Please register here"|i18n("ezteamroom/lightbox")}">{"Please register here."|i18n("ezteamroom/lightbox")}</a></p>
    <p><a href={"/user/login"|ezurl} title="{"Login here"|i18n("ezteamroom/lightbox")}">{"Login here."|i18n("ezteamroom/lightbox")}</a></p>
{/if}

    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>
</div>
</div>

{if $hasPFBox}

</div>

{/if}

