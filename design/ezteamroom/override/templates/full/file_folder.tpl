{def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
     $frontpagestyle = 'noleftcolumn rightcolumn'
     $classList      = fetch( 'class', 'list', hash( 'class_filter', array( $class_identifier_map['file'] ) ) )}

{def $default_limit = 15}

{if ezpreference( 'teamroom_files_list_limit' )}

    {set $default_limit = ezpreference( 'teamroom_files_list_limit' )}

{/if}

{def    $page_limit = first_set( $default_limit, 5 )
        $classes = array( $class_identifier_map['file'],
                          $class_identifier_map['lightbox'],
                          $class_identifier_map['image'],
                          $class_identifier_map['quicktime'],
                          $class_identifier_map['windows_media'],
                          $class_identifier_map['real_video'],
                          $class_identifier_map['file_subfolder'] )
        $children = array()
        $children_count = ''}

{if and(is_set($view_parameters.limit), $view_parameters.limit|gt(0))}

    {set $page_limit = $view_parameters.limit}

{/if}

{if $page_limit|eq(-1)}

    {set $page_limit = $children_count}

{/if}

{def $url = concat('/', $node.url_alias)}

{foreach $view_parameters as $key => $value}

    {if $value}

        {set $url=concat($url,'/(',$key,')/',$value)}

    {/if}

{/foreach}

{def $sort_field_list     = array( 'published', 'name', 'owner', 'class_identifier' )
     $sort_field_name     = 'published'
     $sort_by_field       = false()
     $sort_by_direction   = true()
     $sort_by             = false()
     $view_parameter_text = false()}


{if and( is_set($view_parameters.sortfield), $view_parameters.sortfield, $sort_field_list|contains($view_parameters.sortfield) )}
    {set $sort_by_field = $view_parameters.sortfield}
{/if}
{if and( is_set($view_parameters.sortorder), $view_parameters.sortorder, $view_parameters.sortorder|eq( 'desc' ) )}
    {set $sort_by_direction = false()}
{/if}
{if $sort_by_field}
    {set $sort_by = array( $sort_by_field, $sort_by_direction, )}
{/if}

{def $view_finished='<'}
{if and( is_set($view_parameters.viewfinished), $view_parameters.viewfinished|eq('true'))}
    {set $view_finished='<='}
{/if}

{foreach $view_parameters as $key => $value}
    {if and($value, $key|ne('sortfield'),$key|ne('sortorder'))}
        {set $view_parameter_text=concat($view_parameter_text,'/(',$key,')/',$value)}
    {/if}
{/foreach}

{* Used in line views of files *}
{literal}
<script language="JavaScript" type="text/javascript">
<!--
    function confirmDelete( type )
    {
        var text = {/literal}"{'Are you sure you want to remove the file?'|i18n( 'ezteamroom/files' )}"{literal};
        if ( type == 'folder' )
        {
            text = {/literal}"{'Are you sure you want to remove the folder?'|i18n( 'ezteamroom/files' )}"{literal};
        }
        var confirmation = confirm( text );
        if ( confirmation )
        {
            return true;
        }
        else
        {
            return false;
        }
    }
-->
</script>
{/literal}

