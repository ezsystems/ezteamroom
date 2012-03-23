<?php

require_once 'autoload.php';

// Init script

$cli = eZCLI::instance();
$endl = $cli->endlineString();

$script = eZScript::instance( array( 'description' => ( "Script for upgrading from Teamroom Version 1.4 to 1.5.\n".
                                                        "The script will \n".
                                                        "- add two new wiki classes\n".
                                                        "- migrate old wiki objects to objects of the new wiki classes\n".
                                                        "- update wiki roles for handle new classes\n".
                                                        " \n\n".
                                                        'php extension/ezteamroom/update/1.4to1.5/install_wiki_classes.php -s ezteamroom' ),
                                      'use-session' => false,
                                      'use-modules' => true,
                                      'use-extensions' => true ) );
$script->startup();

$scriptOptions = $script->getOptions( '[oldwikiclass:][teamroomclass:]',
                                '',
                                array( 'oldwikiclass' => 'class identifier of old teamroom wiki class (default is teamroom_documentation_page)',
                                       'teamroomclass' => 'class identifier of teamroom class (default is teamroom_room)' ) );
$script->initialize();


$oldWikiClassIdent     = $scriptOptions[ 'oldwikiclass' ]  ? $scriptOptions[ 'oldwikiclass' ]  : 'teamroom_documentation_page';
$teamroomClassIdent    = $scriptOptions[ 'teamroomclass' ] ? $scriptOptions[ 'teamroomclass' ] : 'teamroom_room';
$newWikiClassIdent     = 'teamroom_wiki';
$newWikiPageClassIdent = 'teamroom_wiki_page';


// check if classes exisst
$oldWikiClass     = eZContentClass::fetchByIdentifier( $oldWikiClassIdent );
$teamroomClass    = eZContentClass::fetchByIdentifier( $teamroomClassIdent );

if ( !$oldWikiClass )
{
    $cli->error( "Missing class: $oldWikiClassIdent." );
    $script->shutdown(1);
}
if ( !$teamroomClass )
{
    $cli->error( "Missing class: $teamroomClassIdent." );
    $script->shutdown(1);
}


// Get user's ID who can remove subtrees. (Admin by default with userID = 14)
$ini = eZINI::instance();
$userCreatorID = $ini->variable( "UserSettings", "UserCreatorID" );
$user = eZUser::fetch( $userCreatorID );
if ( !$user )
{
    $cli->error( "Subtree remove Error!\nCannot get user object by userID = '$userCreatorID'.\n(See site.ini[UserSettings].UserCreatorID)" );
    $script->shutdown( 1 );
}
eZUser::setCurrentlyLoggedInUser( $user, $userCreatorID );


// Step1 Install New Wiki Classes




$newWikiClass     = eZContentClass::fetchByIdentifier( $newWikiClassIdent );
$newWikiPageClass = eZContentClass::fetchByIdentifier( $newWikiPageClassIdent );

if( $newWikiClass and $newWikiPageClass )
{
    $cli->error( "Wiki Classes exists, skipping class creation." );
}
else
{
    $xml = eZPrepareXML::prepareXMLFromTemplate( 'teamroom/install_wiki_classes', $cli );
    $cli->output( "Trying to install data from XML ..." );

    if ( $xml == '' )
    {
        $cli->error( "No XML data available." );
        $script->shutdown( 1 );
    }

    $dom = new DOMDocument( '1.0', 'utf-8' );
    if ( !$dom->loadXML( $xml ) )
    {
        $cli->error( "Failed to load XML." );
        $script->shutdown( 1 );
    }

    $xmlInstaller = new eZXMLInstaller( $dom );

    if ( !$xmlInstaller->proccessXML() )
    {
        $cli->error( "Errors while proccessing XML." );
        $script->shutdown( 1 );
    }

    $newWikiClass     = eZContentClass::fetchByIdentifier( $newWikiClassIdent );
    $newWikiPageClass = eZContentClass::fetchByIdentifier( $newWikiPageClassIdent );
    if ( !$newWikiClass )
    {
        $cli->error( "Missing class: $newWikiClassIdent. Something went wrong while class creation." );
        $script->shutdown(1);
    }
    if ( !$newWikiPageClass )
    {
        $cli->error( "Missing class: $newWikiPageClassIdent. Something went wrong while class creation." );
        $script->shutdown(1);
    }
}


// Step 2 migrate wiki objects
$cli->output( "\n\nStep 2: Migrating Wiki entries" );

$params = array( 'Depth'                    => false,
                 'Offset'                   => false,
                 'Limit'                    => false,
                 'Limitation'               => array(),
                 'ClassFilterType'          => 'include',
                 'ClassFilterArray'         => array( $teamroomClassIdent ) );
$teamroomList = eZContentObjectTreeNode::subTreeByNodeID( $params, 1 );

