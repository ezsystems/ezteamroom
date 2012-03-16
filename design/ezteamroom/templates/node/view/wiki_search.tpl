{def $page_limit = 10}
{if ezpreference( 'teamroom_wiki_list_limit' )}
    {set $page_limit = ezpreference( 'teamroom_wiki_list_limit' )}
{/if}

{if and(is_set($view_parameters.limit),$view_parameters.limit|gt(0))}
    {set $page_limit = $view_parameters.limit}
{/if}

{if $page_limit|eq(-1)}
    {set $page_limit = ''}
{/if}

{def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}

<div class="content-view-full">
    <div class="class-wiki leftcolumn norightcolumn">

    <div class="attribute-header">
        <h1>{'Wiki'|i18n('ezteamroom/wiki')}</h1>
    </div>

    <div class="columns-frontpage float-break">
        <div class="left-column-position">
            <div class="left-column">
            <!-- Content: START -->
                {include uri='design:parts/wiki_leftcol.tpl'}
            <!-- Content: END -->
            </div>
        </div>
        <div class="center-column-position">
            <div class="center-column float-break center-column-wiki">
                <div class="overflow-fix">
                <!-- Content: START -->
                    <div class="border-box">
                    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
                    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

                    <div class="content-view-full">
                        <div class="content-search">

                            <div class="blog_actions float-break">
                            </div>

                            <div class="attribute-header">
                                <h1>{'Search'|i18n('ezteamroom/search')}</h1>
                            </div>


                            {def $search_text = ''}
                            {if ezhttp_hasvariable( 'SearchText', 'get' )}
                                {set $search_text = ezhttp( 'SearchText', 'get' )}
                            {/if}

                            {def $search = fetch( 'content', 'search', hash( 'text',            $search_text,
                                                                            'subtree_array',   array( $node.node_id ),
                                                                            'sort_by',         array('modified',false()),
                                                                            'offset',          $view_parameters.offset,
                                                                            'class_id',        $class_identifier_map['wiki_page'],
                                                                            'limit',           $page_limit))
                                $search_result   = $search['SearchResult']
                                $search_count    = $search['SearchCount']
                                $search_extras   = $search['SearchExtras']
                                $stop_word_array = $search['StopWordArray']
                            }

                            <form action={concat('content/view/wiki_search/',$node.node_id)|ezurl} method="get">
                            <div id="message_allcontent">
                                <div class="message-textcontent" style="width: 100%;">
                                    <table style="width: 100%;">
                                        <tr>
                                            <td class="tight">
                                            {if $search_count}
                                                <img src={'icons/icon_ok.jpg'|ezimage()} alt="icon_ok" />
                                            {else}
                                                <img src={'icons/icon_info.jpg'|ezimage()} alt="icon_ok" />
                                            {/if}
                                            </td>
                                            <td>
                                                <div class="message-infoline-border">
                                                    {switch name=Sw match=$search_count}
                                                        {case match=0}
                                                            <div class="message-infoline">
                                                                <h2>{'No results were found when searching for "%1".'|i18n("ezteamroom/search",,array($search_text|wash))}</h2>
                                                                {if is_set($search_extras['Error'])}
                                                                    {$search_extras['Error']}
                                                                {/if}
                                                            </div>
                                                            <div style="padding:5px;">
                                                                <p>{'Search tips'|i18n('ezteamroom/search')}</p>
                                                                <ul>
                                                                    <li>{'Check spelling of keywords.'|i18n('ezteamroom/search')}</li>
                                                                    <li>{'Try changing some keywords (eg, "car" instead of "cars").'|i18n('ezteamroom/search')}</li>
                                                                    <li>{'Try searching with less specific keywords.'|i18n('ezteamroom/search')}</li>
                                                                    <li>{'Reduce number of keywords to get more results.'|i18n('ezteamroom/search')}</li>
                                                                </ul>
                                                            </div>
                                                        {/case}
                                                        {case}
                                                            <div class="feedback">
                                                                <h2>{'Search for "%1" returned %2 matches'|i18n("ezteamroom/search",,array($search_text|wash,$search_count))}</h2>
                                                                <p>{'Search time: %1 msecs'|i18n('ezteamroom/search',,array($search_extras.ResponseHeader.QTime|wash))}</p>
                                                            </div>
                                                        {/case}
                                                    {/switch}

                                                    {if $stop_word_array}
                                                        <div style="padding:5px;">
                                                        {"The following words were excluded from the search"|i18n("ezteamroom/search")}:
                                                        {foreach $stop_word_array as $stopWord}
                                                            {$stopWord.word|wash}
                                                            {delimiter}, {/delimiter}
                                                        {/foreach}
                                                        </div>
                                                    {/if}

                                                    <div class="message-searchblock">
                                                        <div style="margin-top:7px;width:320px;">
                                                            <table>
                                                                <tr>
                                                                    <td style="vertical-align: middle;">
                                                                        <input class="teamroomsearch" type="text" size="20" name="SearchText" id="Search" value="{$search_text|wash}" />
                                                                    </td>
                                                                    <td>
                                                                        <div class="emptyButton emptyButton_whitebg">
                                                                            <input class="mousePointer emptyButton" type="submit" name="SearchButton" value="{'Start search'|i18n('ezteamroom/search')}" />
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </div>
                                                    <div class="result" style="padding: 2.0em;">
                                                        {if $search_result|count()}
                                                            <ul>
                                                            {foreach $search_result as $result sequence array(bglight,bgdark) as $bgColor}
                                                                <li class="{$bgColor}"><a class="search-item-link" href={$result.url_alias|ezurl()} title="{$result.name}">{$result.name|wash()}</a></li>
                                                            {/foreach}
                                                            </ul>
                                                        {/if}
                                                    </div>

                                                    {include name=Navigator
                                                            uri='design:navigator/google.tpl'
                                                            page_uri=concat('content/view/wiki_search/',$node.node_id)|ezurl
                                                            page_uri_suffix=concat('?SearchText=',$search_text|urlencode)
                                                            item_count=$search_count
                                                            view_parameters=$view_parameters
                                                            item_limit=$page_limit}
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            </form>





                        </div>
                    </div>




                    </div></div></div>
                    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
                    </div>


                <!-- Content: END -->
                </div>
            </div>
        </div>
    </div>

    </div>
</div>
{undef $class_identifier_map}
