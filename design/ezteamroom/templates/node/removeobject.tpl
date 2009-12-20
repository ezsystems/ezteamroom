
<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<form action={concat($module.functions.removeobject.uri)|ezurl} method="post" name="ObjectRemove">

<h1>{"Are you sure you want to remove these items?"|i18n("ezteamroom/edit")}</h1>
<div id="message_allcontent">
    <div class="message-icon float-left">
        <img src={'icons/icon_warn.jpg'|ezimage()} alt="" />
    </div>
    <div class="message-textcontent">

        <div class="message-infoline-border">
            <div class="message-infoline">
                <ul>
                {section name=Result loop=$DeleteResult}
                    {section show=$Result:item.childCount|gt(0)}
                        <li>{"%nodename and its %childcount children. %additionalwarning"
                             |i18n( 'ezteamroom/edit',,
                                    hash( '%nodename', $Result:item.nodeName,
                                          '%childcount', $Result:item.childCount,
                                          '%additionalwarning', $Result:item.additionalWarning ) )}</li>
                    {section-else}
                        <li>{"%nodename %additionalwarning"
                             |i18n( 'ezteamroom/edit',,
                                    hash( '%nodename', $Result:item.nodeName,
                                          '%additionalwarning', $Result:item.additionalWarning ) )}</li>
                    {/section}
                {/section}
                </ul>
            </div>
        </div>

        <div class="message-subline">
        {section show=$moveToTrashAllowed}
          <input type="hidden" name="SupportsMoveToTrash" value="1" />
          <input type="checkbox" name="MoveToTrash" value="1" checked="checked" />{'Move to trash'|i18n('ezteamroom/edit')}
          &nbsp;&nbsp;&nbsp;&nbsp;
          <strong> {"Note"|i18n("ezteamroom/edit")}:</strong> {"If %trashname is checked, removed items can be found in the trash."
                                                            |i18n( 'ezteamroom/edit',,
                                                                   hash( '%trashname', concat( '<i>', 'Move to trash'|i18n( 'ezteamroom/edit' ), '</i>' ) ) )}
          <br />
        {/section}
          <div class="emptyButton emptyButton_whitebg" style="display: inline;">
           <input class="mousePointer emptyButton" type="submit" name="ConfirmButton" value="{'Confirm'|i18n('ezteamroom/edit')}" />
          </div>
          <div class="emptyButton emptyButton_whitebg" style="display: inline;">
           <input class="mousePointer emptyButton" type="submit" name="CancelButton" value="{'Cancel'|i18n('ezteamroom/edit')}" />
          </div>
        </div>

</div>

</form>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
