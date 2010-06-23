<form enctype="multipart/form-data" id="editform" name="editform" method="post" action={concat("/content/edit/",$object.id,"/",$edit_version,"/",$edit_language|not|choose(concat($edit_language,"/"),''))|ezurl}>

<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-edit">

    <div class="attribute-header">
        <h1 class="long">{'Edit %1 - %2'|i18n( 'ezteamroom/edit', , array( $class.name|wash, $object.name|wash ) )}</h1>
    </div>

    {include uri='design:content/edit_validation.tpl'}

    {include uri='design:content/edit_attribute.tpl'}

    <div class="buttonblock">
    <input class="defaultbutton" type="submit" name="PublishButton" value="{'Store'|i18n( 'ezteamroom/edit' )}" />
    <input class="button" type="submit" name="DiscardButton" value="{'Discard'|i18n( 'ezteamroom/edit' )}" />
    <input type="hidden" name="DiscardConfirm" value="0" />

{def $classIdentifiersMap = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
               $useParent = false()
         $lastAccessesURI = ezhttp( 'LastAccessesURI', 'session' )}

{if array( $classIdentifiersMap[forum_reply],
           $classIdentifiersMap[milestone],
           $classIdentifiersMap[comment],
           $classIdentifiersMap[file],
           $classIdentifiersMap[image],
           $classIdentifiersMap[quicktime],
           $classIdentifiersMap[real_video],
           $classIdentifiersMap[windows_media],
           $classIdentifiersMap[task]
         )|contains( $object.class_identifier )}

    {set $useParent = true()}

{/if}

{if and( $edit_version|gt( 1 ), array( $classIdentifiersMap[event] )|contains( $object.class_identifier )|not() ) }

    {if $useParent}

    <input type="hidden" name="RedirectIfDiscarded" value="{$object.main_node.parent.url_alias}" />
    <input type="hidden" name="RedirectURIAfterPublish" value="{$object.main_node.parent.url_alias}" />

    {else}

    {* By default jump to the node itself *}

    <input type="hidden" name="RedirectIfDiscarded" value="{$object.main_node.url_alias}" />
    <input type="hidden" name="RedirectURIAfterPublish" value="{$object.main_node.url_alias}" />

    {/if}

{else}

    {* The content object is not published yet *}

    <input type="hidden" name="RedirectIfDiscarded" value="{$lastAccessesURI}" />
    <input type="hidden" name="RedirectURIAfterPublish" value="{$lastAccessesURI}" />

{/if}

{undef $classIdentifiersMap $useParent $lastAccessesURI}

    </div>
</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>

</form>
