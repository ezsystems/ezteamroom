{def $manual_attributes=array( 'subject', 'message', 'notify_me', 'sticky' )}

{def $attribute_names=hash()}
{foreach $content_attributes as $key => $attribute}
    {set $attribute_names = $attribute_names|append( $attribute.contentclass_attribute_identifier )}
{/foreach}
{set $attribute_names=$attribute_names|array_flip()}

{* Forum topic - Edit *}
<div class="edit">
    <div class="class-forum-topic">

    <form name="editform" id="editform" enctype="multipart/form-data" method="post" action={concat( '/content/edit/', $object.id, '/', $edit_version, '/', $edit_language|not|choose( concat( $edit_language, '/' ), '/' ), $is_translating_content|not|choose( concat( $from_language, '/' ), '' ) )|ezurl}>
        <h1>{"Edit %1 - %2"|i18n("ezteamroom/forum",,array($class.name|wash,$object.name|wash))}</h1>

        {include uri="design:content/edit_validation.tpl"}

        <input type="hidden" name="MainNodeID" value="{$main_node_id}" />

    <div class="edit-attribute block">
        <label class="title">{'Subject'|i18n('ezteamroom/forum')}</label>{if $object.data_map.subject.contentclass_attribute.is_required} *{/if}<div class="labelbreak"></div>
        <input type="hidden" name="ContentObjectAttribute_id[]" value="{$object.data_map.subject.id}" />
        {attribute_edit_gui attribute=$object.data_map.subject attribute_base=$attribute_base view_parameters=$view_parameters}
    </div>
    <div class="edit-attribute block">
        <label class="title">{'Message'|i18n('ezteamroom/forum')}</label>{if $object.data_map.message.contentclass_attribute.is_required} *{/if}<div class="labelbreak"></div>
        {attribute_edit_gui attribute=$object.data_map.message attribute_base=$attribute_base view_parameters=$view_parameters}
    </div>

    <div class="edit-attribute block">
        <label class="title">{'Notify me about updates'|i18n('ezteamroom/forum')}</label>{if $object.data_map.notify_me.contentclass_attribute.is_required} *{/if}<div class="labelbreak"></div>
        {attribute_edit_gui attribute=$object.data_map.notify_me attribute_base=$attribute_base view_parameters=$view_parameters}
    </div>

    {foreach $content_attributes as $attribute}
    {if $manual_attributes|contains($attribute.contentclass_attribute_identifier)|not}
        <div class="block">##{$attribute.contentclass_attribute_identifier}##
            {include uri="design:content/attribute_edit.tpl" attribute=$attribute object=$object}
        </div>
    {/if}
    {/foreach}



        {let current_user=fetch( 'user', 'current_user' )
             sticky_groups=ezini( 'ForumSettings', 'StickyUserGroupArray', 'forum.ini' )}

        {$current_user.groups|contains($sticky)}

            {section var=sticky loop=$sticky_groups}
                {section show=$current_user.groups|contains($sticky)}
            <div class="edit-attribute block">
                <label class="title">{'Sticky'|i18n('ezteamroom/forum')}</label>{if $object.data_map.sticky.contentclass_attribute.is_required} *{/if}<div class="labelbreak"></div>
                {attribute_edit_gui attribute=$object.data_map.sticky attribute_base=$attribute_base view_parameters=$view_parameters}
            </div>
                {/section}
            {/section}
        {/let}

        <div class="buttonblock">
        {*if $edit_version|gt(1)}
            <input type="hidden" name="RedirectIfDiscarded" value={$object.main_node.parent.url_alias|wash()} />
            <input type="hidden" name="RedirectURIAfterPublish" value={$object.main_node.parent.url_alias|wash()} />
        {else}
            <input type="hidden" name="RedirectIfDiscarded" value="{ezhttp( 'LastAccessesURI', 'session' )}" />
            <input type="hidden" name="RedirectURIAfterPublish" value="{ezhttp( 'LastAccessesURI', 'session' )}" />
        {/if*}
            <input class="defaultbutton" type="submit" name="PublishButton" value="{'Store'|i18n('ezteamroom/forum')}" />
            <input class="button" type="submit" name="DiscardButton" value="{'Discard'|i18n('ezteamroom/forum')}" />
            <input type="hidden" name="DiscardConfirm" value="0" />
        </div>

        </form>
    </div>
</div>


