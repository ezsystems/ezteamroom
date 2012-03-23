{if not(is_set($class_identifier_map))}
    {def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}
{/if}
{def $wiki_node = $node}
{if $wiki_node.class_identifier|eq($class_identifier_map['wiki_page'])}
    {set $wiki_node = $node.parent}
{/if}

<div class="wiki-left-col">
{if $wiki_node.class_identifier|eq($class_identifier_map['wiki'])}
    <h3>{'Navigation'|i18n('ezteamroom/wiki')}</h3>
    <p><a href={$wiki_node.url_alias|ezurl()}>{'Wiki home'|i18n('ezteamroom/wiki')}</a></p>
    <p><a href={concat('wiki/random_page/',$wiki_node.node_id)|ezurl}>{'Random page'|i18n('ezteamroom/wiki')}</a></p>
    <p><a href={concat('content/view/wiki_atoz/',$wiki_node.node_id)|ezurl}>{'From A to Z'|i18n('ezteamroom/wiki')}</a></p>

    <div id="wikisearch">
        <h3>{'Search'|i18n( 'ezteamroom/search' )}</h3>
        <form action={concat('content/view/wiki_search/',$wiki_node.node_id)|ezurl}>
            <input id="wikisearchtext" name="SearchText" type="text" value="" size="12" {if eq( $ui_context, 'edit' )}disabled="disabled" {/if} />
            <input id="wikisearchbutton" type="submit" value="{'Go'|i18n('ezteamroom/search')}" alt="Submit" {if eq( $ui_context, 'edit' )}class="button-disabled"  disabled="disabled" {/if}/>
        </form>
    </div>


    {def $children_count=fetch_alias( 'children_count', hash( 'parent_node_id',         $wiki_node.node_id,
                                                              'class_filter_type',      'include',
                                                              'class_filter_array',     array( $class_identifier_map['wiki_page'] ) ) )}
    {if or( $children_count|gt( 0 ), is_set( $view_parameters.tag ) )}
        <div class="keywords">
            <h3>{'Keywords'|i18n('ezteamroom/wiki')}</h3>
            {def $wikiTagList = ezkeywordlist( $class_identifier_map['wiki_page'], $wiki_node.node_id, $wiki_node.depth|inc() )}
            <div class="tags">
            {if $wikiTagList|count()|gt( 0 )}
                {foreach $wikiTagList as $keyword}
                    <a href={concat( 'content/view/wiki_tags/',$wiki_node.node_id, "/(tag)/", $keyword.keyword|rawurlencode() )|ezurl()} title="{'Shown only entries with tag "%1"'|i18n( 'ezteamroom/files', , array( $keyword.keyword ) )|wash()}">{$keyword.keyword|wash()}</a>
                    {delimiter}, {/delimiter}
                {/foreach}
            {else}
                {'No tags available'|i18n( 'ezteamroom/tags' )}
            {/if}
            </div>
        </div>
    {/if}



    {if $node.class_identifier|eq($class_identifier_map['wiki'])}    {* view caching will be a problem on chlid nodes *}
        </br />
        {def $wiki_page_count = fetch( 'content', 'tree_count', hash( 'parent_node_id',     $wiki_node.node_id,
                                                                    'depth',              0,
                                                                    'class_filter_type',  'include',
                                                                    'class_filter_array', array( $class_identifier_map['wiki_page'] ) ) )
        }
        <p>{'Wiki articles:'|i18n('ezteamroom/wiki')} {$wiki_page_count}</p>
        {undef $wiki_page_count}
    {/if}
</div>
{/if}