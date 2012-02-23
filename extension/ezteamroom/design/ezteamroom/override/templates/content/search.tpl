{def $search=false()}
{if $use_template_search}
    {set $page_limit=10}
    {set $search=fetch(content,search,
                       hash(text,$search_text,
                            section_id,$search_section_id,
                            subtree_array,$search_subtree_array,
                            sort_by,array('modified',false()),
                            offset,$view_parameters.offset,
                            limit,$page_limit))}
    {set $search_result=$search['SearchResult']}
    {set $search_count=$search['SearchCount']}
    {def $search_extras=$search['SearchExtras']}
    {set $stop_word_array=$search['StopWordArray']}
    {set $search_data=$search}
{/if}

<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-search">

<form action={"/content/search/"|ezurl} method="get">

<div class="attribute-header">
    <h1 class="long">{"Search"|i18n("ezteamroom/search")}</h1>
</div>

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
                    <input type="hidden" name="SubTreeArray" value="{$search_subtree_array.0}" />
                   </td>
                   <td>
                 <div class="emptyButton emptyButton_whitebg">
                    <input class="mousePointer emptyButton" type="submit" name="SearchButton" value="{'Start search'|i18n('ezteamroom/search')}" />
                 </div>
                   </td>
                  </tr>
                 </table>

                 {def $adv_url=concat('/content/advancedsearch/',$search_text|count_chars()|gt(0)|choose('',concat('?SearchText=',$search_text|urlencode,'&SubTreeArray=',$search_subtree_array.0)))|ezurl}
                 <label>{"For more options try the %1Advanced search%2"|i18n("ezteamroom/search","The parameters are link start and end tags.",array(concat("<a href=",$adv_url,">"),"</a>"))}</label>
                </div>

            </div>
            <div class="result" style="padding: 2.0em;">
{if $search_result|count()}
                <ul>
                {foreach $search_result as $result
                         sequence array(bglight,bgdark) as $bgColor}
                   <li class="{$bgColor}"><a class="search-item-link" href={$result.url_alias|ezurl()} title="{$result.name}">{$result.name|wash()}</a></li>
                {/foreach}
                </ul>
{/if}
            </div>

{include name=Navigator
         uri='design:navigator/google.tpl'
         page_uri='/content/search'
         page_uri_suffix=concat('?SearchText=',$search_text|urlencode,'&SubTreeArray=',$search_subtree_array.0,$search_timestamp|gt(0)|choose('',concat('&SearchTimestamp=',$search_timestamp)))
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

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
