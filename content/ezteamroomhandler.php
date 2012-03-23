<?php


class ezteamroomHandler extends eZContentObjectEditHandler
{
    const ATTRIBUTE_DATA_BASE_NAME = 'ContentObjectAttribute';

    /*!
     \reimp
            This function will check if a valid menu for a wiki page can be created.
    */
    function validateInput( $http, &$module, &$class, $object, &$version, $contentObjectAttributes, $editVersion, $editLanguage, $fromLanguage, $validationParameters )
    {
        // class mapping
        $class_identifier_map = array();
        $TrINI = eZINI::instance( 'teamroom.ini' );
        if( $TrINI AND
            $TrINI->hasVariable( 'TeamroomSettings', 'ClassIdentifiersMap' ) AND
            is_array( $TrINI->variable( 'TeamroomSettings', 'ClassIdentifiersMap' ) ) )
        {
            $class_identifier_map = $TrINI->variable( 'TeamroomSettings', 'ClassIdentifiersMap' );
        }
        $wikiPageClassIdentifier = array_key_exists( 'wiki_page', $class_identifier_map )? $class_identifier_map['wiki_page'] : 'wiki_page';

        if ( $object->attribute('class_identifier') != $wikiPageClassIdentifier )
        {
            return array( 'is_valid' => true, 'warnings' => array() );
        }

        $attributeIdentifierBody = 'body';
        $attributeBody = null;
        foreach ( $contentObjectAttributes as $attribute )
        {
            if ( $attribute->attribute('contentclass_attribute_identifier') == $attributeIdentifierBody )
            {
                $attributeBody = $attribute;
            }
        }

        if( !$attributeBody  )
        {
            eZDebug::writeError( "Cannot find attribute '$attributeIdentifierBody'." , __METHOD__);
            return array( 'is_valid' => true, 'warnings' => array() );
        }

        $tocCreator = new eZTeamroomTOC( $attributeBody );
        $errors = $tocCreator->getValidationErrors();

        if ( !empty( $errors ) )
        {
            $warnings = array();
            foreach( $errors as $error )
            {
                $errorTXT = "<br /> Bei der Überschrift \"".$error['headline']."\" (".($error['level']).") fehlen übergeordnete Überschriften ( ";
                $errorTXT.= implode( ", ", $error['missing_headlines'] ) . " )";

                $errorTXT = ezpI18n::tr( 'ezteamroom/wiki', 
                                         'Missing previous headings ( %missing_headings ) for heading "%headline" ( %heading ).', 
                                         null, 
                                         array( '%headline'         => $error['headline'],
                                                '%heading'          => $error['level'],
                                                '%missing_headings' => implode( ", ", $error['missing_headlines'] ) ) );
                $warnings[] = array( 'text' => $errorTXT );
            }
            // set the objectAttribute to not valid
            $attributeBody->setHasValidationError( true );

            // $warnings = array( array( 'text' => ezpI18n::tr( 'ezteamroom/wiki', 'Cannot create menu. Please check the headlines.' ) ) );
            return array( 'is_valid' => false, 
                          'warnings' => $warnings );
        }


        return array( 'is_valid' => true, 'warnings' => array() );
    }




}

?>
