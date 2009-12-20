<div class="border-box">

 <div class="border-tl">
  <div class="border-tr">
   <div class="border-tc"></div>
  </div>
 </div>

 <div class="border-ml">
  <div class="border-mr">
   <div class="border-mc">
    <h1>{'Lightbox "%1"'|i18n( 'ezteamroom/lightbox', , hash( '%1', $lightbox.name ) )}</h1>

{if and( is_set( $messages ), $messages|count()|gt( 0 ) )}

    <div class="message-{cond( $actionSuccess, 'feedback', true(), 'error' )}">

    {foreach $messages as $message}

     <p>{$message|wash()}</p>

    {/foreach}

    </div>

{/if}

    <form action={$url|ezurl()} method="post">
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
