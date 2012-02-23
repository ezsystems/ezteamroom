{def $icon_size='normal'
     $attribute = $node.data_map.file
     $icon_title=$attribute.content.mime_type
     $locked = $node.data_map.lock.content
     $not_locked = cond($locked,0,1)
     $filelockfeature = ezini( 'TeamroomSettings', 'FileLockFeature', 'teamroom.ini' )
     $lightboxfeature = ezini( 'TeamroomSettings', 'LightboxFeature', 'teamroom.ini' )
     $download_link    = concat( "content/download/", $attribute.contentobject_id, "/", $attribute.id, "/file/", $attribute.content.original_filename|rawurlencode() )
     $can_use_lightbox = fetch( 'user', 'has_access_to',
                                         hash( 'module',   'lightbox',
                                               'function', 'add'
                                             )
                              )}

<div class="file-list {$style} {if $locked}locked{/if} float-break ">

    {** Download button **}
    <div class="file-list-download">
        {if $not_locked}
        <a href={$download_link|ezurl()}><img src={'file/download.gif'|ezimage} alt="download_icon" title="{'Download this video'|i18n('ezteamroom/files')}" /></a>
        {/if}
    </div>

    {** Lock/Release button **}
    {if eq( $filelockfeature, 'enabled' )}
    <div class="file-list-bookmark">
        <a href={concat( 'filelist/set/', $node.contentobject_id, '/lock/', $not_locked, '/', $node.parent.url_alias )|ezurl}>
            {if $locked}<img src={'file/lock_closed.gif'|ezimage} alt="lock_closed_icon" title="{'Release this video'|i18n('ezteamroom/files')}" />
            {else}<img src={'file/lock_open.gif'|ezimage} alt="lock_open_icon" title="{'Lock this video'|i18n('ezteamroom/files')}" />{/if}
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
            <input type="image"
                   src={'file/bookmark.gif'|ezimage}
                   alt="{'Lightbox'|i18n( 'design/ezteamroom' )}"
                   title="{'Add this file to the current lightbox.'|i18n( 'design/ezteamroom' )}"
                   name="AddToLightboxAction" />
        </form>
        {else}
            <p>{'You can not access the current lightbox.'|i18n( 'ezteamroom/files' )}</p>
        {/if}
    </div>
    {/if}

    {** Versions button **}
    <div class="file-list-versions">
        <a href="#" onClick="javascript:showhide('ai{$node.node_id}'); return false;">
            <img src={'file/versions.gif'|ezimage} alt="versions_icon" title="{'Show versions of this video'|i18n( 'ezteamroom/files' )}" />
        </a>
    </div>

    {** Upload new version/update button **}
    <div class="file-list-update">
        {if $node.object.can_edit}
        <a href={concat("content/edit/",$node.object.id,'/f/',ezini( 'RegionalSettings', 'Locale', 'site.ini'))|ezurl}>
            <img src={'file/update.gif'|ezimage} alt="update_button" title="{'Edit this video or upload a new version'|i18n( 'ezteamroom/files' )}" />
        </a>
        {/if}
    </div>

    {** Delete button **}
    <div class="file-list-delete">
        {if and( $node.object.can_remove, $not_locked )}
        <form id="removeFile{$node.object.id}" method="post" action={"/content/action"|ezurl}>
            <input type="image" name="ActionRemove" value="x" src={'file/delete.gif'|ezimage} onClick="return confirmDelete()" title="{'Delete this image'|i18n( 'ezteamroom/files' )}">
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
        {$attribute.content.mime_type|mimetype_icon( $icon_size )}<br />
        {$attribute.content.mime_type_part|wash()|upcase()|shorten(4,'')} ({$attribute.content.filesize|si( byte )})
    </div>

    {** Description **}
    <div class="file-list-name"{if eq( $filelockfeature, 'enabled' )}style="width: 208px;"{/if}>
        <h4 title="{$attribute.content.original_filename|wash()}">{if $not_locked}<a href={$node.url_alias|ezurl()}>{/if}{$attribute.content.original_filename|wash()|shorten(30)}{if $not_locked}</a>{/if}</h4>
        <p class="info">{if is_set( $node.data_map.text_description )}{attribute_view_gui attribute=$node.data_map.text_description}{else}{attribute_view_gui attribute=$node.data_map.description}{/if}</p>
        <span class="date">{$node.object.published|l10n('shortdate')}</span>|
        <span class="owner"><strong>{'Owner'|i18n('ezteamroom/design')}</strong>&nbsp;{$node.object.owner.name|wash()}</span>
    </div>
</div>

<div id="ai{$node.node_id}" style="display:none;" class="{$style} file-infobox float-break">
        {def $list_count=fetch('content','version_count', hash( 'contentobject', $node.object ) )
             $version_list=fetch('content','version_list',hash( 'contentobject', $node.object ) )}

        <table class="renderedtable" width="100%" cellspacing="0" cellpadding="0" border="0">
        <tr>
            <th>{"Version"|i18n("design/standard/content/version")}</th>
            <th>{"Status"|i18n("design/standard/content/version")}</th>
            <th>{"Creator"|i18n("design/standard/content/version")}</th>
            <th>{"Modified"|i18n("design/standard/content/version")}</th>
            <th>{"Download"|i18n("design/standard/content/version")}</th>
        </tr>
        {foreach $version_list as $version sequence array(bglight,bgdark) as $style}
        <tr>
            <td class="{$style}">{$version.version} {if eq($version.version,$node.object.current_version)}*{/if}</td>
            <td class="{$style}">{$version.status|choose("Draft","Published","Pending","Archived","Rejected")}</td>
            <td class="{$style}"><a target="_blank" href={concat("/content/view/full/",$version.creator.main_node_id,"/")|ezurl}>{$version.creator.name|wash}</a></td>
            <td class="{$style}"><span class="small">{$version.modified|l10n(shortdate)}</span></td>
            <td class="{$style}"><a href={concat("content/download/",$version.data_map.file.contentobject_id,"/",$version.data_map.file.id,"/file/",$version.data_map.file.content.original_filename|rawurlencode() )|ezurl}> {"Get version"|i18n("design/standard/content/version")}</a></td>
        </tr>
        {/foreach}
        </table>
</div>
