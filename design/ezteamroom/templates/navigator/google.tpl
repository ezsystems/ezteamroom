{default $page_uri_suffix=false()
         $left_max=1
         $right_max=2
         $show_limit_sel=true()
         $preference="teamroom_list_limit"}
{if ezpreference( $preference )}
{def $default_limit = ezpreference( $preference )}
{/if}
{def $page_count=int( ceil( div( $item_count,$item_limit ) ) )
     $current_page=min($page_count,
                       int( ceil( div( first_set( $view_parameters.offset, 0 ),
                                       $item_limit ) ) ) )
     $current_item=mul( $current_page, $item_limit )|inc
     $item_previous=sub( mul( $current_page, $item_limit ),
                         $item_limit )
     $item_next=sum( mul( $current_page, $item_limit ),
                     $item_limit )

     $left_length=min($current_page,$left_max)
     $right_length=max(min(sub($page_count,$current_page,1),$right_max),0)
     $view_parameter_text=""
     $offset_text=eq( ezini( 'ControlSettings', 'AllowUserVariables', 'template.ini' ), 'true' )|choose( '/offset/', '/(offset)/' )
     $number_of_items=first_set( $default_limit, 5 )}


{foreach $view_parameters as $key => $item}
    {if and(ne($key,offset),$item|ne(''))}
        {set view_parameter_text=concat($view_parameter_text,'/(',$key,')/',$item)}
    {/if}
{/foreach}

{if or($page_count|gt(1),$show_limit_sel|eq(true()))}

<div class="pagenavigator float-break">
<div class="left">

{if $page_count|gt(1)}

<span class="showing">{"showing <strong>%1-%2</strong> of <strong>%3</strong>"|i18n("ezteamroom/teamroom",,hash('%1',$current_item,'%2',min($item_count,sum($current_item,$item_limit)|dec),'%3',$item_count))}</span>

<span class="previous"><a href={concat($page_uri,$view_parameter_text,$page_uri_suffix)|ezurl}><span class="text"><img src={'paginating/first.gif'|ezimage} alt="first_icon" /></span></a></span>
<span class="previous"><a href={concat($page_uri,$item_previous|gt(0)|choose('',concat($offset_text,$item_previous)),$view_parameter_text,$page_uri_suffix)|ezurl}><span class="text"><img src={'paginating/prev.gif'|ezimage} alt="previous_icon" /></span></a></span>

<span class="pages">

{if $current_page|gt($left_max)}
    <a href={concat($page_uri,$view_parameter_text,$page_uri_suffix)|ezurl}>1</a>
    {if sub($current_page,$left_length)|gt(1)}
...
    {/if}
{/if}
    {if $left_length}
    {for 0 to $left_length|dec as $index}
        {def $page_offset=sum(sub($current_page,$left_length),$index)}
          <span class="other"><a href={concat($page_uri,$page_offset|gt(0)|choose('',concat($offset_text,mul($page_offset,$item_limit))),$view_parameter_text,$page_uri_suffix)|ezurl}>{$page_offset|inc}</a></span>
        {delimiter}|{/delimiter}
    {/for}
|
    {/if}

    <span class="current">{$current_page|inc}</span>

    {if $right_length}
|
    {for 0 to $right_length|dec as $index}
        {def $page_offset=sum($current_page,1,$index)}
          <span class="other"><a href={concat($page_uri,$page_offset|gt(0)|choose('',concat($offset_text,mul($page_offset,$item_limit))),$view_parameter_text,$page_uri_suffix)|ezurl}>{$page_offset|inc}</a></span>
        {delimiter}|{/delimiter}
    {/for}
    {/if}

{if $page_count|gt(sum($current_page,$right_max,1))}
    {if sum($current_page,$right_max,2)|lt($page_count)}
        <span class="other">...</span>
    {/if}
    <span class="other"><a href={concat($page_uri,$page_count|dec|gt(0)|choose('',concat($offset_text,mul($page_count|dec,$item_limit))),$view_parameter_text,$page_uri_suffix)|ezurl}>{$page_count}</a></span>
{/if}

</span>
<span class="next"><a href={concat($page_uri,$offset_text,$item_next,$view_parameter_text,$page_uri_suffix)|ezurl}><span class="text"><img src={'paginating/next.gif'|ezimage} alt="next_icon" /></span></a></span>
<span class="next"><a href={concat($page_uri,$page_count|dec|gt(0)|choose('',concat($offset_text,mul($page_count|dec,$item_limit))),$view_parameter_text,$page_uri_suffix)|ezurl}><img src={'paginating/last.gif'|ezimage} alt="last_icon" /></a></span>

{else}
    &nbsp;
{/if}
</div>
<div class="right">
{if $show_limit_sel|eq(true())}
<span class="counter">
    {def $item_list=hash( '5','5', '10','10', '20','20', '50','50', 'all','-1' )}
    {"Show me"|i18n("ezteamroom/teamroom")}
    {foreach $item_list as $key => $value}
        {if $number_of_items|eq($value)}
            <span class="current">{$key}</span>
        {else}
            <a href={concat('/user/preferences/set/',$preference,'/',$value)|ezurl} title="{'Show %1 items per page.'|i18n( 'ezteamroom/teamroom',,hash('%1',$key ))}">{$key}</a>
        {/if}
        {delimiter} | {/delimiter}
    {/foreach}
    {"items per page"|i18n("ezteamroom/teamroom")}
</span>
{/if}
</div>
</div>

{/if}

{/default}

