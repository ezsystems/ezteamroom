<div class="lightbox-create">
<div class="box_background">
 <div class="border-box">

  <div class="border-tl">
   <div class="border-tr">
    <div class="border-tc"></div>
   </div>
  </div>

  <div class="border-ml">
   <div class="border-mr">
    <div class="border-mc">
     <h1>{'Create new lightbox'}</h1>

{if and( is_set( $messages ), $messages|count()|gt( 0 ) )}

     <div class="message-{cond( $actionSuccess, 'feedback', true(), 'error' )}">

    {foreach $messages as $message}

      <p>{$message|wash()}</p>

    {/foreach}

     </div>

{/if}

     <form action={$url|ezurl()} method="post">
      <table>
       <tr>
        <td><label>{'Name'|i18n( 'ezteamroom/lightbox' )}:</label></td>
        <td><input type="text" name="lightbox_name" value="{$lightbox_name|wash()}" size="50" /></td>
       </tr>

{if ezpreference( 'currentLightboxID' )}

       <tr>
        <td colspan="2">
         <input type="checkbox" name="changeToCurrentLightbox" value="true" /> {'Use the newly created lightbox as the current lightbox.'|i18n( 'ezteamroom/lightbox' )}
        </td>
       </tr>

{/if}

      </table>
        <div class="lightbox-buttons">

{if is_set( $addItemIDAfterCreate )}

       <input type="hidden" name="addItemIDAfterCreate" value="{$addItemIDAfterCreate}" />

{/if}

{if is_set( $addTypeIDAfterCreate )}

  <input type="hidden" name="addTypeIDAfterCreate" value="{$addTypeIDAfterCreate}" />

{/if}

       <input type="submit" name="CreateLightboxButton" value="{'Create new'|i18n( 'ezteamroom/lightbox' )}" class="button" />

{* Redirect to widget content workaround *}
{* set $redirectURI='/' *}
{if and( is_set( $redirectURI ), $redirectURI|ne( '' ) )}

      <input type="hidden" name="redirectURI" value="{$redirectURI}" />
      {if $redirectAfter}
      <input type="hidden" name="redirectAfterLightboxHasBeenCreated" value="1" />
      {/if}
      <input type="submit" name="GoBackButton" value="{'Cancel'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to go back.'|i18n( 'ezteamroom/lightbox' )}" class="button" />
{/if}

      </div>
     </form>
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
