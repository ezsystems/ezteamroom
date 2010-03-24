<?php
/**
 * File containing the ezxTeamRoomUtils class
 *
 * @copyright Copyright (C) 1999-2010 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPL v2
 * @version //autogentag//
 * @package eZTeamroom
 */

/**
 * The class ezxTeamRoomUtils is a place where content object
 * operations are encapsulated.
 * We move them out from eZContentObject because they may content code
 * which is not directly related to content objects (e.g. clearing caches, etc).
 */
class ezxTeamRoomUtils
{
    /**
     * Creates a new content object version with modified attributes.
     *
     * @param int $objectId ID of the object.
     * @param array $attributes Array of attributes information, the key
     *                          holds the attribute name and the value
     *                          holds the content.
     *
     * @return bool Return true if the operation succeed, false otherwise.
     */
    public static function changeAttributes( $objectId, array $attributes )
    {
        $contentObject = eZContentObject::fetch( $objectId );
        if ( $contentObject === null || !$contentObject->attribute( 'can_edit' ) )
            return false;

        $db = eZDB::instance();
        $db->begin();
        $contentObjectVersion = $contentObject->createNewVersion();
        $dataMap = $contentObjectVersion->dataMap();

        foreach ( $attributes as $key => $value)
        {
            if ( !isset( $dataMap[$key] ) )
            {
                $db->rollback();
                return false;
            }

            $attribute = $dataMap[$key];

            switch ( $attribute->attribute( 'data_type_string' ) )
            {
                case 'ezstring':
                case 'eztext':
                case 'ezselection':
                case 'ezemail':
                    $attribute->setAttribute( 'data_text', $value );
                    break;

                case 'ezboolean':
                case 'ezinteger':
                    $attribute->setAttribute( 'data_int', (int) $value );
                    break;

                case 'ezprice':
                case 'ezfloat':
                    $attribute->setAttribute( 'data_float', (float)$value );
                    break;

                default:
                    // datatype not supported yet
                    $db->rollback();
                    return false;
            }

            $attribute->store();
        }

        $contentObjectVersion->store();
        $contentObject->store();
        $db->commit();

        return null !== eZOperationHandler::execute( 'content',
                                                     'publish',
                                                     array( 'object_id' => $contentObject->attribute( 'id' ),
                                                            'version' => $contentObjectVersion->attribute( 'version' ) ) );
    }
}

?>
