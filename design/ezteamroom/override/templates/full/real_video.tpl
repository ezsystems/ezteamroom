{* Real video - Full view *}

<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-view-full">
    <div class="class-real_video">

    <div class="attribute-header">
    <h1>{$node.name|wash()}</h1>
    </div>
    
    <div class="attribute-short">
        {attribute_view_gui attribute=$node.data_map.description}
    </div>

    <div class="content-media">
    {def $attribute=$node.data_map.file}
        <object classid="clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA"
                {section show=$attribute.content.width|gt( 0 )}width="{$attribute.content.width}"{/section} {section show=$attribute.content.height|gt( 0 )}height="{$attribute.content.height}"{/section}>
        <param name="src" value={concat("content/download/",$attribute.contentobject_id,"/",$attribute.content.contentobject_attribute_id,"/",$attribute.content.original_filename|rawurlencode() )|ezurl} />
        <param name="controls" value="{$attribute.content.controls}" />
        <param name="autostart" value="{section show=$attribute.content.is_autoplay}true{/section}" />
        <embed src={concat("content/download/",$attribute.contentobject_id,"/",$attribute.content.contentobject_attribute_id,"/",$attribute.content.original_filename|rawurlencode() )|ezurl}
               {*pluginspage="{$attribute.content.pluginspage}"*}
               pluginspage="http://real.com"
               type="audio/x-pn-realaudio-plugin"
               {section show=$attribute.content.width|gt( 0 )}width="{$attribute.content.width}"{/section} {section show=$attribute.content.height|gt( 0 )}height="{$attribute.content.height}"{/section} autostart="{section show=$attribute.content.is_autoplay}true{/section}"
               controls="{$attribute.content.controls}" >
        </embed>
        </object>
    </div>

    </div>
</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>