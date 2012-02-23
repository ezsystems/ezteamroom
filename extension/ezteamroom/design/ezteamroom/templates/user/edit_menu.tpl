<div class="border-box">
 <div class="border-tl">
  <div class="border-tr">
   <div class="border-tc"></div>
  </div>
 </div>
 <div class="border-ml">
  <div class="border-mr">
   <div class="border-mc float-break">
    <div class="create-task">
     <div class="submitimage">
      <div class="emptyButton">

{def $userObject = fetch( 'user', 'current_user' )}

{if is_set( $add_form )}

       <form action={concat( '/content/edit/', $userObject.contentobject_id, '/f' )|ezurl()} method="post" name="Edit">
        <input class="mousePointer emptyButton" type="submit" name="EditButton" value="{'Edit profile'|i18n('ezteamroom/membership')}" />
       </form>

{else}

       <input class="mousePointer emptyButton" type="submit" name="EditButton" value="{'Edit profile'|i18n('ezteamroom/membership')}" />

{/if}

      </div>
     </div>
    </div>
   </div>
   <div class="create-task">
    <div class="keepupdated">
     <div class="arrowWhiteButton">

{if is_set( $add_form )}

      <form action={concat( '/user/password/', $userObject.contentobject_id )|ezurl()} method="post" name="Edit">
       <input class="mousePointer arrowWhiteButton" type="submit" name="ChangePasswordButton" value="{'Change password'|i18n('ezteamroom/membership')}" />
      </form>

{else}

      <input class="mousePointer arrowWhiteButton" type="submit" name="ChangePasswordButton" value="{'Change password'|i18n('ezteamroom/membership')}" />

{/if}

     </div>
    </div>
   </div>
   <div class="create-task sort-by">
    <div class="user-profile-name">
     <h3>{"User profile"|i18n("ezteamroom/membership")}</h3>
    </div>
    <div class="user-profile-list">
     <ul>
      <li><a href={"content/pendinglist"|ezurl}>{"My pending items"|i18n("ezteamroom/membership")}</a></li>
      <li><a href={"notification/settings"|ezurl}>{"My notification settings"|i18n("ezteamroom/membership")}</a></li>
      <li><a href={"collaboration/view/summary"|ezurl}>{"Collaboration"|i18n("ezteamroom/membership")}</a></li>
      <li><a href={"lightbox/view/list"|ezurl}>{"My Lightboxes"|i18n("ezteamroom/membership")}</a></li>
      {* <li><a href={concat("content/view/usertasks/",$root_node_id)|ezurl}>{"My Tasks"|i18n("ezteamroom/membership")}</a></li> *}
     </ul>
    </div>
   </div>
  </div>
 </div>
 <div class="border-bl">
  <div class="border-br">
   <div class="border-bc"></div>
  </div>
 </div>
</div>
