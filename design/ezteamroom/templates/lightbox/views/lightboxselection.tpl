{def $hasPFBox = false()}

{if is_set( $viewParameters.pfbox )}

    {if $viewParameters.pfbox|eq( '1' )}

        {set $hasPFBox = true()}

<!--PFBOXCONTENT-->
<div class="pf_box">

    {/if}

{/if}

<div class="teamroom-list itemized_sub_items" id="selectLightboxWidgetContent">
 <div class="content-view-embed">
  <div class="border-box">
   <div class="border-tl">
    <div class="border-tr">
     <div class="border-tc"></div>
    </div>
   </div>
   <div class="border-ml">
    <div class="border-mr">
     <div class="border-mc float-break">
      <form action="javascript: sendChangeSelectedLightboxRequest( {'/content/action'|ezurl( 'single' )}, selectLightboxWidgetResponseHandler, 'selectLightboxWidgetContent' );" method="post" id="hiddenlightboxselectionwidgetform">
       <input type="hidden" name="newLightboxID" value="0" id="widgetNewLightboxIDInput" />
       <input type="hidden" name="redirectAfterSelectionURI" value="/lightbox/view/lightboxselection" id="widgetRedirectionInput" />
      </form>

{def $current_user = fetch( 'user', 'current_user' )}

{if $current_user.is_logged_in}

    {def $selected_lightbox_id = ezpreference( 'selectedLightboxID' )
            $selected_lightbox = false()
              $is_own_lightbox = false()
              $additional_text = array()
          $current_lightbox_id = ezpreference( 'currentLightboxID' )
                 $lightboxList = fetch( 'lightbox', 'list', hash( 'userID',     $current_user.contentobject_id,
                                                                  'asObject',   true(),
                                                                  'otherMasks', array( '3' )
                                                                )
                                      )
                $hasLightboxes = and( is_array( $lightboxList ), $lightboxList|count()|gt( 0 ) )}

    {if $selected_lightbox_id|le( 0 )}

        {set $selected_lightbox_id = ezpreference( 'currentLightboxID' )}

    {/if}

    {if $selected_lightbox_id|le( 0 )}

        {if $hasLightboxes}

            {set $selected_lightbox_id = $lightboxList.0.id}

        {/if}

    {/if}

    {if $selected_lightbox_id|gt( 0 )}

        {set $selected_lightbox = fetch( 'lightbox', 'object', hash( 'id', $selected_lightbox_id, 'asObject', true ) )}

    {/if}

    {if $hasLightboxes}

      <select name="selectedLightboxID" onchange="changeSelectedLightbox();" id="lightboxselectionwidget">

        {if $selected_lightbox_id|le( 0 )}

       <option disabled="disabled">{'Select a lightbox'|i18n( 'ezteamroom/lightbox' )}</option>

        {/if}

        {foreach $lightboxList as $lightbox}

            {set $is_own_lightbox = $lightbox.owner_id|eq( $current_user.contentobject_id )}

       <option value="{$lightbox.id}"{cond( $lightbox.id|eq( $selected_lightbox_id ), ' selected="selected"' )}{cond( $is_own_lightbox, ' style="font-weight: bold;"' )}>{$lightbox.name|shorten( 25 )|wash()} ({$lightbox.item_count})</option>

        {/foreach}

      </select>

      <hr />

    {/if}

    {if is_object( $selected_lightbox )}

        {def $isForeignLightbox = $selected_lightbox.owner_id|ne( $current_user.contentobject_id )}

        {if $isForeignLightbox}

            {set $additional_text = $additional_text|append( $selected_lightbox.owner.contentobject.name|wash() )}

        {/if}

        {if $selected_lightbox.id|eq( $current_lightbox_id )}

            {set $additional_text = $additional_text|append( 'current'|i18n( 'ezteamroom/lightbox' ) )}

        {/if}

      <strong>{$selected_lightbox.name|shorten( 33 )|wash()}</strong>

        {if $additional_text|count()|gt( 0 )}

      <div class="lightbox-owner">( {$additional_text|implode( ', ' )} )</div>

        {/if}

        {if $selected_lightbox.item_id_list|count()|gt( 0 )}

            {def $content_object = false()
                    $item_object = false()}

      <ul>

            {foreach $selected_lightbox.item_id_list as $item_id => $type_id sequence array( 'bglight', 'bgdark' ) as $bg}

                {if $type_id|eq( '1' )}

                    {set $content_object = fetch( 'content', 'object', hash( 'object_id', $item_id ) )
                         $object_id      = $item_id}

                {elseif $type_id|eq( '2' )}

                    {set $item_object    = fetch( 'content', 'node', hash( 'node_id', $item_id ) )
                         $content_object = $item_object.object
                         $object_id      = $item_object.object.id}

                {/if}

                {if is_object( $content_object )}

       <li>
                {if eq( $content_object.node.class_identifier, 'file' )}

                    {attribute_view_gui attribute = $content_object.main_node.data_map.file
                                          shorten = 20}

                {else}

        <a href={$content_object.main_node.url_alias|ezurl()}>{node_view_gui content_node = $content_object.main_node
                                                                                     view = 'listitem'}</a>

                {/if}

       </li>

                {/if}

            {/foreach}

            {undef $content_object $item_object}

      </ul>

        {else}

      <p>{'This lightbox is empty.'|i18n( 'ezteamroom/lightbox' )|wash()}</p>

        {/if}

    {else}

      <p>{'You do not have any lightbox yet.'|i18n( 'ezteamroom/lightbox' )|wash()}</p>
      <div class="infobox-link">
 <form class="inline" action={'/lightbox/create'|ezurl()} method="post">
    <div class="add-current-page">
        <input type="hidden" name="redirectURI" value="/" />
        <input type="submit"
               class="add-current-page-button"
               title="{'Create new lightbox'|i18n( 'ezteamroom/lightbox' )}"
               value="{'Create new lightbox'|i18n( 'ezteamroom/lightbox' )}"
               name="CreateNewLightbox" style="font-weight: bold;" />
    </div>
 </form>
      </div>

    {/if}

{else}

      <p>{'You are not logged in.'|i18n( 'ezteamroom/lightbox' )|wash()}</p>
      <p><a href={'/user/register'|ezurl()} title="{'Please register here'|i18n( 'ezteamroom/lightbox' )}">{'Please register here.'|i18n( 'ezteamroom/lightbox' )}</a></p>
      <p><a href={'/user/login'|ezurl()} title="{'Login here'|i18n( 'ezteamroom/lightbox' )}">{'Login here.'|i18n( 'ezteamroom/lightbox' )}</a></p>

{/if}

     </div>
    </div>
   </div>
   <div class="border-bl">
    <div class="border-br">
     <div class="border-bc"></div>
    </div>
   </div>
  </div>
 </div>
</div>

{if $hasPFBox}

</div>

{/if}
