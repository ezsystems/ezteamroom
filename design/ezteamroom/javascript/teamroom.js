function showhide(targetID)
{
    //change target element mode
    if (document.getElementById(targetID) )
    {
        var elementmode = document.getElementById(targetID).style;
        elementmode.display = (!elementmode.display) ? 'none' : '';
    }
}


function hideWarnBox()
{
    showhide('tasklistwarning');
}

function isset(varname){
  return(typeof(window[varname])!='undefined');
}


function ezteamroom_toggleCheckboxes( formname, checkboxname, user_id )
{
    with( formname )
    {
        var myre = false;
        if ( user_id !== null && user_id !== false && user_id !== undefined )
        {
            myre = new RegExp( checkboxname + '\\\[' + user_id + '\\\].*', '' );
        }
        for( var i=0; i<elements.length; i++ )
        {
            var elemname = elements[i].name;
            var elemsubstr = elemname.substring(0, checkboxname.length)
            var tmp = elemname.substring(checkboxname.length+1, elemname.length-1 )

            if( elements[i].type == 'checkbox' && elemsubstr == checkboxname && elements[i].disabled == "" && ( myre === false || myre.exec( elemname ) != null ) )
            {
                if( elements[i].checked == true )
                {
                    elements[i].checked = false;
                }
                else
                {
                    elements[i].checked = true;
                }
            }
        }
    }
}


// if ( isset( 'YAHOO' )  )
// {
// (function() {
//     var Event = YAHOO.util.Event,
//         Dom   = YAHOO.util.Dom,
//         lang  = YAHOO.lang,
//         slider,
//         bg="slider-bg", thumb="slider-thumb",
//         valuearea="slider-value", textfield="slider-converted-value"
// 
//     // The slider can move 0 pixels up
//     var topConstraint = 0;
//     // The slider can move 200 pixels down
//     var bottomConstraint = 80;
//     // Custom scale factor for converting the pixel offset into a real value
//     var scaleFactor = 0.05;
//     // The amount the slider moves when the value is changed with the arrow keys
//     var keyIncrement = 20;
//     var tickSize = 20;
// 
//     Event.onDOMReady(function() {
// 
//         slider = YAHOO.widget.Slider.getVertSlider(bg, 
//                          thumb, topConstraint, bottomConstraint, tickSize );
// 
//         val = Dom.get(textfield).value / scaleFactor;
//         slider.setValue(val, true, false, true);
// 
//         slider.getRealValue = function() {
//             return Math.round(this.getValue() * scaleFactor);
//         }
// 
//         slider.subscribe("change", function(offsetFromStart) {
// 
//             var valnode = Dom.get(valuearea);
//             var fld = Dom.get(textfield);
// 
//             // Display the pixel value of the control
// 
//             // use the scale factor to convert the pixel offset into a real
//             // value
//             var actualValue = slider.getRealValue() + 1;
// 
//             // update the text box with the actual value
//             fld.value = actualValue;
//             valnode.innerHTML = actualValue;
//             Dom.get(bg).className = 'sliderprio' + actualValue;
// 
//             // Update the title attribute on the background.  This helps assistive
//             // technology to communicate the state change
//             Dom.get(bg).title = "priority = " + actualValue;
// 
//         });
// 
//         slider.subscribe("slideStart", function() {
//                 YAHOO.log("slideStart fired", "warn");
//             });
// 
//         slider.subscribe("slideEnd", function() {
//                 YAHOO.log("slideEnd fired", "warn");
//             });
// 
// 
//     });
// })();
// }
