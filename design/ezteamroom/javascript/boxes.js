//
// eZ Personal Frontpage
// General functionallity
//
// Created on: <25.05.2007 10:41:49 tw>
//
// Copyright (C) 1999-2010 eZ Systems as. All rights reserved.
//

// -----------------------------------------------------------------------------
function toggleWidget( id )
{
    if( toggle( $( "content_box_" + id ) ) )
    {
        $( "maxmin_" + id ).style.backgroundPosition = '0px 36px';
    }
    else
    {
        $( "maxmin_" + id ).style.backgroundPosition = '0px 0px';
    }
}

function closeWidget( id )
{
    debug( "Closing: " + id );

    var box    = $( "box_" + id );
    var widget = box.parentNode.removeChild( box );


    var box_item    = $( "box_" + id + "_listitem" );
    if ( box_item )
    {
        box_item.style.display = "block";
    }

    $( "TempContainer" ).appendChild( widget );

    updateBoxSettingsOnHost();
    checkWidgetCount();
}

function toggleAddWidgetMenu( id )
{
    var selectColumnPopup = $( "selectColumnPopup" );
    show( selectColumnPopup );
    moveElementToMousePosWithOffset( selectColumnPopup, 10, -10 );
    selectColumnPopup.setAttribute( "SelectedWidget", id );
}

function addWidget( pos )
{
    var selectColumnPopup = $( "selectColumnPopup" );
    id = selectColumnPopup.getAttribute( "SelectedWidget" );
    if( id !== 0 )
    {
        moveWidget( gContainerName, "box", id, pos - 1 );
        close( selectColumnPopup );
        selectColumnPopup.setAttribute( "SelectedWidget", 0 );
        updateBoxSettingsOnHost();

        var box_item    = $( "box_" + id + "_listitem" );
        if ( box_item )
        {
            box_item.style.display = "none";
        }
    }
}

function closeAddWidgetMenu()
{
    toggleById( 'selectColumnPopup' );
}

function showAvaibleWidgets()
{

    gDragingDisabled = true;

    moveElementToMousePosWithOffset( $( 'available-widgets-list' ), 10, 5 );

    /* Close selectColumnPopup if opened */
    if( !toggleById( 'available-widgets-list' ) )
    {
        close( $( "selectColumnPopup" ) );
    }

    // ab: Moved out of brackets above, because otherwise dragging is
    // not possible if the last widget has been added to a column
    gDragingDisabled = false;
}

function closeAvaibleWidgets()
{
    gDragingDisabled = false;

    toggleById( 'available-widgets-list' );

    close( $( "selectColumnPopup" ) );
}


// -----------------------------------------------------------------------------
