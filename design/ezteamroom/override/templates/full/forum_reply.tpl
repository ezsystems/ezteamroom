<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="attribute-header">
    <h1>{"Message preview"|i18n("ezteamroom/forum")}</h1>
</div>

<div class="forum_level4">
<table class="forum" cellspacing="0">
<tr>
    <th class="author">
    {"Author"|i18n("ezteamroom/forum")}
    </th>
    <th class="message">
    {"Topic"|i18n("ezteamroom/forum")}
    </th>
</tr>
<tr class="bglightforum">
    <td class="author">
    {def $owner=$node.object.owner
         $owner_map=$owner.data_map}
        <p class="author">{$owner.name|wash}
        {if is_set( $owner_map.title )}
            <br />{$owner_map.title.content|wash}
        {/if}</p>
        {if $owner_map.image.has_content}
        <div class="authorimage">
            {attribute_view_gui attribute=$owner_map.image image_class=small}
        </div>
        {/if}

        {if is_set( $owner_map.location )}
            <p>{"Location"|i18n("ezteamroom/forum")}:{$owner_map.location.content|wash}</p>
        {/if}
        <p>
        {def $owner_id=$node.object.owner.id}
            {foreach $node.object.author_array as $author}
                {if eq($owner_id,$author.contentobject_id)|not()}
                    {"Moderated by"|i18n("ezteamroom/forum")}: {$author.contentobject.name|wash}
                 {/if}
             {/foreach}
        </p>

        {if $node.object.can_edit}
        <form method="post" action={"content/action/"|ezurl}>

        <br/>

        <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
        <input class="button forum-edit-reply" type="submit" name="EditButton" value="{'Edit'|i18n('ezteamroom/forum')}" />
        <input type="hidden" name="ContentObjectLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
        </form>
        {/if}

    </td>
    <td class="message">
        <p class="date">{$node.object.published|l10n(datetime)}</p>

        <h3>{$node.name|wash}</h3>

        <p>
            {$node.data_map.message.content|simpletags|wordtoimage|autolink}
        </p>
        {if $owner_map.signature.has_content}
            <p class="author-signature">{$owner_map.signature.content|simpletags|autolink}</p>
        {/if}
    </td>
</tr>
</table>
</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>