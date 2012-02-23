{def $search=false()}
{if $use_template_search}
    {set $page_limit=10}
    {switch match=$search_page_limit}
    {case match=1}
        {set $page_limit=5}
    {/case}
    {case match=2}
        {set $page_limit=10}
    {/case}
    {case match=3}
        {set $page_limit=20}
    {/case}
    {case match=4}
        {set $page_limit=30}
    {/case}
    {case match=5}
        {set $page_limit=50}
    {/case}
    {/switch}
    {set $search=fetch(content,search,
                      hash(text,$search_text,
                           section_id,$search_section_id,
                           subtree_array,$search_sub_tree,
                           class_id,$search_contentclass_id,
                           class_attribute_id,$search_contentclass_attribute_id,
                           offset,$view_parameters.offset,
                           publish_date,$search_date,
                           limit,$page_limit))}
    {set $search_result=$search['SearchResult']}
    {set $search_count=$search['SearchCount']}
    {set $stop_word_array=$search['StopWordArray']}
    {set $search_data=$search}
{/if}

<div class="border-box">
 <div class="border-tl">
  <div class="border-tr">
   <div class="border-tc"></div>
  </div>
 </div>
 <div class="border-ml">
  <div class="border-mr">
   <div class="border-mc float-break">
    <div class="content-advancedsearch">
     <form action={"/content/advancedsearch/"|ezurl} method="get">
      <div class="attribute-header">
       <h1 class="long">{'Advanced search'|i18n( 'ezteamroom/search' )}</h1>
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

            {if or( $search_text, eq( ezini( 'SearchSettings', 'AllowEmptySearch', 'site.ini'), 'enabled' ) )}
            <br />
            {switch name=Sw match=$search_count}
              {case match=0}
            <div class="message-infoline">
             <h2>{'No results were found when searching for "%1"'|i18n( 'ezteamroom/search', , array( $search_text|wash ) )}</h2>
            </div>
              {/case}
              {case}
            <div class="feedback">
             <h2>{'Search for "%1" returned %2 matches'|i18n( 'ezteamroom/search',,array( $search_text|wash, $search_count ) )}</h2>
            </div>
              {/case}
            {/switch}

            <div class="message-searchblock">
             <div style="margin-top:7px;">
              <table>
               <tr>
                <td style="vertical-align: middle;">
                 <label>{'Search all the words'|i18n( 'ezteamroom/search' )}</label>
                 <input class="teamroomadsearch" type="text" size="40" name="SearchText" value="{$full_search_text|wash}" />
                 <input type="hidden" name="SubTreeArray" value="{$search_sub_tree.0}" />
                 <label>{'Search the exact phrase'|i18n( 'ezteamroom/search' )}</label>
                 <input class="teamroomadsearch" type="text" size="40" name="PhraseSearchText" value="{$phrase_search_text|wash}" />
                 <label>{'Published'|i18n( 'ezteamroom/search' )}</label>
                 <select name="SearchDate">
                  <option value="-1" {if eq( $search_date, '-1' )}selected="selected"{/if}>{'Any time'|i18n( 'ezteamroom/search' )}</option>
                  <option value="1" {if eq( $search_date, '1' )}selected="selected"{/if}>{'Last day'|i18n( 'ezteamroom/search' )}</option>
                  <option value="2" {if eq( $search_date, '2' )}selected="selected"{/if}>{'Last week'|i18n( 'ezteamroom/search' )}</option>
                  <option value="3" {if eq( $search_date, '3' )}selected="selected"{/if}>{'Last month'|i18n( 'ezteamroom/search' )}</option>
                  <option value="4" {if eq( $search_date, '4' )}selected="selected"{/if}>{'Last three months'|i18n( 'ezteamroom/search' )}</option>
                  <option value="5" {if eq( $search_date, '5' )}selected="selected"{/if}>{'Last year'|i18n( 'ezteamroom/search' )}</option>
                 </select>

            {if $use_template_search}
                 <label>{'Display per page'|i18n('ezteamroom/search')}</label><div class="labelbreak"></div>
                 <select name="SearchPageLimit">
                  <option value="1" {if eq( $search_page_limit,1 )}selected="selected"{/if}>{'5 items'|i18n( 'ezteamroom/search' )}</option>
                  <option value="2" {if or( array( 1, 2, 3, 4, 5 )|contains( $search_page_limit )|not, eq( $search_page_limit, 2 ) )}selected="selected"{/if}>{'10 items'|i18n( 'ezteamroom/search' )}</option>
                  <option value="3" {if eq( $search_page_limit, 3 )}selected="selected"{/if}>{'20 items'|i18n( 'ezteamroom/search' )}</option>
                  <option value="4" {if eq( $search_page_limit, 4 )}selected="selected"{/if}>{'30 items'|i18n( 'ezteamroom/search' )}</option>
                  <option value="5" {if eq( $search_page_limit, 5 )}selected="selected"{/if}>{'50 items'|i18n( 'ezteamroom/search' )}</option>
                 </select>
            {/if}

                </td>
                <td style="vertical-align: bottom;">

            {foreach $search_sub_tree as $sub_tree}
                 <input type="hidden" name="SubTreeArray[]" value="{$sub_tree}" />
            {/foreach}

                 <div class="emptyButton emptyButton_whitebg">
                  <input class="mousePointer emptyButton" type="submit" name="SearchButton" value="{'Start search'|i18n('ezteamroom/search')}" />
                 </div>
                </td>
               </tr>
              </table>
              {def $simple_url=concat('/content/search/',$search_text|count_chars()|gt(0)|choose('',concat('?SearchText=',$search_text|urlencode,'&SubTreeArray=',$search_sub_tree.0)))|ezurl}
              <label>{"Switch to the %1simple search%2"|i18n("ezteamroom/search","The parameters are link start and end tags.",array(concat("<a href=",$simple_url,">"),"</a>"))}</label>
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

{/if}

            </div>

{include name=navigator
         uri='design:navigator/google.tpl'
         page_uri='/content/advancedsearch'
         page_uri_suffix=concat('?SearchText=',$search_text|urlencode,'&SubTreeArray=',$search_sub_tree.0,'&PhraseSearchText=',$phrase_search_text|urlencode,'&SearchContentClassID=',$search_contentclass_id,'&SearchContentClassAttributeID=',$search_contentclass_attribute_id,'&SearchSectionID=',$search_section_id,$search_timestamp|gt(0)|choose('',concat('&SearchTimestamp=',$search_timestamp)),$search_sub_tree|gt(0)|choose( '', concat( '&', 'SubTreeArray[]'|urlencode, '=', $search_sub_tree|implode( concat( '&', 'SubTreeArray[]'|urlencode, '=' ) ) ) ),'&SearchDate=',$search_date,'&SearchPageLimit=',$search_page_limit)
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
  </div>
 </div>
 <div class="border-bl">
  <div class="border-br">
   <div class="border-bc"></div>
  </div>
 </div>
</div>
