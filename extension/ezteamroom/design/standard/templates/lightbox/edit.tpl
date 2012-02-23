<div class="content-view-full">
 <div class="class-lightbox leftcolumn norightcolumn">
  <div class="columns-lightbox float-break">
   
   <div class="left-column-position">
    <div class="left-column">
     <div class="overflow-fix">

      <div class="border-box" style="margin-bottom: 0.2em;">

       <div class="border-tl">
        <div class="border-tr">
         <div class="border-tc"></div>
        </div>
       </div>

       <div class="border-ml">
        <div class="border-mr">
         <div class="border-mc">

          <h1>{'My Lightboxes'|i18n( 'ezteamroom/lightbox' )}</h1>

{if is_array( $userLightboxList )}
          <ul>
    {foreach $userLightboxList as $lightboxElement sequence array( 'bglight', 'bgdark' ) as $bg}
           <li>
        {if $lightbox.id|eq( $lightboxElement.id )}
            <strong>{$lightboxElement.name|wash()}</strong>
        {else}
            {$lightboxElement.name|wash()}
        {/if}
           </li>
    {/foreach}
         </ul>
{else}
      {'You do not have any lightbox yet.'|i18n( 'ezteamroom/lightbox' )}
{/if}

         </div>
        </div>
       </div> 

       <div class="border-bl">
        <div class="border-br">
         <div class="border-bc"></div>
        </div>
       </div>

      </div> {* border-box *}

      <div class="border-box" style="margin-bottom: 0.2em;">

       <div class="border-tl">
        <div class="border-tr">
         <div class="border-tc"></div>
        </div>
       </div>

       <div class="border-ml">
        <div class="border-mr">
         <div class="border-mc">

          <h1>{'Assets'|i18n( 'ezteamroom/lightbox' )}</h1>

{if $lightbox.object_id_list|count()|gt( 0 )}

    {def $content_object = false}

          <ul>

    {foreach $lightbox.object_id_list as $object_id sequence array( 'bglight', 'bgdark' ) as $bg}

        {set $content_object = fetch( 'content', 'object', hash( 'object_id', $object_id ) )}

        {if is_object( $content_object )}

           <li>{$content_object.name|wash()}</li>

        {/if}

    {/foreach}

          </ul>

{else}

    {'No assets in this lightbox'|i18n( 'ezteamroom/lightbox' )}

{/if}

         </div>
        </div>
       </div>

       <div class="border-bl">
        <div class="border-br">
         <div class="border-bc"></div>
        </div>
       </div>

      </div> {* border-box *}

     </div>
    </div>
   </div> {* left-column-position *}

   <div class="center-column-position">
    <div class="center-column float-break">
     <div class="overflow-fix">

      <div class="border-box" style="margin-bottom: 0.2em;">

       <div class="border-tl">
        <div class="border-tr">
         <div class="border-tc"></div>
        </div>
       </div>

       <div class="border-ml">
        <div class="border-mr">
         <div class="border-mc">

{if and( is_set( $messages ), $messages|count()|gt( 0 ) )}

          <div class="message-{cond( $actionSuccess, 'feedback', true(), 'error' )}">

    {foreach $messages as $message}

           <p>{$message|wash()}</p>

    {/foreach}

          </div>

{/if}

{if is_object( $lightbox )}

          <h1>{'Edit lightbox "%1"'|i18n( 'ezteamroom/lightbox', , hash( '%1', $lightbox.name ) )}</h1>
          <form action={$url|ezurl()} method="post">
           <p>
           {'Name'|i18n( 'ezteamroom/lightbox' )}: <input type="text" name="lightbox_name" value="{$lightbox.name|wash()}" size="50" />
           </p>
           <fieldset>
            <legend>{'Lightbox users'|i18n( 'ezteamroom/lightbox' )}</legend>

    {def $hasUsers = $lightbox.access_list|count()|gt( 0 )}

    {if $hasUsers}

        {def $canGrant = $lightbox.can_grant}

            <table class="list">
             <tr>
              <th class="tight">&nbsp;</th>
              <th class="tight">{'Name'|i18n( 'ezteamroom/lightbox' )}</th>
              <th class="tight">{'Granted'|i18n( 'ezteamroom/lightbox' )}</th>
              <th>{'Rights'|i18n( 'ezteamroom/lightbox' )}</th>
             </tr>

        {foreach $lightbox.access_list as $access sequence array( 'bglight', 'bgdark' ) as $bg}

             <tr class="{$bg}">
              <td><input type="checkbox" name="selectedUserList[]" value="{$access.user.contentobject_id}"{cond( $canGrant|not(), ' disabled="disabled"' )} />
              <td class="nowrap">{$access.user.contentobject.name|wash()}</td>
              <td class="nowrap">{$access.created|l10n( 'datetime' )}</td>
              <td>
               <input type="hidden" name="userFlags[{$access.user.contentobject_id}][]" value="0" /> {* Prevent error if no flag is checked *}

            {foreach $access.access_keys as $key => $text}

               <input type="checkbox" name="userFlags[{$access.user.contentobject_id}][]" value="{$key}"{cond( is_set( $access.flags[$key] ), ' checked="checked"' )}{cond( $canGrant|not(), ' disabled="disabled"' )} />
               <span style="margin-right: 1.0em;">{$text|wash()}</span>

            {/foreach}

              </td>
             </tr>

        {/foreach}

            </table>
    
    {if $hasUsers}
            <input type="submit" name="DeleteUsersButton" value="{'Delete users'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to delete the selected users from the list of user that are allowed to access your lightbox'|i18n( 'ezteamroom/lightbox' )}" class="button" onclick="return confirmRemoverUser();" />
    {/if}

    {else}
        {'Currently no users are allowed to access this lightbox.'|i18n( 'ezteamroom/lightbox' )}
    {/if}

           </fieldset>
           <div class="lightbox-buttons">
            <input type="submit" name="StoreLightboxButton" value="{'Store changes'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to save the changes in the lightbox name and user rights'|i18n( 'ezteamroom/lightbox' )}" class="button" />
{***
            <input type="submit" name="DeleteLightboxButton" value="{'Delete lightbox'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to delete this lightbox'|i18n( 'ezteamroom/lightbox' )}" class="button" onclick="return confirm( '{'Are you sure you want to delete this lightbox?'|i18n( 'ezteamroom/lightbox' )}' );" />
***}
    {if and( is_set( $redirectURI ), $redirectURI|ne( '' ) )}
            <input type="hidden" name="redirectURI" value="{$redirectURI}" />
            <input type="submit" name="GoBackButton" value="{'Cancel'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to cancel all changes.'|i18n( 'ezteamroom/lightbox' )}" class="button" />
{***
            <input type="submit" name="GoBackButton" value="{'Go back'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to go back.'|i18n( 'ezteamroom/lightbox' )}" class="button" />
****}
    {/if}
           </div>

{else}

      {'No lightbox selected'|i18n( 'ezteamroom/lightbox' )}

{/if}

          </form>
         </div>
        </div>
       </div>

       <div class="border-bl">
        <div class="border-br">
         <div class="border-bc"></div>
        </div>
       </div>

      </div> {* border-box *}
     </div>
    </div>
   </div> {* center-column-position *}

   <div class="right-column-position">
    <div class="right-column"></div>
   </div>

  </div> {* columns-frontpage *}
  <div class="float-break"></div>

 </div> {* class-frontpage *}
</div> {* content-view-full *}
