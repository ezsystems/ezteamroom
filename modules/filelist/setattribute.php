<?php
/**
 * File containing the filelist/set function
 *
 * @copyright Copyright (C) 1999-2011 eZ Systems AS. All rights reserved.
 * @license http://ez.no/eZPublish/Licenses/eZ-Business-Use-License-Agreement-eZ-BUL-Version-2.0 eZ Business Use License Agreement Version 2.0
 * @version 1.4.0
 * @package eZTeamroom
 */

$error = false;

if ( ezxTeamRoomUtils::changeAttributes( (int) $Params['Object'],
                                                  array( $Params['Key'] => $Params['Value'] ) ) === false)
{
    eZDebug::writeError( "Object attribute change failed", 'filelist/set' );
    $error = 'kernel';
}

$urlArray = array_splice( $Params['Parameters'], 3 );
foreach ( $urlArray as $key => $val ) // remove all the array elements that don't seem like URL parts
{
    if ( !is_numeric( $key ) )
        unset( $urlArray[$key] );
}
$url = implode( '/', $urlArray );
unset( $urlArray );

$appendUrl = $error ? "/(error)/$error" : '';

if ( $url )
{
    foreach ( $Params['UserParameters'] as $key => $value )
    {
        if ( $key !== 'error' )
            $url .= "/($key)/$value";
    }
    $Params['Module']->redirectTo( "/$url$appendUrl" );
}
else
{
    eZRedirectManager::redirectTo( $Params['Module'], // $default
                                   false,   // $view
                                   true,    // $disallowed
                                   false,
                                   ( isset( $_SERVER['HTTP_REFERER'] ) ?
                                       preg_replace( '/\/\(error\)\/[^\/]+/',
                                                     '',
                                                     eZURI::decodeURL( $_SERVER['HTTP_REFERER'] )
                                                   ) :
                                       ''
                                   ) . $appendUrl
                                 );
    return;
}

?>
