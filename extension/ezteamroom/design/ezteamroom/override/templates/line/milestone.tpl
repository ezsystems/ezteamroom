{* Milestone - Line view *}

{def $add_style=''}
{if and( gt(currentdate() , $node.data_map.date.content.timestamp), not($node.data_map.closed.data_int) )}
    {set $add_style='critical_timeline'}
{/if}

<div class="class-milestone file-list {$style} float-break">
        {if $node.data_map.closed.data_int}
    <div class="file-list-download">
            <img src={"close_milestone.gif"|ezimage()} title="{'The milestone has been closed.'|i18n('ezteamroom/tasks')}" alt="close_icon" />
            <br />{'Closed'|i18n('ezteamroom/tasks')}
    </div>
        {elseif fetch( 'teamroom', 'has_access_to', hash( 'module', 'tasklist', 'function', 'modify', 'subtree', $node.parent.parent.path_string ) )}
    <div class="file-list-download">
            <a href={concat("tasklist/set/",$node.object.id,"/closed/",1,$url)|ezurl()}><img src={"close_milestone_g.gif"|ezimage()} alt="close_icon" />
            <br /><span class="link">{'Close'|i18n('ezteamroom/tasks')}</span></a>
    </div>
        {/if}
    <div class="file-list-versions">
        <a href="#" onclick="javascript:showhide('ai{$node.node_id}'); return false;">
            <img src={'file/versions.gif'|ezimage} alt="versions_icon" /><br /><span class="link">{'Details'|i18n('ezteamroom/tasks')}</span>
        </a>
    </div>
    {if $node.object.can_edit}
    <div class="file-list-update">
        <form method="post" action={"/content/action/"|ezurl}>
         <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
         <input type="hidden" name="RedirectURIAfterPublish" value="{$node.parent.url_alias}" />
         <input type="hidden" name="RedirectIfDiscarded" value="{$node.parent.url_alias}" />
        <input type="image" src={'file/update.gif'|ezimage} name="EditButton" id="{concat( 'milestone_list_edit_submit_', $node.contentobject_id )}" />
        <br />
        <label for="{concat( 'milestone_list_edit_submit_', $node.contentobject_id )}" class="submitlabel">{'Edit'|i18n('ezteamroom/tasks')}</label></a>
       </form>
    </div>
    {/if}

    <div class="file-list-icon {$add_style}">
        {if $node.data_map.date.content.timestamp}
            {$node.data_map.date.content.timestamp|l10n('shortdate')}
        {/if}
    </div>
    <div class="file-list-name">
        <h4>{$node.name|wash()}</h4>
        <div class="info">{$node.data_map.description.content.output.output_text|striptags|shorten(70)}<div class="hiddendescription">{attribute_view_gui attribute=$node.data_map.description}</div></div>
    </div>
</div>
<div id="ai{$node.node_id}" style="display:none;" class="{$style} milestone-infobox float-break">
    <div class="attribute-related_tasks">
        {def $reverse_related_objects = fetch( 'content', 'reverse_related_objects', hash( 'object_id', $node.object.id,
                                                                                           'attribute_identifier', concat( $class_identifier_map['task'], '/milestone' ),
                                                                                           'sort_by', array( array( 'name', true() ) ) ) )}
        {if count($reverse_related_objects)|ne(0)}
            <h5>{'Task related to this milestone'|i18n('ezteamroom/tasks')}</h5>
            {foreach $reverse_related_objects as $related_object}
                <a href={$related_object.main_node.parent.url_alias|ezurl()}>{$related_object.name|wash()}</a>
            {/foreach}
        {else}
            <h5>{'No tasks assigned yet'|i18n('ezteamroom/tasks')}</h5>
        {/if}
    </div>
    <div class="attribute-related_files">
    </div>
</div>
