{if $node.object.data_map.module_url.has_content}

    {def $addToURL = concat( '/(object)/', $node.object.id )}

    {if is_set( $addStringToURL )}

        {set $addToURL = concat( $addToURL, $addStringToURL )}

    {/if}

<div class="module-widget">
 <div class="module-content" id="module_content_{$node.object.id}"></div>
 <script type="text/javascript">
        addModuleWidget( {$node.object.id}, "{$node.object.data_map.module_url.value|wash}{$addToURL}" );
 </script>
</div>
<div id="loading_widget_{$node.object.id}" style="display:none">
 <img class="loading" src={"loading.gif"|ezimage()} alt="{"Loading ..."|i18n('ezteamroom/frontpage')}" />
</div>

{else}

<div class="class-infobox">
 <div class="attribute-content">

    {attribute_view_gui attribute=$node.object.data_map.content}

 </div>
</div>

{/if}