$teamroomListCount = count( $teamroomList );
if ( !$teamroomListCount )
{
    $cli->error( "    No teamrooms found." );
    $script->shutdown();exit(1);
}

$cli->output( "    Found $teamroomListCount Teamrooms." );

$params = array( 'Depth'                    => 1,
                 'Offset'                   => false,
                 'Limit'                    => false,
                 'Limitation'               => array(),
                 'IgnoreVisibility'         => true,
                 'ClassFilterType'          => 'include',
                 'ClassFilterArray'         => array( $oldWikiClassIdent ) );
$paramsChildren = array( 'Depth'                    => false,
                         'Offset'                   => false,
                         'Limit'                    => false,
                         'Limitation'               => array(),
                         'IgnoreVisibility'         => true,
                         'ClassFilterType'          => 'include',
                         'ClassFilterArray'         => array( $oldWikiClassIdent ) );

foreach ( $teamroomList as $teamroomNode )
{
    $cli->output( "    Checking Teamroom: '".$teamroomNode->attribute('url_alias')."' for old wiki...", false );
    $wikiTopLevelNodeList = eZContentObjectTreeNode::subTreeByNodeID( $params, $teamroomNode->attribute('node_id') );
    $wikiTopLevelNodeCount = count( $wikiTopLevelNodeList );

    if ( $wikiTopLevelNodeCount == 0 )
    {
        $cli->error( '     not found! Skipping.' );
        continue;
    }
    elseif ( $wikiTopLevelNodeCount > 1 )
    {
        $cli->error( '     found Multiple wikis! Skipping.' );
    }

    $oldWikiNode = $wikiTopLevelNodeList[0];
    $cli->output( ' found: ' . $oldWikiNode->attribute( 'name' ) );

    // copy wikiMainNode
    $cli->output( '    processing: ' . $oldWikiNode->attribute( 'name' ) );
    $newWikiNode = copyWiki( $teamroomNode, $newWikiClass, $oldWikiNode );
    if ( !is_object( $newWikiNode ) )
    {
        $cli->error( "ERROR: Failed to coy old Wiki"  );
        continue;
    }

    // hide?
    if ( $oldWikiNode->attribute( 'is_hidden' ) )
    {
        eZContentObjectTreeNode::hideSubTree( $newWikiNode );
    }


    // copy wiki pages
    $wikiChildNodeList = eZContentObjectTreeNode::subTreeByNodeID( $paramsChildren, $oldWikiNode->attribute('node_id') );
    $wikiChildNodeCount = count( $wikiChildNodeList );

    if ( $wikiChildNodeCount == 0 )
    {
        continue;
    }
    $cli->output( '        found: ' . $wikiChildNodeCount . ' children.' );

    foreach( $wikiChildNodeList as $oldWikiChildNode )
    {
        $cli->output( '            processing: ' . $oldWikiChildNode->attribute( 'name' ) );

        // copy wikiMainNode
        $newWikiPageNode = copyWiki( $newWikiNode, $newWikiPageClass, $oldWikiChildNode );
        if ( !is_object( $newWikiPageNode ) )
        {
            $cli->error( "ERROR: Failed to coy old Wiki"  );
        }
    }


    // remove old Wiki
    removeOldWikiNode($oldWikiNode);

    // update nice urls
    $newWikiNode->updateSubTreePath();

}


// STEP 3 Update Wiki Roles
$cli->output( "\n\nStep 3: Updating Teamroom roles" );

$oldWikiClassID = $oldWikiClass->attribute( 'id' );;
$newWikiClassID = $newWikiClass->attribute( 'id' );
$newWikiPageClassID = $newWikiPageClass->attribute( 'id' );

$trINI = eZINI::instance( 'teamroom.ini' );
$trRoleIDs = $trINI->variable( 'PermissionSettings', 'TeamroomRoleList' );

foreach( $trRoleIDs as $trRoleID )
{
    $role = eZRole::fetch( $trRoleID );
    if ( $role )
    {
        $rolename = $role->attribute('name');
        $policies = $role->attribute( 'policies' );
        foreach( $policies as $policy )
        {
            $module_name = $policy->attribute( 'module_name' );
            $function_name = $policy->attribute( 'function_name' );
            if ( $module_name == 'content' )
            {
                $limitations = $policy->attribute( 'limitations' );
                foreach( $limitations as $limitation )
                {
                    $limit_ident = $limitation->attribute( 'identifier' );
                    if ( in_array( $limit_ident, array( 'Class','ParentClass' ) ) )
                    {
                        #$values = $limitation->attribute( 'values' );
                        $values = $limitation->attribute( 'values_as_array' );
                        if ( in_array( $oldWikiClassID, $values) )
                        {
                            $limitation_id = $limitation->attribute( 'id' );
                            $addNew = false;
                            if ( !in_array( $newWikiClassID, $values) )
                            {
                                $addNew = ( $limit_ident == 'Class' )? $newWikiPageClassID : $newWikiClassID;
                            }

                            $cli->output( "        Removing Policy LimitationValue '$oldWikiClassID'",false);
                            if ($addNew) $cli->output( " and adding '$addNew'",false);
                            $cli->output( " for:");


                            $cli->output( "            role: '$rolename' " );
                            $cli->output( "            policy: '$module_name'/'$function_name' " );
                            $cli->output( "            Limit_ident: '$limit_ident' " );

                            eZPersistentObject::removeObject( eZPolicyLimitationValue::definition(),
                                                              array( 'limitation_id' => $limitation_id,
                                                                     'value' => $oldWikiClassID ) );
                            if ( $addNew )
                            {
                                eZPolicyLimitationValue::createNew( $limitation_id, $addNew );
                            }
                        }
                    }
                }
            }
        }
    }
}

