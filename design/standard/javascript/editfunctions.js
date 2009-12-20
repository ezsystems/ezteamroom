
var visibleObjectList = new Array();

function teamroomDisplayImage( pretext, area , value )
{
    areaDiv = document.getElementById( visibleObjectList[area] );
    if ( areaDiv )
    {
        areaDiv.style.display="none";
    }
    visibleObjectList[ area ] = pretext +  value;
    var showDiv = document.getElementById( pretext +  value );
    if ( showDiv )
    {
        showDiv.style.display="block"
    }
}
