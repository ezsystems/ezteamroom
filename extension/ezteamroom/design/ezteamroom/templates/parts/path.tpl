<div id="path_2" class="path_text">
 <a href={'/'|ezurl}><img src={'breadcrumb.gif'|ezimage()} alt="Home" /></a>
</div>

{foreach $module_result.path as $key => $path}

    {* skip root node *}

    {if and( is_set( $path.node_id ), or( $path.node_id|eq( 2 ), $path.node_id|eq( ezini( 'TeamroomSettings', 'TeamroomPoolNodeID', 'teamroom.ini' ) ) ) )}{continue}{/if}

<div id="path_{cond( is_set( $path.node_id ), $path.node_id, true(), $path.text|simplify()|explode( ' ' )|implode( '_' ) )}" class="path_text">

    {if and(is_set($path.url_alias),$path.url_alias)}

 <a href={$path.url_alias|ezurl}>{$path.text|wash|shorten( 30 )}</a>

    {elseif and(is_set($path.url),$path.url)}

 <a href={$path.url|ezurl}>{$path.text|wash|shorten( 30 )}</a>

    {else}

        {$path.text|wash|shorten( 30 )}

    {/if}

</div>
<div class="path_delimiter">
 <img src={'breadcrumb_delimiter.gif'|ezimage()} alt="breadcrumb_icon" />
</div>

{/foreach}

{def $version_number = teamroom_version()}

{if $version_number}

<div id="version-box">
 <a class="version-link" href={'/'|ezurl()}><strong>{"Version"|i18n( 'ezteamroom/teamroom' )}:</strong>&nbsp;{$version_number}</a>
</div>

{/if}

{undef $version_number}