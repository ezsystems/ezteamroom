{def $lightboxList  = fetch( 'lightbox', 'list', hash( 'sortBy', hash( 'name', 'ASC' ), 'asObject', true() ) )
     $hasLightboxes = $lightboxList|count()|gt( 0 )
      $current_node = false()
           $hasNode = and( is_set( $current_node_id ), is_numeric( $current_node_id ), $current_node_id|gt( 0 ) )
       $redirectURI = ''}

{if $hasNode}

    {set $current_node = fetch( 'content', 'node', hash( 'node_id', $current_node_id ) )}

    {if is_object( $current_node )|not()}

        {set      $hasNode = false()
             $current_node = false()}

    {/if}

{/if}

{if and( $hasNode, is_set( $current_node.url_alias ), $current_node.url_alias|ne( '' ) )}

    {set $redirectURI = $current_node.url_alias}

{elseif and( is_set( $module_result.uri ), $module_result.uri|ne( '' ) )}

    {set $redirectURI = $module_result.uri}

{/if}

<script type="text/javascript">
var gActivateExtension = true;
var gInitializeEventsOnly = true;
var gDebugEnabled = false;
</script>

<div class="home-box-favs">
<div id="lightbox-settings-button">
    <a href="javascript:toggleLightboxSettings()">
        {if $current_lightbox}
        <span class="lightbox-name">{$current_lightbox.name|wash()|shorten( 12 )} ({$current_lightbox.item_count})</span>
        {else}
        <span class="no-lightbox">{"No Lightbox"|i18n( 'ezteamroom/lightbox' )}</span>
        {/if}
    </a>
</div>
</div>

<div id="lightbox-settings" style="display:none">
<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc">


<form action={'/content/action'|ezurl()} method="post" id="hiddensubmitform">
    <input type="hidden" name="ContentObjectID" value="0" />
    <input type="hidden" name="newLightboxID"   value="0" id="newLightboxIDInput" />
    <input type="hidden" name="redirectAfterSelectionURI" value="{$redirectURI}" />
    <input type="hidden" name="ChangeUserCurrentLightbox" value="1" />
</form>

