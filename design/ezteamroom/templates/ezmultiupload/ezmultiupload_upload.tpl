<script type="text/javascript" src={"javascript/ezteamroom/files.js"|ezdesign}></script>
<script type="text/javascript" src={"javascript/yui/build/yahoo/yahoo.js"|ezdesign}></script>
<script type="text/javascript" src={"javascript/yui/build/event/event.js"|ezdesign}></script>
<script type="text/javascript" src={"javascript/yui/build/animation/animation.js"|ezdesign}></script>
<script type="text/javascript" src={"javascript/yui/build/yahoo-dom-event/yahoo-dom-event.js"|ezdesign}></script>
<script type="text/javascript" src={"javascript/yui/build/element/element-beta.js"|ezdesign}></script>
<script type="text/javascript" src={"javascript/yui/build/uploader/uploader-experimental.js"|ezdesign}></script>
<script type="text/javascript" src={"javascript/yui/build/connection/connection.js"|ezdesign}></script>
<script type="text/javascript" src={"javascript/AC_OETags.js"|ezdesign}></script>
<script language="JavaScript" type="text/javascript">
<!--
// -----------------------------------------------------------------------------
// Globals
// Major version of Flash required
var requiredMajorVersion = 10;
// Minor version of Flash required
var requiredMinorVersion = 0;
// Minor version of Flash required
var requiredRevision = 0;
// -----------------------------------------------------------------------------
// -->
</script>

<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="user-edit">

    <div class="attribute-header">
    <h1 class="long">{"Multi Upload"|i18n("ezteamroom/files")}</h1>
    </div>

    <p><b>{'The Files are uploaded to the Files section of the teamroom:'|i18n('ezteamroom/files')}

    <a href={$existing_node.parent.url_alias|ezurl}>{$existing_node.parent.name|wash}</a></b></p>
    <div class="content-view-ezmultiupload">
    <div class="class-frontpage">
        <div class="attribute-description">
{*             <p>{'You can upload a maximum filesize of'|i18n('ezteamroom/files')} {$post_max_size}B</p> *}
        </div>
        <div id="multiuploadProgress">
            <p>
               <span id="multiuploadProgressFile">&nbsp;</span>&nbsp;
               <span id="multiuploadProgressFileName">&nbsp;</span>
            </p>
            <p id="multiuploadProgressMessage">&nbsp;</p>
            <div id="multiuploadProgressBarOutline"><div id="multiuploadProgressBar"></div></div>
        </div>
        <div id="multiupload">
          <p>{'Unable to load Flash content. You can download the latest version of Flash Player from the'|i18n('ezteamroom/files')}
          <a href="http://www.adobe.com/go/getflashplayer">{'Adobe Flash Player Download Center'|i18n('ezteamroom/files')}</a>.</p>
        </div>
        <div id="thumbnails"></div>
    </div>
    </div>

    <div class="buttonblock">
            <button id="uploadButton" type="button" onclick="browse();">
                {'Select Files'|i18n('ezteamroom/files')}
            </button>
    <form action={$existing_node.url_alias|ezurl} method="post" style="display: inline;">
    <input class="button" type="submit" name="ChangePasswordButton" value="{'Back'|i18n('ezteamroom/files')}" />
    </form>
    </div>

</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>

{literal}
<script type="text/javascript">
    var hasReqestedVersion = DetectFlashVer(requiredMajorVersion, requiredMinorVersion, requiredRevision);

    if (hasReqestedVersion) {

    multiUploadCondition = { 'swfURL' : '{/literal}{"javascript/yui/build/uploader/assets/uploader.swf"|ezdesign('no')}{literal}',
                             'uploadURL' : '{/literal}{concat("ezmultiupload/multiupload/",$existing_node_id)|ezurl('no')}{literal}',
                             'uploadVars' : {'{/literal}{ezini( 'Session', 'SessionNamePrefix', 'site.ini' )}{literal}' :'{/literal}{$session_id}{literal}'},
                             'thumbnailURL' : '{/literal}{"ezmultiupload/thumbnail"|ezurl('no')}{literal}',
                             'fileType' : '{/literal}{$file_types}{literal}',
                             'message_all_file_recived' : '{/literal}{'All files received.'|i18n('ezteamroom/files')}{literal}',
                             'message_thumbnail_created' : '{/literal}{'Thumbnail Created.'|i18n('ezteamroom/files')}{literal}',
                             'message_start_upload' : '{/literal}{'Starting...'|i18n('ezteamroom/files')}{literal}' }

    eZMultiupload( multiUploadCondition );
    }
    else {
    var alternateContent = 'Alternate HTML content should be placed here.<BR>'
    + 'This content requires the Adobe Flash Player. '
    + '<a href=http://www.adobe.com/go/getflash/>Get Flash</a>';
    document.write(alternateContent);  // insert non-flash content
    }
</script>
{/literal}
<noscript>
    Provide alternate content for browsers that do not support scripting
    or for those that have scripting disabled.
    Alternate HTML content should be placed here.
    This content requires the Adobe Flash Player and a browser with JavaScript enabled.
    <a href="http://www.adobe.com/go/getflash/">Get Flash</a>
</noscript>
