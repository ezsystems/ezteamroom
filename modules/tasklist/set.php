<?php
//
// Created on: <2007-11-23 22:05:03 dis>
//
// SOFTWARE NAME: eZ Teamroom extension for eZ Publish
// SOFTWARE RELEASE: 0.x
// COPYRIGHT NOTICE: Copyright (C) 1999-2010 eZ Systems AS
// SOFTWARE LICENSE: GNU General Public License v2.0
// NOTICE: >
//   This program is free software; you can redistribute it and/or
//   modify it under the terms of version 2.0  of the GNU General
//   Public License as published by the Free Software Foundation.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of version 2.0 of the GNU General
//   Public License along with this program; if not, write to the Free
//   Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
//   MA 02110-1301, USA.
//
//

$module = $Params['Module'];
$http = eZHTTPTool::instance();

$task  = $Params['Task'];
$key   = $Params['Key'];
$value = $Params['Value'];
$error = false;
$db = eZDB::instance();

$contentObject = eZContentObject::fetch( (int)$task );

if (  $contentObject )
{
    if ( $contentObject->attribute( 'can_edit' ) )
    {
        $contentObjectVersion = $contentObject->createNewVersion();

        if ( $contentObjectVersion )
        {
            $db->begin();
            $versionNumber  = $contentObjectVersion->attribute( 'version' );

            $dataMap = $contentObjectVersion->dataMap();
            if ( array_key_exists( $key, $dataMap ) )
            {
                $attribute = $dataMap[$key];

                $classAttributeID = $attribute->attribute( 'contentclassattribute_id' );
                $dataType = $attribute->attribute( 'data_type_string' );
                switch ( $dataType )
                {
                    case 'ezstring':
                    case 'eztext':
                    case 'ezselection':
                    case 'ezemail':
                    {
                        $attribute->setAttribute( 'data_text', $value );
                    } break;

                    case 'ezboolean':
                    case 'ezinteger':
                    {
                        $attribute->setAttribute( 'data_int', (int)$value );
                    } break;

                    case 'ezxmltext':
                    {
                        $xml = '<?xml version="1.0" encoding="utf-8"?>'."\n".
                                '<section xmlns:image="http://ez.no/namespaces/ezpublish3/image/"'."\n".
                                '         xmlns:xhtml="http://ez.no/namespaces/ezpublish3/xhtml/"'."\n".
                                '         xmlns:custom="http://ez.no/namespaces/ezpublish3/custom/">'."\n".
                                '  <section>'."\n";
                        $xml .= '    <paragraph>' . $value . "</paragraph>\n";
                        $xml .= "  </section>\n</section>\n";
                        $attribute->setAttribute( 'data_text', $xml );
                    } break;

                    case 'ezprice':
                    case 'ezfloat':
                    {
                        $attribute->setAttribute( 'data_float', (float)$value );
                    } break;
                    case 'ezobjectrelation':
                    {
                        $objectID = $this->getReferenceID( $value );
                        if ( $objectID )
                        {
                            $attribute->setAttribute( 'data_int', $objectID );
                            eZContentObject::addContentObjectRelation( $objectID, $versionNumber, $contentObject->attribute( 'id' ), $attribute->ContentClassAttributeID,    EZ_CONTENT_OBJECT_RELATION_ATTRIBUTE );
                        }
                    } break;
                    case 'ezimage':
                    case 'ezurl':
                    case 'ezuser':
                    case 'ezauthor':
                    case 'ezbinaryfile':
                    case 'ezcountry':
                    case 'ezdate':
                    case 'ezdatetime':
                    case 'ezenum':
                    case 'ezidentifier':
                    case 'ezinisetting':
                    case 'ezisbn':
                    case 'ezkeyword':
                    case 'ezmatrix':
                    case 'ezmedia':
                    case 'ezmultioption':
                    case 'ezmultiprice':
                    case 'ezobjectrelationlist':
                    case 'ezoption':
                    case 'ezpackage':
                    case 'ezproductcategory':
                    case 'ezrangeoption':
                    case 'ezsubtreesubscription':
                    case 'eztime':
                    {
                    } break;
                }
                $attribute->store();
            }

            $contentObjectVersion->store();
            $contentObject->store();
            $db->commit();

            eZOperationHandler::execute( 'content', 'publish', array( 'object_id' => $contentObject->attribute( 'id' ), 'version'   => $versionNumber ) );

            unset($contentObjectVersion);
        }
        else
        {
            eZDebug::writeError( "Unable to create new version of $task", 'tasklist/set' );
            $error = 'kernel';
        }
        unset($contentObject);
    }
    else
    {
        eZDebug::writeError( "User is not allowed to edit $task", 'tasklist/set' );
        $error = 'access';
    }
}
else
{
    eZDebug::writeError( "Object does not exist $task", 'tasklist/set' );
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

if ( $url )
{
    foreach ( array_keys( $Params['UserParameters'] ) as $key )
    {
        if ( $key == 'error' )
            continue;
        $url .= '/(' . $key . ')/' . $Params['UserParameters'][$key];
    }
    if ( $error )
    {
        $url .= '/(error)/' . $error;
    }
    $module->redirectTo( '/'.$url );
}
else
{
    $preferredRedirectionURI = isset( $_SERVER['HTTP_REFERER'] ) ? eZURI::decodeURL( $_SERVER['HTTP_REFERER'] ) : false;

    // We should exclude OFFSET from $preferredRedirectionURI
    $exploded = explode( '/', $preferredRedirectionURI );
    foreach ( array_keys( $exploded ) as $itemKey )
    {
        $item = $exploded[$itemKey];
        if ( $item == '(error)' )
        {
            array_splice( $exploded, $itemKey, 2 );
            break;
        }
    }
    $redirectURI = implode( '/', $exploded );
    if ( $error )
    {
        $redirectURI .= '/(error)/' . $error;
    }
    eZRedirectManager::redirectTo( $module, /* $default = */ false, /* $view = */ true, /* $disallowed = */ false, $redirectURI );
    return;
}

?>
