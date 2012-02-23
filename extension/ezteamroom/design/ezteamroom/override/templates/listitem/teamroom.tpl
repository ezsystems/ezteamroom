{def $to_be_setup = fetch( 'content', 'list_count', hash( 'parent_node_id', $node.node_id, 'limitation', array() ) )|eq( 0 )}

<span class="listitem_teamroom">
 <span class="name"><strong>{$node.name|wash()}</strong>{if $to_be_setup}<span title="{'creation in progress'|i18n( 'ezteamroom/teamroom' )}"> (*)</span>{/if}</span>
 <br />
 <span class="date">{$node.object.published|l10n( 'shortdate' )}</span>|
 <span class="owner"><strong>{'Owner'|i18n( 'ezteamroom/teamroom' )}</strong>&nbsp;{$node.object.owner.name|wash()}</span>
</span>