<div class="content-view-full">
    <div class="class-file-folder {$frontpagestyle}">

    <div class="attribute-header">
        <h1>{attribute_view_gui attribute=$node.data_map.name}

        {*if teamroom owner is logged in allow edit*}
        {def $current_user = fetch( 'user', 'current_user' )}
        {if eq( $current_user.contentobject_id, $node.object.owner.id )}
            <a href={concat("content/edit/",$node.object.id,'/f/',ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini'))|ezurl}><img src={'task_edit.gif'|ezimage} alt="{'Edit description'|i18n('ezteamroom/files')}"/></a>
        {/if}

        {if $node.class_identifier|eq( $class_identifier_map['file_subfolder'] )}
            <span style="font-size: 10pt;">[ <a href={$node.parent.url_alias|ezurl()}>{'One level up'|i18n('ezteamroom/files')|wash()}</a> ]</span>
        {/if}

        </h1>
    </div>

    {if $node.object.data_map.description.has_content}
        <div class="attribute-long">
            {attribute_view_gui attribute=$node.data_map.description}
        </div>
    {/if}

    <br />
    <br />

    <div class="columns-frontpage float-break">

        <div class="center-column-position">
            <div class="center-column float-break">
                <div class="overflow-fix">
                <!-- Content: START -->
                    <div class="border-box">
                    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
                    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

                            {if is_set( $view_parameters.tag )}
                                {set $children_count = fetch( 'content', 'keyword_count', hash( 'alphabet', $view_parameters.tag|rawurldecode,
                                                                                'include_duplicates', false(),
                                                                                'parent_node_id', $node.node_id ) )
                                     $children = fetch( 'content', 'keyword', hash( 'alphabet', $view_parameters.tag|rawurldecode,
                                                                                'include_duplicates', false(),
                                                                                'parent_node_id', $node.node_id,
                                                                                'offset', $view_parameters.offset,
                                                                                'sort_by', $sort_by,
                                                                                'limit', $page_limit ) )}
                                {foreach $children as $child sequence array( 'bgdark', 'bglight' ) as $style}
                                    {node_view_gui view='fileline' content_node=$child.link_object style=$style}
                                {/foreach}

                            {else}
                                {if is_set( $view_parameters.category )}
                                {set $children=fetch_alias( 'children', hash( 'parent_node_id', $node.node_id,
                                                                            'offset', $view_parameters.offset,
                                                                            'sort_by', $sort_by,
                                                                            'class_filter_type', 'include',
                                                                            'class_filter_array', $classes,
                                                                            'attribute_filter', array( array( 'file/category', '=', $view_parameters.category ) ),
                                                                            'limit', $page_limit ) )
                                    $children_count=fetch_alias( 'children_count', hash( 'parent_node_id', $node.node_id,
                                                                                        'class_filter_type', 'include',
                                                                                        'attribute_filter', array( array( 'file/category', '=', $view_parameters.category ) ),
                                                                                        'class_filter_array', $classes ) )}
                                {else}
                                {set $children=fetch_alias( 'children', hash( 'parent_node_id', $node.node_id,
                                                                            'offset', $view_parameters.offset,
                                                                            'sort_by', $sort_by,
                                                                            'class_filter_type', 'include',
                                                                            'class_filter_array', $classes,
                                                                            'limit', $page_limit ) )
                                    $children_count=fetch_alias( 'children_count', hash( 'parent_node_id', $node.node_id,
                                                                                        'class_filter_type', 'include',
                                                                                        'class_filter_array', $classes ) )}
                                {/if}

                                <div class="content-view-children">

                                    {foreach $children as $child sequence array( 'bgdark', 'bglight' ) as $style}

                                    <a name="Node{$child.main_node_id}"></a>

                                        {node_view_gui view='fileline' content_node=$child style=$style}

                                    {/foreach}

                                </div>
                            {/if}

                            {include name=navigator
                                     uri='design:navigator/google.tpl'
                                     page_uri=$node.url_alias
                                     item_count=$children_count
                                     view_parameters=$view_parameters
                                     item_limit=$page_limit
                                     show_limit_sel=cond($children_count|ne(0),true(),false())
                                     preference="teamroom_files_list_limit"}

                    </div></div></div>
                    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
                    </div>


                <!-- Content: END -->
                </div>
            </div>
        </div>
        <div class="right-column-position">
            <div class="right-column">
            <!-- Content: START -->
                    <div class="border-box">
                    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
                    <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

                {def $can_create = fetch( 'content', 'access', hash( 'access', 'create', 'contentobject', $node, 'contentclass_id', $class_identifier_map['file_subfolder'] ) )}
                {if $can_create}
                    <div class="create-file">
                    <form action={"/content/action"|ezurl()} method="post" name="CreateNewFolder">
                        <input type="hidden" value="{$node.node_id}" name="NodeID"/>
                        <input type="hidden" value="{$node.url_alias}" name="RedirectURIAfterPublish"/>
                        <input type="hidden" value="{$node.url_alias}" name="CancelURI"/>
                        <input type="hidden" value="{$class_identifier_map['file_subfolder']}" name="ClassIdentifier"/>
                        <input type="hidden" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" name="ContentLanguageCode"/>
                        <div class="submitimage">
                             <div class="emptyButton">
                              <input class="mousePointer emptyButton" type="submit" name="NewButton" value="{'Create folder'|i18n( 'ezteamroom/files' )}" title="{'Create a new folder'|i18n( 'ezteamroom/files' )}" />
                             </div>
                        </div>
                    </form>
                    </div>
                {/if}

                {set $can_create = fetch( 'content', 'access', hash( 'access', 'create', 'contentobject', $node, 'contentclass_id', $class_identifier_map['file'] ) )}
                {if $can_create}
                    <div class="create-file">
                    <form action={"/content/action"|ezurl()} method="post" name="CreateNewFile">
                        <input type="hidden" value="{$node.node_id}" name="NodeID"/>
                        <input type="hidden" value="{$node.url_alias}" name="RedirectURIAfterPublish"/>
                        <input type="hidden" value="{$node.url_alias}" name="CancelURI"/>
                        <input type="hidden" value="{$class_identifier_map['file']}" name="ClassIdentifier"/>
                        <input type="hidden" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" name="ContentLanguageCode"/>
                        <div class="submitimage">
                             <div class="emptyButton">
                              <input class="mousePointer emptyButton" type="submit" name="NewButton" value="{'Upload file'|i18n( 'ezteamroom/files' )}" title="{'Upload a single file'|i18n( 'ezteamroom/files' )}" />
                             </div>
                        </div>
                    </form>
                    </div>

            {def       $activeExtensionsArray = ezini( 'ExtensionSettings', 'ActiveExtensions', 'site.ini' )
                 $activeAccessExtensionsArray = ezini( 'ExtensionSettings', 'ActiveAccessExtensions', 'site.ini' )}

            {*ezmultifileupload*}
            {if or( $activeExtensionsArray|contains( 'ezmultiupload' ), $activeAccessExtensionsArray|contains( 'ezmultiupload' ) )}

                {if and( or( ezini( 'MultiUploadSettings', 'AvailableSubtreeNode', 'ezmultiupload.ini' )|contains( $node.node_id ),
                             ezini( 'MultiUploadSettings', 'AvailableClasses', 'ezmultiupload.ini' )|contains( $node.class_identifier ) ),
                         and( $node.object.can_create, $node.object.content_class.is_container ),
                         fetch( 'user', 'has_access_to', hash( 'module', 'ezmultiupload', 'function', 'use' ) ) )}

            <div class="create-file">
                <form method="post" action={concat("/ezmultiupload/upload/",$node.node_id)|ezurl}>

                            <div class="submitimage">
                             <div class="emptyButton">
                              <input class="mousePointer emptyButton" type="submit" name="NewButton" value="{'Upload multiple files'|i18n( 'ezteamroom/files' )}" title="{'Upload more than one file at the same time'|i18n( 'ezteamroom/files' )}" />
                             </div>
                </div>
                </form>
            </div>

                {/if}

            {/if}

            {undef $activeExtensionsArray $activeAccessExtensionsArray}
            {*ezmultifileupload*}

                {/if}
                {undef $can_create}

                {def    $can_create = fetch( 'content', 'access', hash( 'access', 'create', 'contentobject', $node, 'contentclass_id', $class_identifier_map['lightbox'] ) )
                      $lightboxList = fetch( 'lightbox', 'list', hash( 'userID',     $current_user.contentobject_id,
                                                                       'asObject',   true(),
                                                                       'otherMasks', array( '3' )
                                                                     )
                                           )
                     $hasLightboxes = and( is_array( $lightboxList ), $lightboxList|count()|gt( 0 ) )}

                {undef $current_user}

                {if and( $can_create, $hasLightboxes )}
                    <div class="create-file">
                    <form action={"/content/action"|ezurl()} method="post" name="CreateNewFile">
                        <input type="hidden" value="{$node.node_id}" name="NodeID"/>
                        <input type="hidden" value="{$node.url_alias}" name="RedirectURIAfterPublish"/>
                        <input type="hidden" value="{$node.url_alias}" name="CancelURI"/>
                        <input type="hidden" value="{$class_identifier_map['lightbox']}" name="ClassIdentifier"/>
                        <input type="hidden" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" name="ContentLanguageCode"/>
                        <div class="submitimage">
                             <div class="emptyButton">
                              <input class="mousePointer emptyButton" type="submit" name="NewButton" value="{'Add lightbox'|i18n( 'ezteamroom/files' )}" title="{'Add one of your lightboxes to the file list'|i18n( 'ezteamroom/files' )}" />
                             </div>
                        </div>
                    </form>
                    </div>
                {/if}
                {undef $can_create}

            <div class="create-task">
                <form method="post" action={"content/action/"|ezurl}>
                    <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                    <div class="keepupdated">
                        <div class="arrowWhiteButton">
                         <input class="mousePointer arrowWhiteButton" type="submit" name="ActionAddToNotification" value="{'Keep me updated'|i18n( 'ezteamroom/keepmeupdated' )}" title="{'Receive an email if anything changes in this area'|i18n( 'ezteamroom/keepmeupdated' )}" />
                        </div>
                    </div>
                </form>
            </div>

{if or( $children_count|gt( 0 ), is_set( $view_parameters.category ), is_set( $view_parameters.tag ) )}

            <div class="sort-by">
                <h3>{'Sort By'|i18n('ezteamroom/files')}</h3>
                {def $sorting=hash( 'name' , 'Name'|i18n( 'ezteamroom/files' ), 'published' , 'Date'|i18n( 'ezteamroom/files' ), 'class_identifier' , 'Type'|i18n( 'ezteamroom/files' ) )}
                <div class="tags">
                    <ul>
                    {foreach $sorting as $key => $keyword}
                        <li {if $sort_by_field|eq($key)}class="selected"{/if}>
                            <a href={concat( $node.url_alias, "/(sortfield)/", $key)|ezurl} title="{$keyword}">{$keyword|wash()}</a>
                        </li>
                    {/foreach}
                    </ul>
                </div>
                {undef $sorting}
            </div>

            <div class="categories">
                <h3>{'Categories'|i18n('ezteamroom/files')}</h3>

                {def $sorting = cond( $sort_by_field, concat( "/(sortfield)/", $sort_by_field ) )
                     $title   = ''}

                <div class="tags">
                    <ul>

                    {foreach $classList.0.data_map.category.content.options as $index => $configuration}

                        {* Workaround for ezselection not beeing translatable *}

                        {set $title = $configuration.name}

                        {switch match = $configuration.name}
                            {case match='Documents'} {set $title = 'Documents'|i18n( 'ezteamroom/files' )}{/case}
                            {case match='Sounds'}    {set $title = 'Sounds'|i18n( 'ezteamroom/files' )}{/case}
                            {case match='Pictures'}  {set $title = 'Pictures'|i18n( 'ezteamroom/files' )}{/case}
                            {case match='Lightboxes'}{set $title = 'Lightboxes'|i18n( 'ezteamroom/files' )}{/case}
                        {/switch}

                        {if and( is_set( $view_parameters.category ), $view_parameters.category|eq( $configuration.id ))}

                        <li class="selected">
                         <a href={concat( $node.url_alias, $sorting )|ezurl()} title="{'Only files of category "%1" are shown'|i18n( 'ezteamroom/files', , array( $title ) )|wash()}">{$title|wash()}</a>
                        </li>

                        {else}

                        <li>
                         <a href={concat( $node.url_alias, "/(category)/", $configuration.id, $sorting )|ezurl()} title="{'Show only files of the category "%1"'|i18n( 'ezteamroom/files', , array( $title ) )|wash()}">{$title|wash()}</a>
                        </li>

                        {/if}

                    {/foreach}

                    </ul>
                </div>

                {undef $selection $sorting}

            </div>

            <div class="keywords">
                <h3>{'Keywords'|i18n('ezteamroom/files')}</h3>

                {def     $sorting = cond( $sort_by_field, concat( "/(sortfield)/", $sort_by_field ) )
                     $fileTagList = ezkeywordlist( array( $class_identifier_map['file'], $class_identifier_map['file_subfolder'] ),
                                                   $node.node_id,
                                                   $node.depth|inc()
                                                 )}

                <div class="tags">

                {if $fileTagList|count()|gt( 0 )}

                    {foreach $fileTagList as $keyword}

                        {if and( is_set( $view_parameters.tag ), $view_parameters.tag|eq( $keyword.keyword ) )}

                    <a href={concat( $node.url_alias, $sorting )|ezurl()} title="{'Only files with tag "%1" are shown'|i18n( 'ezteamroom/files', , array( $keyword.keyword ) )|wash()}" class="selected">{$keyword.keyword|wash()}</a>

                        {else}

                    <a href={concat( $node.url_alias, "/(tag)/", $keyword.keyword|rawurlencode(), $sorting )|ezurl()} title="{'Shown only files with tag "%1"'|i18n( 'ezteamroom/files', , array( $keyword.keyword ) )|wash()}">{$keyword.keyword|wash()}</a>

                        {/if}

                        {delimiter}, {/delimiter}

                    {/foreach}

                {else}

                    {'No tags available'|i18n( 'ezteamroom/tags' )}

                {/if}

                </div>

                {undef $sorting}

            </div>

{/if}

{undef $class_identifier_map}

                    </div></div></div>
                    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
                    </div>
            <!-- Content: END -->
            </div>
        </div>
    </div>

    </div>
</div>
