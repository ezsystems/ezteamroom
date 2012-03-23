<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="{$site.http_equiv.Content-language|wash}" lang="{$site.http_equiv.Content-language|wash}">
<head>

{def $pagestyle        = 'nosidemenu noextrainfo'
     $pagedesign_class = fetch( 'content', 'class', hash( 'class_id', 'template_look' ) )
     $content_info     = hash()}
{if is_set( $module_result.content_info )}
    {set $content_info = $module_result.content_info}
{/if}

{if $pagedesign_class.object_count|eq( 0 )|not}
    {def $pagedesign = $pagedesign_class.object_list[0]}
{/if}

{ezcss( array( 'yui/fonts/fonts-min.css', 'core.css', 'debug.css', 'teamroom.css', ezini( 'StylesheetSettings', 'CSSFileList', 'design.ini' ) ) ) }

{include uri='design:page_head.tpl'}

<link rel="stylesheet" type="text/css" href={"stylesheets/print.css"|ezdesign} media="print" />
<!-- IE conditional comments; for bug fixes for different IE versions -->
<!--[if IE 5]> <style type="text/css"> @import url({"stylesheets/browsers/ie5.css"|ezdesign(no)}); </style> <![endif]-->
<!--[if IE 6]> <style type="text/css"> @import url({"stylesheets/browsers/ie6.css"|ezdesign(no)}); </style> <![endif]-->
<!--[if IE 7]> <style type="text/css"> @import url({"stylesheets/browsers/ie7.css"|ezdesign(no)}); </style> <![endif]-->

</head>
<body>
<div id="page" class="{$pagestyle}">
  <div id="header" class="float-break">
    <div id="logo">
        <a href={"/"|ezurl} title="{ezini('SiteSettings','SiteName')}"><img src={'teamroom/logo.png'|ezimage()} alt="{'Teamroom Logo'|i18n('ezteamroom/teamroom')}" /></a>
    </div>
    <div id="links">
        <ul class="float-break">
            {if $pagedesign.data_map.login_label.has_content}
            <li><div class="links_li">
                <a id="links_login_a" href={"/user/login"|ezurl} title="{$pagedesign.data_map.login_label.data_text|wash}"></a>
                <div class="link-text">
                    <a id="links_login_a" href={"/user/login"|ezurl} title="{$pagedesign.data_map.login_label.data_text|wash}">{$pagedesign.data_map.login_label.data_text|wash}</a>
                </div>
            </div></li>
            {/if}
            {if $pagedesign.data_map.register_user_label.has_content}
            <li><div class="links_li">
                <a id="links_register_a" href={"/user/register"|ezurl} title="{$pagedesign.data_map.register_user_label.data_text|wash}"></a>
                <div class="link-text">
                    <a id="links_register_a" href={"/user/register"|ezurl} title="{$pagedesign.data_map.register_user_label.data_text|wash}">{$pagedesign.data_map.register_user_label.data_text|wash}</a>
                </div>
            </div></li>
            {/if}
        </ul>
    </div>
    <p class="hide"><a href="#main">{"Skip to main content"|i18n( 'ezteamroom/teamroom' )}</a></p>
  </div>
  <div id="path_search" class="float-break">
    <div id="path">
        {include uri='design:parts/path.tpl'}
    </div>
      <div id="searchbox">
      </div>
    </div>
  <div id="topmenu" class="float-break">
  </div>
  <div id="columns" class="float-break">
    <div id="sidemenu-position">
      <div id="sidemenu">
       </div>
    </div>
    <div id="main-position">
      <div id="main" class="float-break">
        <div class="overflow-fix">

          {$module_result.content}

        </div>
      </div>
    </div>
    <div id="extrainfo-position">
      <div id="extrainfo">
      </div>
    </div>
  </div>

{include uri='design:page_footer.tpl'}

</div>

<!--DEBUG_REPORT-->
</body>
</html>
