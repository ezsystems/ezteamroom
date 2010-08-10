{def $default_limit = 15}

{if ezpreference( 'teamroom_blog_list_limit' )}

    {set $default_limit = ezpreference( 'teamroom_blog_list_limit' )}

{/if}

{def $page_limit = first_set( $default_limit, 5 )}

{if and( is_set($view_parameters.limit), $view_parameters.limit|gt(0))}

    {set $page_limit = $view_parameters.limit}

{/if}

{def $frontpagestyle='noleftcolumn rightcolumn'}
<div class="content-view-full">
    <div class="class-blog {$frontpagestyle}">

    <div class="attribute-header">
        <h1>{attribute_view_gui attribute=$node.data_map.name}
        {def $current_user = fetch( 'user', 'current_user' )}
        {if eq( $current_user.contentobject_id, $node.object.owner.id )}
            <a href={concat("content/edit/",$node.object.id,'/f/',ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini'))|ezurl}><img src={'task_edit.gif'|ezimage} alt="{'Edit description'|i18n('ezteamroom/blog')}"/></a>
        {/if}
        {undef $current_user}
        </h1>
    </div>


    {if $node.object.data_map.description.has_content}
        <div class="attribute-long">
            {attribute_view_gui attribute=$node.data_map.description}
        </div>
    {/if}

    <div class="columns-frontpage float-break">
        <div class="center-column-position">
            <div class="center-column float-break">
                <div class="overflow-fix">
                <!-- Content: START -->



            <div class="class-blog float-break">
                <div class="border-box">
                <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
                <div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

                    {set $page_limit = first_set( $default_limit, 5 )}
                    {def  $blogs = array()
                         $blogs_count = 0
                         $uniq_id = 0
                         $uniq_post = array()
                         $class_identifier_map = ezini( 'TeamroomSettings', 'ClassIdentifiersMap', 'teamroom.ini' )}

                    {if is_set($view_parameters.tag)}

                        {set $blogs_count = fetch( 'content', 'keyword_count', hash( 'alphabet', $view_parameters.tag|rawurldecode,
                                                                        'parent_node_id', $node.node_id ) )
                             $blogs = fetch( 'content', 'keyword', hash( 'alphabet', $view_parameters.tag|rawurldecode,
                                                                        'parent_node_id', $node.node_id,
                                                                        'offset', $view_parameters.offset,
                                                                        'sort_by', array( 'attribute', false(), concat( $class_identifier_map['blog_post'], '/publication_date' ) ),
                                                                        'limit', cond($page_limit|eq(-1), $blogs_count, $page_limit ) ) )}

                        {foreach $blogs as $blog}
                            {set $uniq_id = $blog.link_object.node_id}
                            {if $uniq_post|contains( $uniq_id )|not}
                            {node_view_gui view=line content_node=$blog.link_object}
                            {set $uniq_post = $uniq_post|append( $uniq_id )}
                            {/if}
                        {/foreach}
                    {else}
                        {if and( $view_parameters.month, $view_parameters.year )}
                            {def $start_date = maketime( 0,   0,  0, $view_parameters.month, cond( ne( $view_parameters.day , ''), $view_parameters.day, '01' ), $view_parameters.year)
                                   $end_date = maketime( 23, 59, 59, $view_parameters.month, cond( ne( $view_parameters.day , ''), $view_parameters.day, makedate( $view_parameters.month, '01', $view_parameters.year)|datetime( 'custom', '%t' ) ), $view_parameters.year)}

                            {set $blogs = fetch( 'content', 'list', hash( 'parent_node_id', $node.node_id,
                                                                'offset', $view_parameters.offset,
                                                                'attribute_filter', array( and,
                                                                                            array( concat( $class_identifier_map['blog_post'], '/publication_date' ), '>=', $start_date ),
                                                                                            array( concat( $class_identifier_map['blog_post'], '/publication_date' ), '<=', $end_date ) ),
                                                                'sort_by', array( 'attribute', false(), concat( $class_identifier_map['blog_post'], '/publication_date' ) ),
                                                                'limit', $page_limit ) )
                                $blogs_count = fetch( 'content', 'list_count', hash( 'parent_node_id', $node.node_id,
                                                                                    'attribute_filter', array( and,
                                                                                            array( concat( $class_identifier_map['blog_post'], '/publication_date' ), '>=', $start_date ),
                                                                                            array( concat( $class_identifier_map['blog_post'], '/publication_date' ), '<=', $end_date) ) ) )}

                            {foreach $blogs as $blog}
                                {node_view_gui view=line content_node=$blog}
                            {/foreach}
                        {else}
                            {set $blogs = fetch( 'content', 'list', hash( 'parent_node_id', $node.node_id,
                                                                'offset', $view_parameters.offset,
                                                                'sort_by', array( 'attribute', false(), concat( $class_identifier_map['blog_post'], '/publication_date' ) ),
                                                                'limit', $page_limit ) )
                                $blogs_count = fetch( 'content', 'list_count', hash( 'parent_node_id', $node.node_id ) )}

                            {foreach $blogs as $blog}
                                {node_view_gui view=line content_node=$blog}
                            {/foreach}
                        {/if}
                    {/if}

                                {include name=navigator
                                        uri='design:navigator/google.tpl'
                                        page_uri=$node.url_alias
                                        item_count=$blogs_count
                                        view_parameters=$view_parameters
                                        item_limit=$page_limit
                                        preference      = "teamroom_blog_list_limit"}

                                    </div></div></div>
                                    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
                                    </div>
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
                    {def $can_create = fetch( 'content', 'access', hash( 'access', 'create', 'contentobject', $node, 'contentclass_id', $class_identifier_map['blog_post'] ) )}

                    {if $can_create}

                <div class="create-task">
                        <form method="post" action={"content/action/"|ezurl}>
                            <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                            <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
                            <input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                            <input type="hidden" name="NodeID" value="{$node.node_id}" />
                            <input type="hidden" name="ClassIdentifier" value="{$class_identifier_map['blog_post']}" />
                            <input type="hidden" name="RedirectURIAfterPublish" value="{$node.url_alias}" />
                            <input type="hidden" name="RedirectIfDiscarded" value="{$node.url_alias}" />
                            <div class="submitimage">
                             <div class="emptyButton">
                              <input class="mousePointer emptyButton" type="submit" name="NewButton" value="{'Add new entry'|i18n( 'ezteamroom/blog' )}" />
                             </div>
                            </div>
                        </form>
            </div>

                    {/if}

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

{if or( $blogs_count|gt( 0 ), is_set( $view_parameters.tag ) )}

            <div class="keywords">
                <h3>{'Keywords'|i18n('ezteamroom/blog')}</h3>

                {def     $sorting = cond( $sort_by_field, concat( "/(sortfield)/", $sort_by_field ) )
                     $blogTagList = ezkeywordlist( $class_identifier_map['blog_post'], $node.node_id )}

                <div class="tags">

                {if $blogTagList|count()|gt( 0 )}

                    {foreach $blogTagList as $keyword}

                        {if and( is_set( $view_parameters.tag ), $view_parameters.tag|eq( $keyword.keyword ) )}

                 <a href={concat( $node.url_alias, $sorting )|ezurl()} title="{'Only entries with tag "%1" are shown'|i18n( 'ezteamroom/blog', , array( $keyword.keyword ) )|wash()}" class="selected">{$keyword.keyword|wash()}</a>

                        {else}

                 <a href={concat( $node.url_alias, "/(tag)/", $keyword.keyword|rawurlencode(), $sorting )|ezurl()} title="{'Shown only entries with tag "%1"'|i18n( 'ezteamroom/blog', , array( $keyword.keyword ) )|wash()}">{$keyword.keyword|wash()}</a>

                        {/if}

                        {delimiter}, {/delimiter}

                    {/foreach}

                {else}

                    {'No tags available'|i18n( 'ezteamroom/tags' )}

                {/if}
                </div>
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
