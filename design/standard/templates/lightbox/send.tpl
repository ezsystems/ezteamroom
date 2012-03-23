<div class="lightbox-create">
 <div class="border-box">

  <div class="border-tl">
   <div class="border-tr">
    <div class="border-tc"></div>
   </div>
  </div>

  <div class="border-ml">
   <div class="border-mr">
    <div class="border-mc">

{if is_object( $user )}

     <h1>{'Send lightbox "%1" to %2'|i18n( 'ezteamroom/lightbox', , hash( '%1', $lightbox.name, '%2', $user.contentobject.name|wash() ) )}</h1>

{else}

     <h1>{'Send lightbox "%1"'|i18n( 'ezteamroom/lightbox', , hash( '%1', $lightbox.name ) )}</h1>

{/if}

{if and( is_set( $messages ), $messages|count()|gt( 0 ) )}

     <div class="message-{cond( $actionSuccess, 'feedback', true(), 'error' )}">

    {foreach $messages as $message}

      <p>{$message|wash()}</p>

    {/foreach}

     </div>

{/if}

     <form action={$url|ezurl()} method="post">

{if ezhttp( 'LastSearchURI', 'session' )|ne( '' )}

      <input type="hidden" name="redirectURI" value={ezhttp( 'LastSearchURI', 'session' )|ezurl()} />

{elseif ezhttp( 'LastAccessesURI', 'session' )|ne( '' )}

      <input type="hidden" name="redirectURI" value={ezhttp( 'LastAccessesURI', 'session' )|ezurl()} />

{/if}

      <table class="align-top">
       <tr>
        <td><label>{'Receiver'|i18n( 'ezteamroom/lightbox' )}:</label></td>
        <td>

{if is_object( $user )}

         <input type="hidden" name="userID" value="{$user.contentobject_id}" />
         <input type="hidden" name="receiver" value="{$receiver|wash()}" />
         {$user.contentobject.name|wash()}

{else}

         <input type="text" name="receiver" value="{$receiver|wash()}" size="50" />

{/if}

        </td>
       </tr>
       <tr>
        <td><label>{'Subject'|i18n( 'ezteamroom/lightbox' )}:</label></td>
        <td>

{if is_object( $user )}

         <input type="hidden" name="subject" value="{$subject|wash()}" />
         {$subject|wash()}

{else}

         <input type="text" name="subject" value="{$subject|wash()}" size="50" />

{/if}

        </td>
       </tr>
       <tr>
        <td><label>{'Body'|i18n( 'ezteamroom/lightbox' )}:</label></td>
        <td>

{if is_object( $user )}

         <input type="hidden" name="body" value="{$body|wash()}" />
         <div class="sendlightboxbody">{$body|wash()}</div>

{else}

         <textarea rows="10" cols="50" name="body">{$body|wash()}</textarea>

{/if}

        </td>
       </tr>
       <tr>
        <td><label>{'Access'|i18n( 'ezteamroom/lightbox' )}:</label></td>
        <td>

{if is_object( $user )}

         <input type="hidden" name="accessMask" value="{$accessMask}" />

    {foreach $lightbox.access_keys as $key => $text}

        {if $accessKeyArray|contains( $key )}

         <input type="hidden" name="accessKeyArray[]" value="{$key}" />
         <span style="margin-right: 1.0em;">{$text|wash()}</span>

        {/if}

    {/foreach}

{else}

    {foreach $lightbox.access_keys as $key => $text}

         <input type="checkbox" name="accessKeyArray[]" value="{$key}"{cond( $accessKeyArray|contains( $key ), ' checked="checked"')} />
         <span style="margin-right: 1.0em;">{$text|wash()}</span>

    {/foreach}

{/if}

        </td>
       </tr>
      </table>
      <div class="lightbox-buttons">

{if and( is_object( $user ), $sendout|not() )}

       <input type="submit" name="SendLightboxButton" value="{'Send lightbox'|i18n( 'ezteamroom/lightbox' )}" class="button" />
       <input type="submit" name="SendLightboxBackButton" value="{'Go back'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to go back.'|i18n( 'ezteamroom/lightbox' )}" class="button" />

    {if and( is_set( $redirectURI ), $redirectURI|ne( '' ) )}

       <input type="hidden" name="redirectURI" value="{$redirectURI}" />

    {/if}

{else}

    {if $sendout|not()}

       <input type="submit" name="FindUserButton" value="{'Find user'|i18n( 'ezteamroom/lightbox' )}" class="button" />

    {/if}

    {if and( is_set( $redirectURI ), $redirectURI|ne( '' ) )}

       <input type="hidden" name="redirectURI" value="{$redirectURI}" />
       {if $sendout|not()}
       <input type="submit" name="GoBackButton" value="{'Cancel'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to go back.'|i18n( 'ezteamroom/lightbox' )}" class="button" />
       {else}
       <input type="submit" name="GoBackButton" value="{'Continue'|i18n( 'ezteamroom/lightbox' )}" title="{'Use this button to go back.'|i18n( 'ezteamroom/lightbox' )}" class="button" />
       {/if}
    {/if}

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
