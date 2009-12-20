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

{def        $current_user = fetch( 'user', 'current_user' )
            $current_text = ''
     $current_lightbox_id = ezpreference( 'currentLightboxID' )
            $shorten_size = 35}

{if $current_lightbox_id|gt( 0 )}

    {set $current_text = concat( '<br />(', 'current'|i18n( 'ezteamroom/lightbox' )|wash(), ')')}

{/if}

{if $current_user.is_logged_in}

<h4>{'My lightboxes'|i18n( 'ezteamroom/lightbox' )}</h4>
{if and( is_array( $userLightboxList ), $userLightboxList|count()|gt( 0 ) )}
    <ul>
    {foreach $userLightboxList as $lightbox sequence array( 'bglight', 'bgdark' ) as $bg}
        <li>
        {if $lightboxID|eq( $lightbox.id )}
            {$lightbox.name|shorten( $shorten_size )|wash()}{if $lightbox.id|eq( $current_lightbox_id )}{$current_text}{/if}
        {else}
            <a href={concat( '/lightbox/view/list/', $lightbox.id)|ezurl()}>{$lightbox.name|shorten( $shorten_size )|wash()}{if $lightbox.id|eq( $current_lightbox_id )}{$current_text}{/if}</a>
        {/if}
        </li>
    {/foreach}
    </ul>
{else}

    <p>{'You do not have any lightbox yet.'|i18n( 'ezteamroom/lightbox' )}</p>

{/if}

<h4>{'Other lightboxes'|i18n( 'ezteamroom/lightbox' )}</h4>
{if and( is_array( $otherLightboxList ), $otherLightboxList|count()|gt( 0 ) )}
    <ul>
    {foreach $otherLightboxList as $lightbox sequence array( 'bglight', 'bgdark' ) as $bg}

        {if $lightbox.id|eq( $current_lightbox_id )}

            {set $current_text = concat( '<br />(', $lightbox.owner.contentobject.name|wash(), ', ', 'current'|i18n( 'ezteamroom/lightbox' ), ')')}

        {else}

            {set $current_text = concat( '<br />(', $lightbox.owner.contentobject.name|wash(), ')')}

        {/if}

        <li>
        {if $lightboxID|eq( $lightbox.id )}
            {$lightbox.name|shorten( $shorten_size )|wash()}{if $lightbox.id|eq( $current_lightbox_id )}{$current_text}{/if}
        {else}
            <a href={concat( '/lightbox/view/list/', $lightbox.id)|ezurl()} title="{'View this lightbox owned by %1'|i18n( 'ezteamroom/lightbox', , hash( '%1', $lightbox.owner.contentobject.name|wash() ) )}">{$lightbox.name|shorten( $shorten_size )|wash()}{if $lightbox.id|eq( $current_lightbox_id )}{$current_text}{/if}</a>
        {/if}
        </li>
    {/foreach}
    </ul>
{else}
    <p>{'You do not have access to other lightboxes yet.'|i18n( 'ezteamroom/lightbox' )}</p>
{/if}

{if is_object( $selectedLightbox )}
<h4>{'Current lightbox'|i18n( 'ezteamroom/lightbox' )} "{$selectedLightbox.name|wash()}"</h4>
    {def $isForeignLightbox = $selectedLightbox.owner_id|ne( $currentUserID )}
    {if $isForeignLightbox}
        <strong>{'Owner'|i18n( 'ezteamroom/lightbox' )}:</strong>
        {$selectedLightbox.owner.contentobject.name|wash()}
    {/if}
    {if $selectedLightbox.item_id_list|count()|gt( 0 )}
        {def $content_object = false()}
        <ul>
        {foreach $selectedLightbox.item_id_list as $item_id => $type_id sequence array( 'bglight', 'bgdark' ) as $bg}
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
        </ul>
    {else}
        <p>{'This lightbox is empty.'|i18n( 'ezteamroom/lightbox' )}</p>
    {/if}
{/if}

<div class="infobox-link">
 <form class="inline" action={'/lightbox/create'|ezurl()} method="post">
    <div class="add-current-page">
        <input type="hidden" name="redirectURI" value="/" />
        <input type="submit"
               class="add-current-page-button"
               title="{'Create new lightbox'|i18n( 'ezteamroom/lightbox' )}"
               value="{'Create new lightbox'|i18n( 'ezteamroom/lightbox' )}"
               name="CreateNewLightbox" style="font-weight: bold;" />
    </div>
 </form>
</div>

{else}
    <p>{"You are not logged in."|i18n("ezteamroom/lightbox")}</p>
    <p><a href={"/user/register"|ezurl} title="{"Please register here"|i18n("ezteamroom/lightbox")}">{"Please register here."|i18n("ezteamroom/lightbox")}</a></p>
    <p><a href={"/user/login"|ezurl} title="{"Login here"|i18n("ezteamroom/lightbox")}">{"Login here."|i18n("ezteamroom/lightbox")}</a></p>
{/if}

</div>
</div>

{if $hasPFBox}

</div>

{/if}

