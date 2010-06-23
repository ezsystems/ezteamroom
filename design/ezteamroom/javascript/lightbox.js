function changeCurrentLightbox()
{
  if( gMousePos == undefined ) return false;

  var hiddenForm = document.getElementById( 'hiddensubmitform' );
  var lightboxSelect = document.getElementById( 'lightboxselection' );
  var inputField = document.getElementById( 'newLightboxIDInput' );

  inputField.value = lightboxSelect.options[lightboxSelect.selectedIndex].value;
  hiddenForm.submit();
}

function sendChangeSelectedLightboxRequest( url, responseHandler, responseParameters )
{
    parameters = 'ContentObjectID=0' + '&newLightboxID=' + document.getElementById( 'widgetNewLightboxIDInput' ).value +
                 '&redirectAfterSelectionURI=' +  escape( document.getElementById( 'widgetRedirectionInput' ).value ) + '&ChangeUserSelectedLightbox=1';
    sendAJAXPostRequest( url, parameters, responseHandler, responseParameters );
}

function sendAJAXPostRequest( url, parameters, responseHandler, responseParameters )
{
    debug( "Posting AJAX Req. to " + url );
    var xmlHttp = null;

    /* Mozilla, IE 7 */
    if( typeof XMLHttpRequest != 'undefined' )
    {
        xmlHttp = new XMLHttpRequest();
    }
    if (!xmlHttp)
    {
        /* IE 6 */
        try {
            xmlHttp  = new ActiveXObject( "Msxml2.XMLHTTP" );
        } catch(e) {
            try {
                xmlHttp  = new ActiveXObject( "Microsoft.XMLHTTP" );
            } catch(e) {
                xmlHttp  = null;
            }
        }
    }

    if (xmlHttp)
    {
        xmlHttp.open( 'POST', url, true );
        xmlHttp.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
        xmlHttp.onreadystatechange = function()
            {
                if ( xmlHttp.readyState == 4 )
                {
                    if( responseHandler === undefined )
                    {
                        debug( "Data successfuly transfered!" );
                    }
                    else
                    {
                        responseHandler( xmlHttp.responseText, responseParameters );
                    }
                }
            };
        xmlHttp.send( parameters );
    }
}

function changeSelectedLightbox()
{
  if( gMousePos == undefined ) return false;

  var hiddenForm     = document.getElementById( 'hiddenlightboxselectionwidgetform' );
  var lightboxSelect = document.getElementById( 'lightboxselectionwidget' );
  var inputField     = document.getElementById( 'widgetNewLightboxIDInput' );

  inputField.value = lightboxSelect.options[lightboxSelect.selectedIndex].value;
  hiddenForm.submit();
}

function selectLightboxWidgetResponseHandler( result, targetIDString )
{
    document.getElementById( targetIDString ).parentNode.innerHTML = result;
}

function addToLightbox( object_id )
{
  var form = document.getElementById( 'shop_add_to_lightbox_form' );
  var selection = document.getElementById( 'basket_lightbox_selection_' + object_id );
  var object_id_field = document.getElementById( 'shop_add_to_lightbox_form_objectid' );
  var lightbox_id_field = document.getElementById( 'shop_add_to_lightbox_form_lightboxid' );

  lightbox_id_field.value = selection.options[selection.selectedIndex].value;
  object_id_field.value = object_id;
  form.submit();
}

function toggleLightboxSettingsEx()
{
    var lightbox_settings = document.getElementById( 'lightbox-settings' );
    toggle( lightbox_settings );    
}


function toggleLightboxSettings()
{
   moveElementToMousePosWithOffset( $( 'lightbox-settings' ), -100, 17 );
   toggleById( 'lightbox-settings' );
}
