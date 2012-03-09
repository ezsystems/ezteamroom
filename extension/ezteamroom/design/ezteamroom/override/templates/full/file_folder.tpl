{def $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )
     $frontpagestyle = 'noleftcolumn rightcolumn'
     $valid_classes_identifiers = array( $class_identifier_map['file'],
                                         $class_identifier_map['lightbox'],
                                         $class_identifier_map['image'],
                                         $class_identifier_map['quicktime'],
                                         $class_identifier_map['windows_media'],
                                         $class_identifier_map['real_video'],
                                         $class_identifier_map['file_subfolder'] )
     $valid_class_ids = array()
     $valid_class_list = fetch( 'class', 'list', hash( 'class_filter', $valid_classes_identifiers,
                                                 'sort_by', array( 'name', true() ) ) )
     $page_limit = first_set( ezpreference( 'teamroom_files_list_limit' ), 10 )
     $children = array()
     $children_count = ''}

{foreach $valid_class_list as $valid_class}
    {set $valid_class_ids = $valid_class_ids|append($valid_class.id)}
{/foreach}

{if $page_limit|eq(-1)}
    {set $page_limit = ''}
{/if}

{* sorting *}
{def $available_sortings = hash( 'published',        array( false(), 'Date'|i18n( 'ezteamroom/files' ) ),
                                 'name',             array( true(), 'Name'|i18n( 'ezteamroom/files' ) ),
                                 'class_identifier', array( true(), 'Type'|i18n( 'ezteamroom/files' ) ) )}

{if and( is_set($view_parameters.sortfield), $view_parameters.sortfield, is_set($available_sortings[$view_parameters.sortfield]))}
    {def $sort_by = array( $view_parameters.sortfield, $available_sortings[$view_parameters.sortfield].0 )
         $url_sort = concat( "/(sortfield)/", $view_parameters.sortfield, )}
{else}
    {def $sort_by = array( 'published', false() )
         $url_sort = ''}
{/if}

{* classfilter *}
{def $class_filter = array()}
{if and( is_set($view_parameters.class), $view_parameters.class )}
    {def $tmpclass_filter = $view_parameters.class|explode('_')}
    {if count($tmpclass_filter)}
        {foreach $tmpclass_filter as $class_id}
            {if $valid_class_ids|contains($class_id)}
                {set $class_filter = $class_filter|append($class_id)}
            {/if}
        {/foreach}
    {/if}
    {undef $tmpclass_filter}
{/if}
{if count( $class_filter )}
    {set $class_filter = $class_filter|unique()|array_sort()}
    {def $url_class = concat( "/(class)/", $class_filter|implode( '_' ) )}
{else}
    {set $class_filter = $valid_class_ids|array_sort()}
    {def $url_class = ''}
{/if}

{* tag filter *}
{if and( is_set( $view_parameters.tag ), $view_parameters.tag )}
    {def $url_tag = concat( '/(tag)/', $view_parameters.tag )}
{else}
    {def $url_tag = ''}
{/if}

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
                                {set $children_count = fetch( 'content', 'keyword_count', hash( 'alphabet',             $view_parameters.tag|rawurldecode,
                                                                                                'include_duplicates',   false(),
                                                                                                'parent_node_id',       $node.node_id,
                                                                                                'classid',              $class_filter ) )
                                     $children = fetch( 'content', 'keyword', hash( 'alphabet',             $view_parameters.tag|rawurldecode,
                                                                                    'include_duplicates',   false(),
                                                                                    'parent_node_id',       $node.node_id,
                                                                                    'classid',              $class_filter,
                                                                                    'sort_by',              $sort_by,
                                                                                    'offset',               $view_parameters.offset,
                                                                                    'limit',                $page_limit ) )}
                                {foreach $children as $child sequence array( 'bgdark', 'bglight' ) as $style}
                                    {node_view_gui view='fileline' content_node=$child.link_object style=$style}
                                {/foreach}

                            {else}
                                {set $children_count=fetch( 'content', 'list_count', hash( 'parent_node_id',        $node.node_id,
                                                                                           'class_filter_type',     'include',
                                                                                           'class_filter_array',    $class_filter ) )
                                    $children=fetch( 'content', 'list', hash( 'parent_node_id',     $node.node_id,
                                                                              'class_filter_type',  'include',
                                                                              'class_filter_array', $class_filter,
                                                                              'sort_by',            $sort_by,
                                                                              'offset',             $view_parameters.offset,
                                                                              'limit',              $page_limit ) )}

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