<form action={'/content/action'|ezurl()} method="post">
    <input type="hidden" name="ContentObjectID" value="0" />
    <input type="hidden" name="redirectURI" value="{$redirectURI}" />
    <div class="close-button">
        <a href="#" onclick="toggleLightboxSettings()">{'close'|i18n( 'ezteamroom/lightbox' )}</a>
    </div>

    <h3>{'Current Lightbox'|i18n( 'ezteamroom/lightbox' )}:</h3>
    <span class="current-lightbox">{$current_lightbox.name|shorten( 27 )|wash()}</span>

    <div class="lightbox-buttons">
    {if $hasLightboxes}
        {if $current_lightbox.can_edit}
        <input type="image" src={'lightbox/action_lightbox_edit_medium.png'|ezimage()} alt="{'Edit'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to edit the current lightbox.'|i18n( 'ezteamroom/lightbox' )}" class="lightbox-action" name="EditLightboxAction" />
        <input type="image" src={'lightbox/action_lightbox_delete_medium.png'|ezimage()} alt="{'Delete'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to delete the current lightbox.'|i18n( 'ezteamroom/lightbox' )}" class="lightbox-action" name="DeleteLightboxAction" onclick="return confirm( '{'Are you sure you want to delete this lightbox?'|i18n( 'ezteamroom/lightbox' )}' )" />
        {else}
        <input type="image" src={'lightbox/action_lightbox_edit_medium.png'|ezimage()} alt="{'Edit'|i18n( 'ezteamroom/lightbox' )}" title="{'You are not allowed to edit the current lightbox.'|i18n( 'ezteamroom/lightbox' )}" class="lightbox-action" name="EditLightboxAction" disabled="disabled" />
        <input type="image" src={'lightbox/action_lightbox_delete_medium.png'|ezimage()} alt="{'Delete'|i18n( 'ezteamroom/lightbox' )}" title="{'You are not allowed to delete the current lightbox.'|i18n( 'ezteamroom/lightbox' )}" class="lightbox-action" name="DeleteLightboxAction" disabled="disabled" />
        {/if}

        {if $current_lightbox.can_send}
        <input type="image" src={'lightbox/action_lightbox_send_medium.png'|ezimage()} alt="{'Send'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to send the current lightbox by email.'|i18n( 'ezteamroom/lightbox' )}" class="lightbox-action" name="SendLightboxAction" />
        {else}
        <input type="image" src={'lightbox/action_lightbox_send_medium.png'|ezimage()} alt="{'Send'|i18n( 'ezteamroom/lightbox' )}" title="{'You are not allowed to send the current lightbox by email.'|i18n( 'ezteamroom/lightbox' )}" class="lightbox-action" name="SendLightboxAction" disabled="disabled"/>
        {/if}

        {if $current_lightbox.can_view}
        <input type="image" src={'lightbox/action_lightbox_view_medium.png'|ezimage()} alt="{'Show'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to show the contents of the current lightbox.'|i18n( 'ezteamroom/lightbox' )}" class="lightbox-action" name="ViewLightboxAction" />
        {else}
        <input type="image" src={'lightbox/action_lightbox_view_medium.png'|ezimage()} alt="{'Show'|i18n( 'ezteamroom/lightbox' )}" title="{'You are not allowed to view the contents of the current lightbox.'|i18n( 'ezteamroom/lightbox' )}" class="lightbox-action" name="ViewLightboxAction" disabled="disabled" />
        {/if}
    {else}
    <img src={'lightbox/action_lightbox_edit_medium.png'|ezimage()} alt="{'Edit'|i18n( 'ezteamroom/lightbox' )}" title="{'Currently no lightbox can be edited'|i18n( 'ezteamroom/lightbox' )}" />
    <img src={'lightbox/action_lightbox_delete_medium.png'|ezimage()} alt="{'Delete'|i18n( 'ezteamroom/lightbox' )}" title="{'Currently no lightbox can be deleted.'|i18n( 'ezteamroom/lightbox' )}" />
    <img src={'lightbox/action_lightbox_send_medium.png'|ezimage()} alt="{'Send'|i18n( 'ezteamroom/lightbox' )}" title="{'Currently no lightbox can be send by email.'|i18n( 'ezteamroom/lightbox' )}" />
    <img src={'lightbox/action_lightbox_view_medium.png'|ezimage()} alt="{'Show'|i18n( 'ezteamroom/lightbox' )}" title="{'Currently no lightbox can be shown.'|i18n( 'ezteamroom/lightbox' )}" />
    {/if}
    </div>

    <hr />

    <h3>{'Change current Lightbox'|i18n( 'ezteamroom/lightbox' )}:</h3>
    {if $hasLightboxes}
        <select name="selectedLightboxID" onchange="changeCurrentLightbox();" id="lightboxselection">
        {if $current_lightbox_id|le( 0 )}
             <option disabled="disabled">{'Choose current lightbox'|i18n( 'ezteamroom/lightbox' )}</option>
        {/if}
        {def $is_own_lightbox = false()}
        {foreach $lightboxList as $lightbox}
            {set $is_own_lightbox = $lightbox.owner_id|eq( $current_user.contentobject_id )}
            <option value="{$lightbox.id}"{cond( $lightbox.id|eq( $current_lightbox_id ), ' selected="selected"' )}{cond( $is_own_lightbox, ' class="own-lightbox"' )}{cond( $lightbox.can_edit|not(), ' disabled="disabled"')}>
                {$lightbox.name|shorten( 21 )|wash()} ({$lightbox.item_count})
            </option>
        {/foreach}
        </select>
    {else}
        {'No Lightbox'|i18n( 'ezteamroom/lightbox' )}
    {/if}
</form>

<form action={'/lightbox/create'|ezurl()} method="post">
    <input type="hidden" name="redirectAfterLightboxHasBeenCreated" value="1" />
    <input type="hidden" name="redirectURI" value="{$redirectURI}" />
    <div class="create-lightbox">
    {if $can_create_lightbox}
        <input type="image" src={'lightbox/action_lightbox_new_medium.png'|ezimage()} alt="{'Create'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to create a new lightbox.'|i18n( 'ezteamroom/lightbox' )}" class="lightbox-action" name="CreateLightboxAction" />
    {else}
        <img src={'lightbox/action_lightbox_new_medium.png'|ezimage()} alt="{'Create'|i18n( 'ezteamroom/lightbox' )}" title="{'You are not allowed to create a new lightbox.'|i18n( 'ezteamroom/lightbox' )}" class="lightbox-action" name="CreateLightboxAction" />
    {/if}
    </div>
</form>

{if and( $hasLightboxes, $hasNode )}

    {def $canAdd = false()}

    {foreach $current_lightbox.can_add_class_list as $index => $classID}

        {if $current_node.object.contentclass_id|eq( $classID )}

            {set $canAdd = true()}

            {break}

        {/if}

    {/foreach}

    {if $canAdd}

<form class="inline" action={'/content/action'|ezurl()} method="post">
    <div class="add-current-page">
        <input type="hidden" name="ContentObjectID" value="{$current_node.contentobject_id}" />
        <input type="hidden" name="LightboxID"      value="{$current_lightbox.id}" />
        <input type="hidden" name="redirectURI" value="{$redirectURI}" />
        <input type="submit"
               class="add-current-page-button"
               title="{'Add this page to current Lightbox'|i18n( 'ezteamroom/lightbox' )}"
               value="{'Add this page to current Lightbox'|i18n( 'ezteamroom/lightbox' )}"
               name="AddToLightboxAction" />
    </div>
</form>

    {/if}

{/if}

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div></div>
