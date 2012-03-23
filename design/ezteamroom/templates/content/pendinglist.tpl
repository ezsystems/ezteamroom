{def $page_limit=15
     $list_count=fetch( 'content', 'pending_count' )
     $pending_list=fetch( 'content', 'pending_list', hash( 'limit', $page_limit,
                                                           'offset', $view_parameters.offset ) )}
<div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>

    <form name="pendinglistaction" action={concat("/content/pendinglist")|ezurl} method="post" >

    <div class="border-ml">
      <div class="border-mr">
        <div class="border-mc float-break">

            {def $frontpagestyle='noleftcolumn rightcolumn'}
            <div class="content-view-full">
                <div class="class-user_group {$frontpagestyle}">

                <div class="attribute-header">
                    <h1>{"User profile"|i18n("ezteamroom/membership")}</h1>
                </div>

                <div class="columns-frontpage float-break">
                    <div class="center-column-position">
                        <div class="user-edit">
























<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc">

<div class="content-pendinglist">

<div class="maincontentheader">
    <h1 class="long">{'My pending items [%pending_count]'|i18n( 'ezteamroom/membership',, hash( '%pending_count', $list_count ) )}</h1>
</div>

{if $pending_list|count()}

<table class="list" width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
    <th>{"Name"|i18n('ezteamroom/membership')}</th>
    <th>{"Class"|i18n('ezteamroom/membership')}</th>
    <th>{"Section"|i18n('ezteamroom/membership')}</th>
    <th>{"Version"|i18n('ezteamroom/membership')}</th>
    <th>{"Last modified"|i18n('ezteamroom/membership')}</th>
</tr>

{foreach $pending_list as $pending_item sequence array( 'bglight', 'bgdark' ) as $style}
<tr class="{$style}">
   <td>
        {$pending_item.contentobject.content_class.identifier|class_icon( small, $pending_item.contentobject.content_class.name )}&nbsp;<a href={concat( "/content/versionview/", $pending_item.contentobject.id, "/", $pending_item.version )|ezurl} title="{$pending_item.contentobject.name|wash}">{$pending_item.contentobject.name|wash}</a>
    </td>
    <td>
        {$pending_item.contentobject.content_class.name|wash}
    </td>
    <td>
        {def $section_object=fetch( 'section', 'object', hash( 'section_id', $pending_item.contentobject.section_id ) )}
        {if $section_object}
            {$section_object.name|wash}
        {else}
            <i>{'Unknown'|i18n( 'ezteamroom/membership' )}</i>
        {/if}
    </td>
    <td>
        {$pending_item.version}
    </td>
    <td>
        {$pending_item.modified|l10n( shortdatetime )}
    </td>
</tr>
{/foreach}
</table>

{include name=navigator
         uri='design:navigator/google.tpl'
         page_uri='/content/pendinglist'
         item_count=$list_count
         view_parameters=$view_parameters
         item_limit=$page_limit}

{else}

<div class="feedback">
    <h2>{"Your list of pending items is empty."|i18n('ezteamroom/membership')}</h2>
</div>

{/if}

</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>



















                        </div>

                    </div>

                    <div class="right-column-position">
                        <div class="right-column">

{include uri='design:user/edit_menu.tpl' add_form = true()}

                        </div>
                    </div>

              </div>
            </div>
          </div>

        </div>
      </div>
    </div>

    </form>

    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
