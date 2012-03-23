{* Image - List item view *}
<span class="listitem_image">
    <span class="name">
    <strong>{$node.name|wash}</strong>
    <div class="attribute-image">
        <p>{attribute_view_gui attribute=$node.data_map.image image_class=tiny href=$node.url_alias|ezurl()}</p>
    </div>
    </span>
</span>
