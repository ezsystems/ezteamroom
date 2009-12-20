<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

{def $page_limit=30
     $can_edit=false()}
{*     list_count=fetch('content','draft_count')} *}
<form action={concat("content/bookmark/")|ezurl} method="post" style="display:inline;">
<div class="user-edit">

<div class="attribute-header">
<h1 class="long">{"My bookmarks"|i18n("ezteamroom/bookmark")}</h1>
</div>

{def $bookmark_list=fetch('content','bookmarks',array())}

{if $bookmark_list|count()}

<p>
    {"These are the objects you have bookmarked. Click on an object to view it or if you have permission you can edit the object by clicking the edit button.
      If you want to add more objects to this list click the %emphasize_startAdd bookmarks%emphasize_stop button.

      Removing objects will only remove them from this list."
      |i18n("ezteamroom/bookmark",,
            hash( '%emphasize_start', '<i>',
                  '%emphasize_stop', '</i>' ) )
      |nl2br}
</p>

{foreach $bookmark_list as $bookmark}
  {if $$bookmark.node.object.can_edit}
    {set $can_edit=true()}
  {/if}
{/foreach}

<table class="list" width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
    <th width="1">
    </th>
    <th>
        {"Name"|i18n("ezteamroom/bookmark")}
    </th>
</tr>

{foreach $bookmark_list as $bookmark sequence array(bgdark,bglight) as $sequence}
<tr class="{$sequence}">
    <td align="left">
        <input type="checkbox" name="DeleteIDArray[]" value="{$bookmark.id}" />
    </td>

    <td>
    {if eq( $bookmark.node.class_identifier, 'file' )}
        {$bookmark.node.object.content_class.identifier|class_icon( small, $bookmark.node.object.content_class.name )}
        &nbsp;
        {attribute_view_gui attribute=$bookmark.node.data_map.file}
    {elseif eq( $bookmark.node.class_identifier, 'lightbox' )}
        <img class="transparent-png-icon" src={'lightbox_bulb_small.gif'|ezimage} alt="lightbox_bulb_icon" />
        &nbsp;
        <a href={concat( '/lightbox/view/list/', $bookmark.node.object.data_map.lightbox.content.id )|ezurl()} target="_new">
        {'Lightbox'|i18n('ezteamroom/bookmark')} "{$bookmark.node.object.data_map.lightbox.content.name|wash()}"
        </a>
    {elseif eq( $bookmark.node.class_identifier, 'image' )}
            <a href="{concat( '/', $bookmark.node.data_map.image.content.original.url )}" target="_new">
        {$bookmark.node.object.content_class.identifier|class_icon( small, $bookmark.node.object.content_class.name )}
        &nbsp;
        {$bookmark.node.data_map.image.content.original_filename|wash()}
        </a>
    {else}
            <a href={concat("/content/view/full/",$bookmark.node_id,"/")|ezurl}>
        {$bookmark.node.object.content_class.identifier|class_icon( small, $bookmark.node.object.content_class.name )}
        &nbsp;
        {$bookmark.node.name|wash()}
        </a>
    {/if}
    </td>
</tr>
{/foreach}

</table>

{else}

<div class="feedback">
    <h2>{"You have no bookmarks"|i18n("ezteamroom/bookmark")}</h2>
</div>

{/if}

<div class="buttonblock">
    <input class="defaultbutton" type="submit" name="RemoveButton" value="{'Remove'|i18n('ezteamroom/bookmark')}" />
</form>

<form action={"/"|ezurl} method="post" style="display:inline;" >
    <input class="defaultbutton" type="submit" name="BackButton" value="{'Back'|i18n('ezteamroom/bookmark')}" />
</form>

</div>

</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
