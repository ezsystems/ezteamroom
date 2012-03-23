{default attribute_base=ContentObjectAttribute}
{def $teamroom_node_id=false()
     $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}
{if $attribute.object.main_node.path|count}
    {foreach $attribute.object.main_node.path as $path_node}
        {if $path_node.class_identifier|eq( $class_identifier_map['teamroom'] )}
            {set $teamroom_node_id=$path_node.node_id}
            {break}
        {/if}
        {undef $path_node}
    {/foreach}
{else}
    {foreach $assigned_node_array as $main_node}
        {foreach $main_node.parent_node_obj.path as $path_node}
            {if $path_node.class_identifier|eq( $class_identifier_map['teamroom'] )}
                {set $teamroom_node_id=$path_node.node_id}
                {break}
            {/if}
            {undef $path_node}
        {/foreach}
    {/foreach}
{/if}

{undef $class_identifier_map}

{def $class_content=$attribute.class_content
     $node_list=cond( and( is_set( $class_content.class_constraint_list ), $class_content.class_constraint_list|count|ne( 0 ) ),
                         fetch( content, tree,
                                hash( parent_node_id, $teamroom_node_id,
                                      class_filter_type,'include',
                                      class_filter_array, $class_content.class_constraint_list,
                                      sort_by, array( 'name',true() ) ) ),
                         fetch( content, tree,
                                hash( parent_node_id, $teamroom_node_id,
                                      sort_by, array( 'name', true() )
                                     ) )
                        )}
{if ne( count( $node_list ), 0 )}
    <div class="buttonblock">
    <div class="templatebasedeor">
        <input type="hidden" name="single_select_{$attribute.id}" value="1" />
        <select name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]">
            {if $attribute.contentclass_attribute.is_required|not}
                <option value="no_relation" {if eq( $attribute.content.relation_list|count, 0 )} selected="selected"{/if}>{'No relation'|i18n( 'ezteamroom/tasks' )}</option>
            {/if}
            {foreach $node_list as $node}
                <option value="{$node.contentobject_id}"
                {if ne( count( $attribute.content.relation_list ), 0)}
                {foreach $attribute.content.relation_list as $item}
                        {if eq( $item.contentobject_id, $node.contentobject_id )}
                        selected="selected"
                        {break}
                        {/if}
                {/foreach}
                {/if} />
                {$node.name|wash}</option>
            {/foreach}
        </select>
    </div>
    </div>
{else}
        <p>{'No milestones found.'|i18n( 'ezteamroom/tasks' )}
{/if}

{/default}
