<form enctype="multipart/form-data" id="editform" name="editform" method="post" action={concat("/content/edit/",$object.id,"/",$edit_version,"/",$edit_language|not|choose(concat($edit_language,"/"),''))|ezurl}>

<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-edit">

    <div class="attribute-header">
        {if $edit_version|gt(1)}
            <h1 class="long">{'Edit %1 - %2'|i18n( 'ezteamroom/teamroom', , array( $class.name|wash, $object.name|wash ) )}</h1>
        {else}
            <h1 class="long">{'Create new teamroom'|i18n( 'ezteamroom/teamroom' )|wash()}</h1>
        {/if}
    </div>
        {if $edit_version|gt(1)}
            <p>
            {'If you disable features in your teamroom this will have no effect on existing contents in that area. Thus, you can also enable a feature later on and you will get the same content.'|i18n( 'ezteamroom/teamroom' )|wash()}
            </p>
            <p>
            {'Keep in mind that it can take several minutes until the modifications to the teamroom take effect.'|i18n( 'ezteamroom/teamroom' )|wash()}
            </p>
        {else}

            {def $visibilityList = ezini( "TeamroomSettings", "VisibilityList", "teamroom.ini" )}

            <p>
            {'To create a new teamroom just enter a title and a short description for it.'|i18n( 'ezteamroom/teamroom' )|wash()}
            {'The access types can be used for access control to your teamroom as follows'|i18n( 'ezteamroom/teamroom' )|wash()}
             <table class="list">
              <tr>
               <td><strong>{'Private'|i18n( 'ezteamroom/access_type' )|wash()}</strong></td>
               <td>{'Nobody can see that the teamroom exists and users can only become a member of the teamroom if you invited them.'|i18n( 'ezteamroom/access_type' )|wash()}</td>
              </tr>

            {if $visibilityList|contains( 'internal' )}

              <tr>
               <td><strong>{'Internal'|i18n( 'ezteamroom/access_type' )|wash()}</strong></td>
               <td>{'Only users that belong to the same group as you do can see that the teamroom exists and you will have to approve any requested membership before people can use the teamroom.'|i18n( 'ezteamroom/access_type' )|wash()}</td>
              </tr>

            {/if}

              <tr>
               <td><strong>{'Protected'|i18n( 'ezteamroom/access_type' )|wash()}</strong></td>
               <td>{'Anybody can see that the teamroom exists and you will have to approve any requested membership before people can use the teamroom.'|i18n( 'ezteamroom/access_type' )|wash()}</td>
              </tr>
              <tr>
               <td><strong>{'Public'|i18n( 'ezteamroom/access_type' )|wash()}</strong></td>
               <td>{'Anybody can see that the teamroom exists and can join it without asking you for permission.'|i18n( 'ezteamroom/access_type' )|wash()}</td>
              </tr>
             </table>
             {'Only those features that you selected will be visible in your teamroom. It is also possible to de-/activate features after the teamroom has been created.'|i18n( 'ezteamroom/teamroom' )|wash()}
            </p>
            <p>
            {'Keep in mind that the creation of your new teamroom can take several minutes.'|i18n( 'ezteamroom/teamroom' )|wash()}
            </p>
        {/if}

    {include uri='design:content/edit_validation.tpl'}

    {include uri='design:content/edit_attribute.tpl' hidden_attributes=array('default_arrangement')}

    <div class="buttonblock">
        {if $edit_version|gt(1)}
    <input class="defaultbutton" type="submit" name="PublishButton" value="{'Store Teamroom'|i18n( 'ezteamroom/teamroom' )}" />
        {else}
    <input class="defaultbutton" type="submit" name="PublishButton" value="{'Create Teamroom'|i18n( 'ezteamroom/teamroom' )}" />
        {/if}
    <input class="button" type="submit" name="DiscardButton" value="{'Discard'|i18n( 'ezteamroom/teamroom' )}" />
    <input type="hidden" name="DiscardConfirm" value="0" />
    {* For now a teamroom can only be edited from within its full view *}
    <input type="hidden" name="RedirectIfDiscarded" value={$object.main_node.url_alias|wash()} />
    <input type="hidden" name="RedirectURIAfterPublish" value={$object.main_node.url_alias|wash()} />
    </div>
</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>

</form>
