{def $icon_size        = 'normal'
     $locked           = $node.data_map.lock.content
     $attribute        = $node.data_map.image
     $not_locked       = cond($locked,0,1)
     $filelockfeature  = ezini( 'TeamroomSettings', 'FileLockFeature', 'teamroom.ini' )
     $lightboxfeature  = ezini( 'TeamroomSettings', 'LightboxFeature', 'teamroom.ini' )
     $download_link    = concat( "content/download/", $attribute.contentobject_id, "/", $attribute.id )
     $can_use_lightbox = fetch( 'user', 'has_access_to',
                                         hash( 'module',   'lightbox',
                                               'function', 'add'
                                             )
                              )}

<div class="file-list {$style} {if $locked}locked{/if} float-break ">

    {** Download button **}
    <div class="file-list-download">
        {if $not_locked}
        <a href="{$download_link|ezurl()}"><img src={'file/download.gif'|ezimage} alt="download_icon" title="{'Download this image'|i18n('ezteamroom/files')}" /></a>
        {/if}
    </div>

    {** Lock/Release button **}
    {if eq( $filelockfeature, 'enabled' )}
    <div class="file-list-bookmark">
        <a href={concat( 'filelist/set/', $node.contentobject_id, '/lock/', $not_locked, '/', $node.parent.url_alias )|ezurl}>
            {if $locked}<img src={'file/lock_closed.gif'|ezimage} alt="lock_closed_icon" title="{'Release this image'|i18n('ezteamroom/files')}" />
            {else}<img src={'file/lock_open.gif'|ezimage} alt="lock_open_icon" title="{'Lock this image'|i18n('ezteamroom/files')}" />
            {/if}
        </a>
    </div>
    {/if}

    {** Bookmark/Lightbox button **}
    {if eq( $lightboxfeature, 'enabled' )}
    <div class="file-list-bookmark">
        {if $can_use_lightbox}
        <form class="inline" action={'/content/action'|ezurl()} method="post">
            <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
            <input type="hidden" name="ItemID" value="{$node.node_id}" />
            <input type="hidden" name="ItemType" value="eZContentNode" />
            <input type="image" id="{concat( 'file_list_lightbox_submit_', $node.contentobject_id )}"
                   src={'file/bookmark.gif'|ezimage}
                   alt="{'Lightbox'|i18n( 'ezteamroom/files' )}"
                   title="{'Add this image to the current lightbox'|i18n( 'ezteamroom/files' )}"
                   name="AddToLightboxAction" />
        </form>
        {else}
            <p>{'You can not access the current lightbox.'|i18n( 'ezteamroom/files' )}</p>
        {/if}
    </div>
    {/if}

    {** Versions button **}
    <div class="file-list-versions">
        <a href="#" onclick="javascript:showhide('ai{$node.node_id}'); return false;">
            <img src={'file/versions.gif'|ezimage} alt="versions_icon" title="{'Show versions of this image'|i18n( 'ezteamroom/files' )}" />
        </a>
    </div>

    {** Upload new version/update button **}
    <div class="file-list-update">
        {if $node.object.can_edit}
        <form method="post" action={"/content/action/"|ezurl}>
         <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
         <input type="hidden" name="RedirectURIAfterPublish" value="{$node.parent.url_alias}" />
         <input type="hidden" name="RedirectIfDiscarded" value="{$node.parent.url_alias}" />
         <input type="image" src={'file/update.gif'|ezimage} name="EditButton" id="{concat( 'file_list_edit_submit_', $node.contentobject_id )}" title="{'Edit this image or upload a new version'|i18n( 'ezteamroom/files' )}" />
        </form>
        {/if}
    </div>

    {** Delete button **}
    <div class="file-list-delete">
        {if and( $node.object.can_remove, $not_locked )}
        <form id="removeFile{$node.object.id}" method="post" action={"/content/action"|ezurl}>
            <input type="image" name="ActionRemove" value="x" src={'file/delete.gif'|ezimage} onclick="return confirmDelete()" id="{concat( 'file_list_remove_submit_', $node.contentobject_id )}" title="{'Delete this image'|i18n( 'ezteamroom/files' )}" />
            <input type="hidden" name="TopLevelNode" value="{$node.node_id}" />
            <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
            <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
            <input type="hidden" name="HideRemoveConfirmation" value="true" />
            <input type="hidden" name="RedirectURI" value="{$node.parent.url_alias}" />
        </form>
        {/if}
    </div>

    {** Icon **}
    <div class="file-list-icon">
    {if $not_locked}
        <a href="{concat( '/', $node.data_map.image.content.original.url )}">{attribute_view_gui attribute=$node.data_map.image image_class='fileimageicon'}</a>
    {else}
        {attribute_view_gui attribute=$node.data_map.image image_class='fileimageicon'}
    {/if}
        <br />
        {$node.data_map.image.content.original.suffix|wash()|upcase()|shorten(4,'')} ({$node.data_map.image.content.original.filesize|si( byte )})
    </div>

    {** Description **}
    <div class="file-list-name"{if eq( $filelockfeature, 'enabled' )}style="width: 208px;"{/if}>
        <h4 title="{$node.data_map.image.content.original_filename|wash()}">{if $not_locked}<a href={$node.url_alias|ezurl()}>{/if}{$node.data_map.image.content.original_filename|wash()|shorten(30)}{if $not_locked}</a>{/if}</h4>
        <div class="info">{$node.data_map.image.alternative_text|shorten(70)}<div class="hiddendescription">{$node.data_map.image.alternative_text|wash()}</div></div>
        <span class="date">{$node.object.modified|l10n('shortdate')}</span>|
        <span class="owner"><strong>{'Owner'|i18n('ezteamroom/files')}</strong>&nbsp;{$node.object.owner.name|wash()}</span>
    </div>
</div>

<div id="ai{$node.node_id}" style="display:none;" class="{$style} file-infobox float-break">
    {def $list_count=fetch('content','version_count', hash( 'contentobject', $node.object ) )
         $version_list=fetch('content','version_list',hash( 'contentobject', $node.object ) )}

    <table class="renderedtable" width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <th>{"Version"|i18n("ezteamroom/files")}</th>
        <th>{"Status"|i18n("ezteamroom/files")}</th>
        <th>{"Creator"|i18n("ezteamroom/files")}</th>
        <th>{"Modified"|i18n("ezteamroom/files")}</th>
        <th>{"Download"|i18n("ezteamroom/files")}</th>
    </tr>
    {foreach $version_list as $version sequence array(bglight,bgdark) as $style}
    <tr>
        <td class="{$style}">{$version.version} {if eq($version.version,$node.object.current_version)}*{/if}</td>
        <td class="{$style}">{$version.status|choose("Draft","Published","Pending","Archived","Rejected")}</td>
        <td class="{$style}"><a target="_blank" href={concat("/content/view/full/",$version.creator.main_node_id,"/")|ezurl}>{$version.creator.name|wash}</a></td>
        <td class="{$style}"><span class="small">{$version.modified|l10n(shortdate)}</span></td>
        <td class="{$style}"><a href="{concat( '/', $version.data_map.image.content.original.url )}"> {"Get version"|i18n("ezteamroom/files")}</a></td>
    </tr>
    {/foreach}
    </table>
</div>