/* Clean up policy cache */
eZUser::cleanupCache();




function copyWiki( $parentNode, $newWikiClass, $oldWikiNode )
{
    //create new wiki
    $db = eZDB::instance();
    $db->begin();

        $oldWikiObject = $oldWikiNode->attribute( 'object' );
        $parentObject = $parentNode->attribute( 'object' );

        $newWikiObject = $newWikiClass->instantiate( $parentObject->attribute( 'owner_id' ), 
                                                    $parentObject->attribute( 'section_id' ),
                                                    false, 
                                                    $oldWikiObject->attribute( 'current_language' ) );

        // set attributes
        $oldDataMap = $oldWikiObject->attribute( 'data_map' );
        $newDataMap = $newWikiObject->attribute( 'data_map' );
        $newDataMap['title']->fromString( $oldDataMap['title']->toString() );
        $newDataMap['title']->store();
        $newDataMap['body']->fromString( $oldDataMap['body']->toString() );
        $newDataMap['body']->store();
        $newDataMap['tags']->fromString( $oldDataMap['tags']->toString() );
        $newDataMap['tags']->store();

        $nodeAssignment = $newWikiObject->createNodeAssignment( $parentNode->attribute( 'node_id' ),
                                                                true, false,
                                                                $newWikiClass->attribute( 'sort_field' ),
                                                                $newWikiClass->attribute( 'sort_order' ) );

        // publish
        eZOperationHandler::execute( 'content', 'publish', array( 'object_id' => $newWikiObject->attribute( 'id' ),
                                                                    'version' => $newWikiObject->attribute( 'current_version' ) ) );

    $db->commit();
    return $newWikiObject->attribute( 'main_node' );
}

function removeOldWikiNode( $wikiNode, $moveToTrash = false )
{
    global $cli;

    $deleteIDArrayResult = array( $wikiNode->attribute( 'node_id' ) );

    // Get subtree removal information
    $info = eZContentObjectTreeNode::subtreeRemovalInformation( $deleteIDArrayResult );

    $deleteResult = $info['delete_list'];

    if ( count( $deleteResult ) == 0 )
    {
        $cli->output( "\nExit." );
        $script->shutdown( 1 );
    }

    $cli->output( "        Removing old wiki subtree:" );
    $cli->output( "            Total child count: ".$info['total_child_count'] );
    $cli->output( "            Reverse related count: ".$info['reverse_related_count'] );

    foreach ( $deleteResult as $deleteItem )
    {
        $node = $deleteItem['node'];
        $nodeName = $deleteItem['node_name'];
        if ( $node === null )
        {
            $cli->error( "Subtree remove Error! Cannot find subtree '$nodeName'." );
            continue;
        }
        $nodeID = $node->attribute( 'node_id' );
        $childCount = $deleteItem['child_count'];

        $cli->output( "            Node name: $nodeName ( Node id: $nodeID )" );

        if ( !$deleteItem['can_remove'] )
        {
            $cli->error( "Subtree remove Error! Insufficient permissions. You do not have permissions to remove the subtree with nodeID: $nodeID" );
            continue;
        }
        $cli->output( "            Child count: $childCount" );
        $cli->output( "            Object node count: " . $deleteItem['object_node_count']);

        // Remove subtrees
        eZContentObjectTreeNode::removeSubtrees( array( $nodeID ), $moveToTrash );

        // We should make sure that all subitems have been removed.
        $itemInfo = eZContentObjectTreeNode::subtreeRemovalInformation( array( $nodeID ) );
        $itemTotalChildCount = $itemInfo['total_child_count'];
        $itemDeleteList = $itemInfo['delete_list'];

        if ( count( $itemDeleteList ) != 0 or ( $childCount != 0 and $itemTotalChildCount != 0 ) )
            $cli->error( "  WARNING!  Some subitems have not been removed." );
        else
            $cli->output( "        Successfuly removed." );
    }

}

$script->shutdown();

?>
