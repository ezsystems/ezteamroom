{def $lightbox = $node.data_map.lightbox.content}

<div class="file-list {$style} float-break">

    {** Download button **}
    <div class="file-list-download"></div>

    {** Bookmark/Lightbox button **}
    <div class="file-list-bookmark"></div>

    {** Versions button **}
    <div class="file-list-versions"></div>

    {** Upload new version/update button **}
    <div class="file-list-update">
        {if $node.object.can_edit}
        <form method="post" action={"/content/action/"|ezurl}>
         <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
         <input type="hidden" name="RedirectURIAfterPublish" value="{$node.parent.url_alias}" />
         <input type="hidden" name="RedirectIfDiscarded" value="{$node.parent.url_alias}" />
           <input type="image" src={'file/update.gif'|ezimage} name="EditButton" id="{concat( 'file_list_edit_submit_', $node.contentobject_id )}" title="{'Edit the entry of this lightbox'|i18n( 'ezteamroom/files' )}" />
           {* <br /><label for="{concat( 'file_list_edit_submit_', $node.contentobject_id )}" class="submitlabel">{'Edit'|i18n('ezteamroom/lightbox')}</label> *}
        </form>
        {/if}
    </div>

    {** Delete button **}
    <div class="file-list-delete">
        {if $node.object.can_remove}
        <form id="removeFile{$node.object.id}" method="post" action={"/content/action"|ezurl}>
            <input type="image" name="ActionRemove" value="x" src={'file/delete.gif'|ezimage} onclick="return confirmDelete()" id="{concat( 'file_list_remove_submit_', $node.contentobject_id )}" title="{'Edit this lightbox entry'|i18n( 'ezteamroom/files' )}" />
            {* <br /><label for="{concat( 'file_list_remove_submit_', $node.contentobject_id )}" class="submitlabel">{'Delete'|i18n('ezteamroom/lightbox')}</label> *}
            <input type="hidden" name="TopLevelNode" value="{$node.node_id}" />
            <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
            <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
            <input type="hidden" name="HideRemoveConfirmation" value="true" />
            <input type="hidden" name="RedirectURI" value="{$node.parent.url_alias}"/>
        </form>
        {/if}
    </div>

    {** Icon **}
    <div class="file-list-icon">
        <a href={concat( '/lightbox/view/list/', $lightbox.id )|ezurl()}>
           <img class="transparent-png-icon" src={'lightbox_bulb.gif'|ezimage} alt="lightbox_bulb_icon" />
        </a>
    </div>

    {** Description **}
    <div class="file-list-name"{if eq( $filelockfeature, 'enabled' )}style="width: 208px;"{/if}>
        {def $isForeignLightbox = $lightbox.owner_id|ne( $currentUserID )}
        <h4><a href={concat( '/lightbox/view/list/', $lightbox.id )|ezurl()}>
        {'Lightbox "%1"'|i18n( 'ezteamroom/lightbox', , hash( '%1', $lightbox.name ) )}</a></h4>
        {if $isForeignLightbox}
            <div class="info">
                <strong>{'Owner'|i18n( 'ezteamroom/lightbox' )}:</strong>
                {$lightbox.owner.contentobject.name|wash()}
            </div>
        {/if}
    </div>
</div>
