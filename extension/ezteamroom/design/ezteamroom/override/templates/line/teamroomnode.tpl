{def $frontpagestyle='noleftcolumn rightcolumn'}
<div class="class-teamroom-line {$frontpagestyle}">
    <div class="columns-teamroom-line float-break">
        <div class="left-column-position">
            <div class="left-column">
            <!-- Content: START -->
            <!-- Content: END -->
            </div>
        </div>
        <div class="center-column-position">
            <div class="center-column float-break">
                <div class="overflow-fix">
                <!-- Content: START -->
                    <h3><a href="{$node.url_alias|ezurl('no')}" title="{$node.name|wash()}">{$node.name|wash()}</a></h3>
                    <div class="content">{$node.data_map.description.content.output.output_text|striptags|shorten(180)|wash()}</div>
                    <span class="date">{$node.object.published|l10n('shortdate')}</span>|
                    <span class="owner"><strong>{'Owner'|i18n('ezteamroom/teamroom')}</strong>&nbsp;{$node.object.owner.name|wash()}</span>
              <!-- Content: END -->

                {def $current_user = fetch( 'user', 'current_user' )}
                {if and( $node.object.owner.id|ne($current_user.contentobject_id), 
                        fetch( 'teamroom', 'has_access_to', hash( 'module', 'teamroom', 'function', 'resign', 'subtree', $node.path_string ) ) )}
                        <br /><br />
                        <a href={concat("teamroom/resign/",$node.object.id)|ezurl}>
                            {"Resign from this teamroom"|i18n("ezteamroom/teamroom")}
                        </a>
                {/if}

                </div>
            </div>
        </div>
        <div class="right-column-position">
            <div class="right-column">
            <!-- Content: START -->
                {attribute_view_gui attribute=$node.data_map.access_type}
            <!-- Content: END -->
            </div>
        </div>
    </div>
</div>