{if or( $children_count|gt( 0 ), is_set( $view_parameters.class ), is_set( $view_parameters.tag ) )}

            <div class="sort-by">
                <h3>{'Sort By'|i18n('ezteamroom/files')}</h3>
                <div class="tags">
                    <ul>
                    {foreach $available_sortings as $sortfield => $sortinfo}
                        <li {if $sort_by.0|eq($sortfield)}class="selected"{/if}>
                            <a href={concat( $node.url_alias, $url_class, "/(sortfield)/", $sortfield, $url_tag)|ezurl} title="{$sortinfo.1|wash()}">{$sortinfo.1|wash()}</a>
                        </li>
                    {/foreach}
                    </ul>
                </div>
            </div>

            <div class="categories">
                <h3>{'Type'|i18n('ezteamroom/files')}</h3>
                <div class="tags">
                    <ul>
                        {def $is_classfilter = $url_class|ne('')}
                        <li {if $is_classfilter|not()}class="selected"{/if}>
                            <a href={concat( $node.url_alias, $url_sort, $url_tag )|ezurl()} title="{'Files of all types are shown'|i18n( 'ezteamroom/files' )|wash()}">{'All'|i18n( 'ezteamroom/files' )|wash()}</a>
                        </li>

                        {def $new_class_filter = null
                             $new_url_class = null
                             $is_activefilter = false()}
                        {foreach $valid_class_list as $class}
                            {set $is_activefilter = and( $is_classfilter, $class_filter|contains( $class.id ))}
                            {if $is_activefilter}
                                {set $new_class_filter = array()}
                                {foreach $class_filter as $class_id}
                                    {if $class_id|ne( $class.id )}
                                        {set $new_class_filter = $new_class_filter|append($class_id)}
                                    {/if}
                                {/foreach}
                                {set $new_url_class = cond( count($new_class_filter)|eq(0), '' ,concat( '/(class)/', $new_class_filter|implode( '_' ) ) )}
                                <li class="selected">
                                    <a href={concat( $node.url_alias, $new_url_class, $url_sort, $url_tag )|ezurl()} title="{'Do not show files of type "%1"'|i18n( 'ezteamroom/files', , array( $class.name ) )|wash()}">{$class.name|wash()}</a>
                                </li>
                            {else}
                                {if $is_classfilter}
                                    {set $new_class_filter = $class_filter|append( $class.id )|unique()|array_sort()}
                                    {set $new_url_class = cond( count($new_class_filter)|eq(count($valid_class_list)), '' ,concat( '/(class)/', $new_class_filter|implode( '_' ) ) )}
                                {else}
                                    {set $new_url_class = concat( '/(class)/', $class.id )}
                                {/if}
                                <li>
                                    <a href={concat( $node.url_alias, $new_url_class, $url_sort, $url_tag )|ezurl()} title="{'Show only files of the type "%1"'|i18n( 'ezteamroom/files', , array( $class.name ) )|wash()}">{$class.name|wash()}</a>
                                </li>
                            {/if}
                        {/foreach}
                        {undef $is_classfilter $new_class_filter $new_url_class $is_activefilter}
                    </ul>
                </div>
            </div>

            <div class="keywords">
                <h3>{'Keywords'|i18n('ezteamroom/files')}</h3>

                {def $fileTagList = ezkeywordlist( $class_filter,
                                                   $node.node_id,
                                                   $node.depth|inc())}

                <div class="tags">

                {def $enc_keyword = null}
                {if $fileTagList|count()|gt( 0 )}
                    {foreach $fileTagList as $keyword}
                        {set $enc_keyword = $keyword.keyword|rawurlencode()}
                        {if and( is_set( $view_parameters.tag ), $view_parameters.tag|eq( $enc_keyword ) )}

                            <a href={concat( $node.url_alias, $url_class, $url_sort )|ezurl()} title="{'Only files with tag "%1" are shown'|i18n( 'ezteamroom/files', , array( $keyword.keyword ) )|wash()}" class="selected">{$keyword.keyword|wash()}</a>

                        {else}

                            <a href={concat( $node.url_alias, $url_class, $url_sort, "/(tag)/", $enc_keyword )|ezurl()} title="{'Shown only files with tag "%1"'|i18n( 'ezteamroom/files', , array( $keyword.keyword ) )|wash()}">{$keyword.keyword|wash()}</a>

                        {/if}

                        {delimiter}, {/delimiter}

                    {/foreach}

                {else}

                    {'No tags available'|i18n( 'ezteamroom/tags' )}

                {/if}

                </div>

                {undef $enc_keyword}

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
