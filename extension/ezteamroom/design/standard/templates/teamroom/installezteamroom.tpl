{*
        'site_access_name',     hash(   'info',     'Name of the new teamroom frontend siteaccess',
                                        'type',     'string',
                                        'default',  'ezteamroom'
                                    ),
        'sa_abbr',              hash(   'info',     'Short name (URIMatchMapItem) of the new teamroom siteaccess',
                                        'type',     'string',
                                        'default',  'teamroom'
                                    ),

*}
{set $tpl_info = hash(
        'data_source',          hash(   'info',     'Directory to data',
                                        'type',     'string',
                                        'default',  'extension/ezteamroom/data'
                                    ),
        'teamroom_parent_node', hash(   'info',     'Parent node of the eZ Teamroom frontpage content object',
                                        'type',     'integer',
                                        'default',  2
                                    ),
        'admin_access_name',    hash(   'info',     'Name of the existing admin siteaccess',
                                        'type',     'string',
                                        'default',  'site_admin'
                                    ),
        'guest_group_id',       hash(   'info',     'Content object ID of the eZ Publish user group to store guest accounts',
                                        'type',     'integer',
                                        'default',  '11'
                                    ),
        'user_group_class_id',  hash(   'info',     'Class ID of the default user group class',
                                        'type',     'integer',
                                        'default',  '3'
                                    ),
        'folder_class_id',      hash(   'info',     'Class ID of the default folder class',
                                        'type',     'integer',
                                        'default',  '1'
                                    ),
        'language',             hash(   'info',     'Language which should eZ teamroom installed in.',
                                        'type',     'string',
                                        'default',  'eng-GB'
                                    ),
        'public_section_id',    hash(   'info',     'Section used for public teamrooms (0 will create a new section).',
                                        'type',     'integer',
                                        'default',  '0'
                                    ),
        'users_section_id',     hash(   'info',     'Section ID of the users section.',
                                        'type',     'integer',
                                        'default',  '2'
                                    ),
        'host_url',             hash(   'info',     'Please enter the complete URL to your new Teamroom installation (without http://).',
                                        'type',     'string',
                                        'default',  'www.mysite.com/ezteamroom'
                                    ),
        'use_internal',         hash(   'info',     'Do you want to make use of the state "internal" for teamrooms (no).',
                                        'type',     'string',
                                        'default',  'no'
                                    )
)}
{def $site_access_name      = 'ezteamroom'
     $sa_abbr               = 'teamroom'
     $site_access_dir       = concat( 'settings/siteaccess/', $site_access_name)
     $admin_site_access_dir = concat( 'settings/siteaccess/', $admin_access_name)
             $user_class_id = 4
       $guest_group_node_id = 12} {* Default node id of "Guest accounts" *}
{set-block variable='xml_data'}
<eZXMLImporter data_source="{$data_source}">
  <ProccessInformation comment="Check requirements" />
  <CheckTeamroomRequirements public_section_id="{$public_section_id}" data_source="{$data_source}" teamroom_root_node="{$teamroom_parent_node}"
                             site_access_name="{$site_access_name}" admin_access_name="{$admin_access_name}" sa_abbr="{$sa_abbr}" guest_group_id="{$guest_group_id}"
                             user_group_class_id="{$user_group_class_id}" users_section_id="{$users_section_id}" folder_class_id="{$folder_class_id}"
                             host_url="{$host_url}" use_internal="{$use_internal}" />
  <ProccessInformation comment="Creating sections" />

    {* In both cases a new section should be created for the public teamrooms: *}

    {if is_set( $public_section_id )|not()}

        {def $public_section_id = 'internal:SECTION_PUBLIC_TEAMROOM'}

    {/if}

    {if $public_section_id|eq( 0 )}

        {set $public_section_id = 'internal:SECTION_PUBLIC_TEAMROOM'}

    {/if}

  <CreateSection sectionName="{'Private Teamroom'|i18n( 'ezteamroom/install/sections' )}" referenceID="SECTION_TEAMROOM" navigationPart="ezcontentnavigationpart" />

    {if $public_section_id|eq( 0 )}

  <CreateSection sectionName="{'Public Teamroom'|i18n( 'ezteamroom/install/sections' )}" referenceID="SECTION_PUBLIC_TEAMROOM" navigationPart="ezcontentnavigationpart" />

    {/if}

  <ProccessInformation comment="Creating classes" />
  <CreateClass>
    <ContentClass isContainer="false" identifier="image" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_IMAGE">
        <Names {$language}="{"Image"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
        <Groups>
         <Group name="Media"/> {* If the group does not exist, it will be created automatically *}
        </Groups>
        <Attributes>
            <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
                <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <max-length>150</max-length>
                    <default-string/>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="caption" placement="2">
                <Names {$language}="{"Caption"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <text-column-count>2</text-column-count>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezimage" required="false" searchable="false" informationCollector="false" translatable="true" identifier="image" placement="3">
                <Names {$language}="{"Image"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <max-size>2</max-size>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezkeyword" required="false" searchable="true" informationCollector="false" translatable="true" identifier="tags" placement="4">
                <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                </DatatypeParameters>
            </Attribute>
        </Attributes>
    </ContentClass>
    <ContentClass isContainer="false" identifier="quicktime" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_QUICKTIME">
        <Names {$language}="{"Quicktime"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
        <Groups>
         <Group name="Media"/> {* If the group does not exist, it will be created automatically *}
        </Groups>
        <Attributes>
            <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
                <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <max-length>150</max-length>
                    <default-string/>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="description" placement="2">
                <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}"  always-available="{$language}"/>
                <DatatypeParameters>
                    <text-column-count>2</text-column-count>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezmedia" required="false" searchable="false" informationCollector="false" translatable="true" identifier="file" placement="3">
                <Names {$language}="{"File"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <max-size unit-size="mega">0</max-size>
                    <type>quick_time</type>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezkeyword" required="false" searchable="true" informationCollector="false" translatable="true" identifier="tags" placement="4">
                <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                </DatatypeParameters>
            </Attribute>
        </Attributes>
    </ContentClass>
    <ContentClass isContainer="false" identifier="real_video" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_REALVIDEO">
        <Names {$language}="{"Real video"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
        <Groups>
         <Group name="Media"/> {* If the group does not exist, it will be created automatically *}
        </Groups>
        <Attributes>
            <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
                <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <max-length>150</max-length>
                    <default-string/>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="description" placement="2">
                <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <text-column-count>2</text-column-count>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezmedia" required="false" searchable="false" informationCollector="false" translatable="true" identifier="file" placement="3">
                <Names {$language}="{"File"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <max-size unit-size="mega">0</max-size>
                    <type>real_player</type>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezkeyword" required="false" searchable="true" informationCollector="false" translatable="true" identifier="tags" placement="4">
                <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                </DatatypeParameters>
            </Attribute>
        </Attributes>
    </ContentClass>
    <ContentClass isContainer="false" identifier="file" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_FILE">
        <Names {$language}="{"File"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
        <Groups>
         <Group name="Media"/> {* If the group does not exist, it will be created automatically *}
        </Groups>
        <Attributes>
            <Attribute datatype="ezboolean" required="false" searchable="true" informationCollector="false" translatable="true" identifier="lock" placement="6">
              <Names {$language}="{"Lock"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
              <DatatypeParameters>
                <default-value/>
              </DatatypeParameters>
            </Attribute>
        </Attributes>
    </ContentClass>
    <ContentClass isContainer="false" identifier="windows_media" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_WINDOWSMEDIA">
        <Names {$language}="{"Windows media"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
        <Groups>
         <Group name="Media"/> {* If the group does not exist, it will be created automatically *}
        </Groups>
        <Attributes>
            <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
                <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <max-length>150</max-length>
                    <default-string/>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="description" placement="2">
                <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <text-column-count>2</text-column-count>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezmedia" required="false" searchable="false" informationCollector="false" translatable="true" identifier="file" placement="3">
                <Names {$language}="{"File"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <max-size unit-size="mega">0</max-size>
                    <type>windows_media_player</type>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezkeyword" required="false" searchable="true" informationCollector="false" translatable="true" identifier="tags" placement="4">
                <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                </DatatypeParameters>
            </Attribute>
        </Attributes>
    </ContentClass>
    <ContentClass isContainer="false" identifier="user" remoteID="40faa822edc579b02c25f6bb7beec3ad" objectNamePattern="&lt;first_name&gt; &lt;last_name&gt;" urlAliasPattern="" classExistAction="extend">
        <Names always-available="{$language}" {$language}="{"User"|i18n( 'ezteamroom/install/classes' )}" />
            <Groups>
                <Group name="Users"/> {* If the group does not exist, it will be created automatically *}
            </Groups>
            <Attributes>
                <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="first_name" placement="1">
                    <Names always-available="{$language}" {$language}="{"First name"|i18n( 'ezteamroom/install/classes' )}" />
                    <DatatypeParameters>
                        <max-length>255</max-length>
                        <default-string/>
                        </DatatypeParameters>
                </Attribute>
                <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="last_name" placement="2">
                    <Names always-available="{$language}" {$language}="{"Last name"|i18n( 'ezteamroom/install/classes' )}" />
                    <DatatypeParameters>
                        <max-length>255</max-length>
                        <default-string/>
                    </DatatypeParameters>
                </Attribute>
                <Attribute datatype="ezuser" required="true" searchable="true" informationCollector="false" translatable="true" identifier="user_account" placement="3">
                    <Names always-available="{$language}" {$language}="{"User account"|i18n( 'ezteamroom/install/classes' )}" />
                    <DatatypeParameters>
                    </DatatypeParameters>
                </Attribute>
                <Attribute datatype="eztext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="signature" placement="4">
                    <Names always-available="{$language}" {$language}="{"Signature"|i18n( 'ezteamroom/install/classes' )}" />
                    <DatatypeParameters>
                        <text-column-count>10</text-column-count>
                    </DatatypeParameters>
                </Attribute>
                <Attribute datatype="ezimage" required="false" searchable="false" informationCollector="false" translatable="true" identifier="image" placement="5">
                    <Names always-available="{$language}" {$language}="{"Image"|i18n( 'ezteamroom/install/classes' )}" />
                    <DatatypeParameters>
                        <max-size>1</max-size>
                    </DatatypeParameters>
                </Attribute>
            </Attributes>
       </ContentClass>
        <ContentClass isContainer="false" identifier="teamroom_comment" remoteID="" objectNamePattern="&lt;subject&gt;" urlAliasPattern=""  classExistAction="extend" referenceID="CLASS_COMMENT">
            <Names {$language}="{"Teamroom comment"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
            <Groups>
             <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
            </Groups>
            <Attributes>
                <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="subject" placement="1">
                    <Names {$language}="{"Subject"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
                    <DatatypeParameters>
                        <max-length>100</max-length>
                        <default-string/>
                    </DatatypeParameters>
                </Attribute>
                <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="author" placement="2">
                    <Names {$language}="{"Author"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
                    <DatatypeParameters>
                        <max-length>0</max-length>
                        <default-string/>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="eztext" required="true" searchable="true" informationCollector="false" translatable="true" identifier="message" placement="3">
                <Names {$language}="{"Message"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
                <DatatypeParameters>
                    <text-column-count>20</text-column-count>
                </DatatypeParameters>
            </Attribute>
        </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_blog" remoteID="" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_BLOG">
      <Names {$language}="{"Teamroom blog"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
        <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="false" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
          <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="description" placement="2">
          <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>5</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezkeyword" required="false" searchable="true" informationCollector="false" translatable="true" identifier="tags" placement="3">
          <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_blog_post" remoteID="" objectNamePattern="&lt;title&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_BLOGPOST">
      <Names {$language}="{"Teamroom Blog post"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
        <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="false" searchable="true" informationCollector="false" translatable="true" identifier="title" placement="1">
          <Names {$language}="{"Title"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="body" placement="2">
          <Names {$language}="{"Body"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>25</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezdatetime" required="false" searchable="true" informationCollector="false" translatable="true" identifier="publication_date" placement="3">
          <Names {$language}="{"Publication date"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <default-value type="current-date" />
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezdatetime" required="false" searchable="true" informationCollector="false" translatable="true" identifier="unpublish_date" placement="4">
          <Names {$language}="{"Unpublish date"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <default-value type="empty" />
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezkeyword" required="false" searchable="true" informationCollector="false" translatable="true" identifier="tags" placement="5">
          <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezboolean" required="false" searchable="true" informationCollector="false" translatable="true" identifier="enable_comments" placement="6">
          <Names {$language}="{"Enable comments"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <default-value/>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_frontpage" remoteID="" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_FRONTPAGE">
      <Names {$language}="{"Teamroom frontpage"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
         <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
          <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezobjectrelation" required="false" searchable="false" informationCollector="false" translatable="true" identifier="billboard" placement="2">
          <Names {$language}="{"Billboard"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <selection-type/>
            <fuzzy-match/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="left_column" placement="3">
          <Names {$language}="{"Left column"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>20</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="center_column" placement="4">
          <Names {$language}="{"Center column"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>20</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="right_column" placement="5">
          <Names {$language}="{"Right column"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>20</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="bottom_column" placement="6">
          <Names {$language}="{"Bottom column"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>10</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezkeyword" required="false" searchable="true" informationCollector="false" translatable="true" identifier="tags" placement="7">
          <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_documentation_page" remoteID="" objectNamePattern="&lt;title&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_WIKI">
      <Names {$language}="{"Teamroom documentation page"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
         <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="title" placement="1">
          <Names {$language}="{"Title"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="body" placement="2">
          <Names {$language}="{"Body"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>20</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezkeyword" required="false" searchable="true" informationCollector="false" translatable="true" identifier="tags" placement="3">
          <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezboolean" required="false" searchable="false" informationCollector="false" translatable="true" identifier="show_children" placement="4">
          <Names {$language}="{"Display sub items"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <default-value/>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="false" identifier="teamroom_infobox" remoteID="" objectNamePattern="&lt;header&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_INFOBOX">
      <Names {$language}="{"Teamroom info box"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
         <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="true" searchable="false" informationCollector="false" translatable="true" identifier="header" placement="1">
          <Names {$language}="{"Header"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezobjectrelation" required="false" searchable="true" informationCollector="false" translatable="true" identifier="box_icon" placement="2">
          <Names {$language}="{"Box Icon"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <selection-type/>
            <fuzzy-match/>
            <default-selection/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="false" informationCollector="false" translatable="true" identifier="content" placement="3">
          <Names {$language}="{"Content"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>10</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezurl" required="false" searchable="false" informationCollector="false" translatable="true" identifier="url" placement="4">
          <Names {$language}="{"URL"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezstring" required="false" searchable="false" informationCollector="false" translatable="true" identifier="module_url" placement="5">
          <Names {$language}="{"Module URL"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezstring" required="false" searchable="false" informationCollector="false" translatable="true" identifier="check_access" placement="6">
          <Names {$language}="{"Check access"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezobjectrelation" required="false" searchable="false" informationCollector="false" translatable="true" identifier="relates_to" placement="7">
          <Names {$language}="{"Relates to"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <selection-type>0</selection-type>
            <fuzzy-match/>
            <default-selection/>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="false" identifier="teamroom_file" remoteID="" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_FILE">
      <Names {$language}="{"Teamroom file"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
         <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="false" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
          <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string />
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezselection" required="false" searchable="true" informationCollector="false" translatable="true" identifier="category" placement="6">
          <Names {$language}="{"Category"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <options>
              <option id="0" name="{'Documents'|i18n( 'ezteamroom/install/classes' )}" />
              <option id="1" name="{'Lightboxes'|i18n( 'ezteamroom/install/classes' )}" />
              <option id="2" name="{'Sounds'|i18n( 'ezteamroom/install/classes' )}" />
              <option id="3" name="{'Pictures'|i18n( 'ezteamroom/install/classes' )}" />
            </options>
            <is-multiselect>0</is-multiselect>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="description" placement="7">
          <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>2</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezimage" required="false" searchable="false" informationCollector="false" translatable="true" identifier="thumbnail" placement="5">
          <Names {$language}="{"Thumbnail"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-size>0</max-size>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezbinaryfile" required="false" searchable="false" informationCollector="false" translatable="true" identifier="file" placement="3">
          <Names {$language}="{"File"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-size>0</max-size>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezkeyword" required="false" searchable="true" informationCollector="false" translatable="true" identifier="tags" placement="4">
          <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_forum" remoteID="" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_FORUM">
      <Names {$language}="{"Teamroom forum"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
         <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
          <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="description" placement="2">
          <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>10</text-column-count>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_forum_topic" remoteID="" objectNamePattern="&lt;subject&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_FORUMTOPIC">
      <Names {$language}="{"Teamroom forum topic"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
         <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="subject" placement="1">
          <Names {$language}="{"Subject"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="eztext" required="true" searchable="true" informationCollector="false" translatable="true" identifier="message" placement="2">
          <Names {$language}="{"Message"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>10</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezboolean" required="false" searchable="true" informationCollector="false" translatable="true" identifier="sticky" placement="3">
          <Names {$language}="{"Sticky"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <default-value/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezsubtreesubscription" required="false" searchable="false" informationCollector="false" translatable="true" identifier="notify_me" placement="4">
          <Names {$language}="{"Notify me about updates"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="false" identifier="teamroom_forum_reply" remoteID="" objectNamePattern="&lt;subject&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_FORUMREPLY">
      <Names {$language}="{"Teamroom forum reply"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
         <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="false" searchable="true" informationCollector="false" translatable="true" identifier="subject" placement="1">
          <Names {$language}="{"Subject"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="eztext" required="true" searchable="true" informationCollector="false" translatable="true" identifier="message" placement="2">
          <Names {$language}="{"Message"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>10</text-column-count>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="false" identifier="teamroom_event" remoteID="" objectNamePattern="&lt;short_title|title&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_EVENT">
      <Names {$language}="{"Teamroom event"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
         <Group name="Teamroom"/>
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="false" searchable="true" informationCollector="false" translatable="true" identifier="title" placement="1">
          <Names {$language}="{"Full title"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>55</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="short_title" placement="2">
          <Names {$language}="{"Short title"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>19</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="text" placement="3">
          <Names {$language}="{"Text"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>10</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezkeyword" required="false" searchable="true" informationCollector="false" translatable="true" identifier="category" placement="4">
          <Names {$language}="{"Category"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezevent" required="true" searchable="true" informationCollector="false" translatable="false" identifier="event_date" placement="5">
          <Names {$language}="{"Date"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <default-value type="empty" />
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezstring" required="false" searchable="true" informationCollector="false" translatable="true" identifier="location" placement="6">
          <Names {$language}="{"Location"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_event_calendar" remoteID="" objectNamePattern="&lt;short_title|title&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_EVENTCALENDAR">
      <Names {$language}="{"Teamroom event calendar"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
         <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="title" placement="1">
          <Names {$language}="{"Full Title"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>65</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezstring" required="false" searchable="true" informationCollector="false" translatable="true" identifier="short_title" placement="2">
          <Names {$language}="{"Short Title"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>25</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezselection" required="true" searchable="false" informationCollector="false" translatable="false" identifier="view" placement="3">
          <Names {$language}="{"View"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <options>
            </options>
            <is-multiselect>0</is-multiselect>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_news_folder" remoteID="" objectNamePattern="&lt;short_name|name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_NEWSFOLDER">
      <Names {$language}="{"Teamroom news folder"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
      <Groups>
         <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="false" searchable="true" informationCollector="false" translatable="true" identifier="short_name" placement="1">
          <Names {$language}="{"Short name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
          <DatatypeParameters>
            <max-length>100</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="2">
          <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
          <DatatypeParameters>
            <max-length>255</max-length>
            <default-string>{'Folder'|i18n( 'ezteamroom/install/classes' )}"</default-string>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="short_description" placement="3">
          <Names {$language}="{"Summary"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
          <DatatypeParameters>
            <text-column-count>5</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="description" placement="4">
          <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
          <DatatypeParameters>
            <text-column-count>20</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezboolean" required="false" searchable="false" informationCollector="false" translatable="false" identifier="show_children" placement="5">
          <Names {$language}="{"Display sub items"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
          <DatatypeParameters>
            <default-value/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezkeyword" required="false" searchable="true" informationCollector="false" translatable="true" identifier="tags" placement="6">
          <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
          <DatatypeParameters>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezdatetime" required="false" searchable="true" informationCollector="false" translatable="true" identifier="publish_date" placement="7">
          <Names {$language}="{"Publish date"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
          <DatatypeParameters>
            <default-value type="current-date" />
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_personal_frontpage" remoteID="" objectNamePattern="&lt;short_title|title&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_PERSONALFRONTPAGE">
      <Names {$language}="{"Teamroom personalized frontpage"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
        <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="title" placement="1">
          <Names {$language}="{"Title"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezstring" required="false" searchable="true" informationCollector="false" translatable="true" identifier="short_title" placement="2">
          <Names {$language}="{"Short title"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="description" placement="3">
          <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>10</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezinteger" required="true" searchable="true" informationCollector="false" translatable="true" identifier="num_of_columns" placement="4">
          <Names {$language}="{"Number of columns"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <default-value>3</default-value>
            <min-value>1</min-value>
            <max-value>10</max-value>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezboolean" required="false" searchable="true" informationCollector="false" translatable="true" identifier="allow_minimization" placement="5">
          <Names {$language}="{"Allow Minimization"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <default-value/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezstring" required="false" searchable="true" informationCollector="false" translatable="true" identifier="default_arrangement" placement="6">
          <Names {$language}="{"Default arrangement"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string>[[0,1],[2,3,4],[5,6,7]]</default-string>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_room" remoteID="" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_TEAMROOM">
      <Names {$language}="{"Teamroom room"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
        <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
          <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>255</max-length>
            <default-string>Teamroom</default-string>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezselection" required="true" searchable="false" informationCollector="false" translatable="true" identifier="access_type" placement="2">
          <Names {$language}="{"Access type"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <options>
              <option id="0" name="{'Private'|i18n( 'ezteamroom/access_type' )}" />

{if $use_internal|eq( 'yes' )}

              <option id="1" name="{'Internal'|i18n( 'ezteamroom/access_type' )}" />
              <option id="2" name="{'Protected'|i18n( 'ezteamroom/access_type' )}" />
              <option id="3" name="{'Public'|i18n( 'ezteamroom/access_type' )}" />

{else}

              <option id="1" name="{'Protected'|i18n( 'ezteamroom/access_type' )}" />
              <option id="2" name="{'Public'|i18n( 'ezteamroom/access_type' )}" />

{/if}

            </options>
            <is-multiselect>0</is-multiselect>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="description" placement="3">
          <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>5</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezstring" required="false" searchable="true" informationCollector="false" translatable="true" identifier="default_arrangement" placement="4">
          <Names {$language}="{"Default arrangement"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezfeatureselect" required="false" searchable="false" informationCollector="false" translatable="true" identifier="feature_list" placement="5">
          <Names {$language}="{"Feature list"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <default-string>teamroom/createteamroom.tpl</default-string>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_task_list" remoteID="" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_TASKLIST">
      <Names {$language}="{"Teamroom tasks"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
        <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
          <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>0</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="description" placement="2">
          <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>10</text-column-count>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_task" remoteID="" objectNamePattern="&lt;title&gt;" urlAliasPattern="" referenceID="CLASS_TASK" classExistAction="extend">
        <Names {$language}="{"Teamroom task"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
        <Groups>
            <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
        </Groups>
        <Attributes>
            <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="false" identifier="title" placement="1">
                <Names {$language}="{"Title"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <max-length>0</max-length>
                    <default-string/>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="eztext" required="false" searchable="true" informationCollector="false" translatable="false" identifier="description" placement="2">
                <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <text-column-count>10</text-column-count>
                </DatatypeParameters>
            </Attribute>
                <Attribute datatype="ezinteger" required="true" searchable="true" informationCollector="false" translatable="false" identifier="progress" placement="3">
                    <Names {$language}="{"Progress"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                    <DatatypeParameters>
                        <default-value>0</default-value>
                        <min-value>0</min-value>
                        <max-value>100</max-value>
                    </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezdatetime" required="false" searchable="true" informationCollector="false" translatable="false" identifier="planned_end_date" placement="4">
                <Names {$language}="{"Planned end date"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <default-value type="empty" />
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezdatetime" required="false" searchable="true" informationCollector="false" translatable="false" identifier="end_date" placement="5">
                <Names {$language}="{"End Date"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <default-value type="empty" />
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezinteger" required="false" searchable="true" informationCollector="false" translatable="false" identifier="est_hours" placement="6">
                <Names {$language}="{"Estimated Effort (hours)"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <default-value>0</default-value>
                    <min-value>0</min-value>
                    <max-value>100</max-value>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezinteger" required="false" searchable="true" informationCollector="false" translatable="false" identifier="est_minutes" placement="7">
                <Names {$language}="{"Estimated Effort (minutes)"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                        <default-value>0</default-value>
                        <min-value>0</min-value>
                        <max-value>60</max-value>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezkeyword" required="false" searchable="true" informationCollector="false" translatable="false" identifier="tags" placement="8">
                <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezobjectrelationlist" required="false" searchable="true" informationCollector="false" translatable="false" identifier="users" placement="9">
                <Names {$language}="{"Users"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <type>2</type>
                    <selection-type>4</selection-type>
                    <class-constraints>
                        <class-constraint class-identifier="user"/>
                    </class-constraints>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezobjectrelationlist" required="false" searchable="true" informationCollector="false" translatable="false" identifier="documents" placement="10">
                <Names {$language}="{"Related documents"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <type>2</type>
                    <selection-type>4</selection-type>
                    <class-constraints>
                        <class-constraint class-identifier="folder"/>
                        <class-constraint class-identifier="teamroom_blog"/>
                        <class-constraint class-identifier="teamroom_blog_post"/>
                        <class-constraint class-identifier="teamroom_documentation_page"/>
                        <class-constraint class-identifier="teamroom_file"/>
                        <class-constraint class-identifier="teamroom_forum"/>
                        <class-constraint class-identifier="teamroom_forum_topic"/>
                        <class-constraint class-identifier="teamroom_event"/>
                        <class-constraint class-identifier="teamroom_file_folder"/>
                        <class-constraint class-identifier="teamroom_file_subfolder"/>
                        <class-constraint class-identifier="teamroom_milestone"/>
                        <class-constraint class-identifier="teamroom_milestone_folder"/>
                    </class-constraints>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezinteger" required="true" searchable="false" informationCollector="false" translatable="false" identifier="priority" placement="11">
                <Names {$language}="{"Priority"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <default-value>5</default-value>
                    <min-value>1</min-value>
                    <max-value>5</max-value>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezobjectrelationlist" required="false" searchable="true" informationCollector="false" translatable="true" identifier="milestone" placement="12">
                <Names {$language}="{"Milestone"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <type>2</type>
                    <selection-type>4</selection-type>
                    <class-constraints>
                        <class-constraint class-identifier="teamroom_milestone"/>
                    </class-constraints>
                </DatatypeParameters>
            </Attribute>
        </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_file_folder" remoteID="" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_FILEFOLDER">
      <Names {$language}="{"Teamroom file folder"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
        <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
          <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>255</max-length>
            <default-string>{'Folder'|i18n( 'ezteamroom/install/classes' )}"</default-string>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="description" placement="4">
          <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>20</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezkeyword" required="false" searchable="false" informationCollector="false" translatable="true" identifier="tags" placement="5">
          <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_file_subfolder" remoteID="" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_FILESUBFOLDER">
      <Names {$language}="{"Teamroom file subfolder"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
        <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
          <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>255</max-length>
            <default-string>{'Subfolder'|i18n( 'ezteamroom/install/classes' )}"</default-string>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="description" placement="4">
          <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>10</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezkeyword" required="false" searchable="false" informationCollector="false" translatable="true" identifier="tags" placement="5">
          <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_box_folder" remoteID="" objectNamePattern="&lt;name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_BOXFOLDER">
      <Names {$language}="{"Teamroom infobox folder"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
        <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
          <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>255</max-length>
            <default-string>{'Folder'|i18n( 'ezteamroom/install/classes' )}"</default-string>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="false" identifier="teamroom_milestone" remoteID="" objectNamePattern="&lt;title&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_MILESTONE">
        <Names {$language}="{"Teamroom milestone"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
        <Groups>
            <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
        </Groups>
        <Attributes>
            <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="false" identifier="title" placement="1">
                <Names {$language}="{"Title"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <max-length>0</max-length>
                    <default-string/>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezboolean" required="false" searchable="true" informationCollector="false" translatable="false" identifier="closed" placement="2">
                <Names {$language}="{"Closed"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <default-value/>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="false" identifier="description" placement="3">
                <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <text-column-count>10</text-column-count>
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezdatetime" required="false" searchable="true" informationCollector="false" translatable="false" identifier="date" placement="4">
                <Names {$language}="{"Date"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                    <default-value type="empty" />
                </DatatypeParameters>
            </Attribute>
            <Attribute datatype="ezkeyword" required="false" searchable="true" informationCollector="false" translatable="true" identifier="tags" placement="5">
                <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
                <DatatypeParameters>
                </DatatypeParameters>
            </Attribute>
        </Attributes>
    </ContentClass>
    <ContentClass isContainer="true" identifier="teamroom_milestone_folder" remoteID="" objectNamePattern="&lt;short_name|name&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_MILESTONEFOLDER">
      <Names {$language}="{"Teamroom milestone folder"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
      <Groups>
        <Group name="Teamroom"/> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezstring" required="true" searchable="true" informationCollector="false" translatable="true" identifier="name" placement="1">
          <Names {$language}="{"Name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>255</max-length>
            <default-string>{'Folder'|i18n( 'ezteamroom/install/classes' )}"</default-string>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezstring" required="false" searchable="true" informationCollector="false" translatable="true" identifier="short_name" placement="2">
          <Names {$language}="{"Short name"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <max-length>100</max-length>
            <default-string/>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="short_description" placement="3">
          <Names {$language}="{"Summary"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>5</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezxmltext" required="false" searchable="true" informationCollector="false" translatable="true" identifier="description" placement="4">
          <Names {$language}="{"Description"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
            <text-column-count>20</text-column-count>
          </DatatypeParameters>
        </Attribute>
        <Attribute datatype="ezkeyword" required="false" searchable="false" informationCollector="false" translatable="true" identifier="tags" placement="5">
          <Names {$language}="{"Tags"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
          <DatatypeParameters>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="false" identifier="teamroom_lightbox" remoteID="" objectNamePattern="&lt;name&gt;" urlAliasPattern="&lt;name&gt;" classExistAction="extend" referenceID="CLASS_LIGHTBOX">
      <Names {$language}="{"Teamroom lightbox"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
      <Groups>
        <Group name="Teamroom" /> {* If the group does not exist, it will be created automatically *}
      </Groups>
      <Attributes>
        <Attribute datatype="ezlightboxwrapper" required="false" searchable="false" informationCollector="false" translatable="true" identifier="lightbox" placement="2">
          <Names {$language}="{"Lightbox"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
          <DatatypeParameters />
        </Attribute>
        <Attribute datatype="ezselection" required="false" searchable="true" informationCollector="false" translatable="true" identifier="category" placement="3">
          <Names {$language}="{"Category"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}" />
          <DatatypeParameters>
            <options>
              <option id="0" name="{'Documents'|i18n( 'ezteamroom/install/classes' )}" />
              <option id="1" name="{'Lightboxes'|i18n( 'ezteamroom/install/classes' )}" />
              <option id="2" name="{'Sounds'|i18n( 'ezteamroom/install/classes' )}" />
              <option id="3" name="{'Pictures'|i18n( 'ezteamroom/install/classes' )}" />
            </options>
            <is-multiselect>0</is-multiselect>
          </DatatypeParameters>
        </Attribute>
      </Attributes>
    </ContentClass>
  </CreateClass>
  <ProccessInformation comment="Content in media section" />
  <CreateContent parentNode="43">
        <ContentObject contentClass="folder" section="3" remoteID="teamroom_image_pool">
            <Attributes>
                <name>Teamroom Image Pool</name>
                <short_name>Teamroom Image Pool</short_name>
            </Attributes>
            <SetReference attribute="object_id" value="FOLDER_IMAGE_POOL" />
            <SetReference attribute="node_id" value="FOLDER_IMAGE_POOL_NODE" />
            <Childs>
                <ContentObject contentClass="image" section="3" remoteID="">
                    <Attributes>
                        <name>Title Image</name>
                        <image src="people.gif" title="Teamroom Group" />
                    </Attributes>
                    <SetReference attribute="object_id" value="TEAMROOM_TITLE_IMAGE" />
                </ContentObject>
            </Childs>
        </ContentObject>
        <ContentObject contentClass="folder" section="3" remoteID="teamroom_box_icons">
            <Attributes>
                <name>Teamroom Box Icons</name>
                <short_name>Teamroom Box Icons</short_name>
            </Attributes>
            <SetReference attribute="object_id" value="TEAMROOM_BOXICON_POOL" />
            <SetReference attribute="node_id" value="TEAMROOM_BOXICON_POOL_NODE" />
            <Childs>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_003">
                    <Attributes>
                        <name>Icon 1</name>
                        <image src="icon003.gif" title="Icon 1" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_003" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_168">
                    <Attributes>
                        <name>Icon 2</name>
                        <image src="icon168.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_168" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_170">
                    <Attributes>
                        <name>Icon 3</name>
                        <image src="icon170.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_170" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_224">
                    <Attributes>
                        <name>Icon 4</name>
                        <image src="icon224.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_224" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_226">
                    <Attributes>
                        <name>Icon 5</name>
                        <image src="icon226.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_226" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_613">
                    <Attributes>
                        <name>Icon 6</name>
                        <image src="icon613.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_613" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_618">
                    <Attributes>
                        <name>Icon 7</name>
                        <image src="icon618.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_618" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_619">
                    <Attributes>
                        <name>Icon 8</name>
                        <image src="icon619.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_619" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_620">
                    <Attributes>
                        <name>Icon 9</name>
                        <image src="icon620.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_620" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_673">
                    <Attributes>
                        <name>Icon 10</name>
                        <image src="icon673.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_673" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_674">
                    <Attributes>
                        <name>Icon 11</name>
                        <image src="icon674.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_674" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_675">
                    <Attributes>
                        <name>Icon 12</name>
                        <image src="icon675.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_675" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_676">
                    <Attributes>
                        <name>Icon 13</name>
                        <image src="icon676.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_676" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_677">
                    <Attributes>
                        <name>Icon 14</name>
                        <image src="icon677.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_677" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_678">
                    <Attributes>
                        <name>Icon 15</name>
                        <image src="icon678.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_678" />
                </ContentObject>
                <ContentObject contentClass="image" section="3" remoteID="TEAMROOM_ICON_679">
                    <Attributes>
                        <name>Icon 16</name>
                        <image src="icon679.gif" title="Icon" />
                    </Attributes>
                    <SetReference attribute="object_id" value="ICON_679" />
                </ContentObject>
            </Childs>
        </ContentObject>
  </CreateContent>
  <ProccessInformation comment="Creating roles" />
  <CreateRole>
    <Role name="{'Use Teamroom'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_USETEAMROOM">
      <Policy module="notification" function="use">
      </Policy>
      <Policy module="ezoe" function="editor">
      </Policy>
      <Policy module="ezjscore" function="run">
      </Policy>
      <Policy module="teamroom" function="create">
      </Policy>
      <Policy module="user" function="selfedit">
      </Policy>
      <Policy module="user" function="password">
      </Policy>
      <Policy module="collaboration" function="*">
      </Policy>
      <Policy module="user" function="login">
        <Limitations>
          <SiteAccess>2978804645</SiteAccess> {* CRC value of "ezteamroom" *}
        </Limitations>
      </Policy>
      <Policy module="teamroom" function="register">
        <Limitations>
          <Section>2</Section>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
        </Limitations>
      </Policy>
      <Policy module="content" function="read">
        <Limitations>
          <Section>{$public_section_id}</Section>
        </Limitations>
      </Policy>
      <Policy module="content" function="create">
        <Limitations>
          <Class>internal:CLASS_TEAMROOM</Class>
          <ParentClass>internal:CLASS_PERSONALFRONTPAGE</ParentClass>
          <Section>{$public_section_id}</Section>
        </Limitations>
      </Policy>
      <Policy module="teamroom" function="resign">
      </Policy>
      <Policy module="teamroom" function="invite">
      </Policy>
      <Policy module="content" function="pendinglist">
      </Policy>
      <Policy module="content" function="read">
        <Limitations>

{def $guestGroupPathString = ''}

{if $guest_group_id}

    {def $guestUserGroupObject = fetch( 'content', 'object', hash( 'object_id', $guest_group_id ) )}

    {set $guest_group_node_id  = $guestUserGroupObject.main_node_id
         $guestGroupPathString = $guestUserGroupObject.main_node.path_string}

{/if}

          <Subtree>{$guestGroupPathString}</Subtree>
          <Class>{$user_class_id}</Class>
          <Section>{$users_section_id}</Section>
        </Limitations>
      </Policy>
      <Policy module="content" function="view_embed">
        <Limitations>
          <Class>internal:CLASS_IMAGE</Class>
        </Limitations>
      </Policy>
    </Role>
    <Role name="{'Use Lightbox'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_USELIGHTBOX">
      <Policy module="lightbox" function="add">
      </Policy>
      <Policy module="lightbox" function="send">
        <Limitations>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
      <Policy module="lightbox" function="create">
      </Policy>
      <Policy module="lightbox" function="grant">
        <Limitations>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
      <Policy module="lightbox" function="edit">
        <Limitations>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
      <Policy module="lightbox" function="view">
      </Policy>
    </Role>
    <Role name="Teamroom {'Member'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_1">
      <Policy module="ezoe" function="*">
      </Policy>
      <Policy module="content" function="pendinglist">
      </Policy>
      <Policy module="content" function="bookmark">
      </Policy>
      <Policy module="content" function="read">
        <Limitations>
          <Class>internal:CLASS_TEAMROOM</Class>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
        </Limitations>
      </Policy>
      <Policy module="content" function="read">
        <Limitations>
          <Class>{$user_group_class_id}</Class>
          <Class>{$user_class_id}</Class>
          <Section>{$users_section_id}</Section>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
        </Limitations>
      </Policy>
      <Policy module="content" function="read">
        <Limitations>
          <Class>internal:CLASS_INFOBOX</Class>
          <Class>internal:CLASS_BOXFOLDER</Class>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
        </Limitations>
      </Policy>
    </Role>
    <Role name="Teamroom {'Moderator'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_2">
      <Policy module="content" function="read">
        <Limitations>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
      <Policy module="content" function="remove">
        <Limitations>
          <Class>internal:CLASS_TEAMROOM</Class>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
      <Policy module="content" function="edit">
        <Limitations>
          <Class>internal:CLASS_TEAMROOM</Class>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
      <Policy module="content" function="create">
        <Limitations>
          <Class>internal:CLASS_BLOGPOST</Class>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
          <ParentClass>internal:CLASS_BLOG</ParentClass>
        </Limitations>
      </Policy>
      <Policy module="content" function="edit">
        <Limitations>
          <Class>internal:CLASS_BLOGPOST</Class>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
      <Policy module="content" function="read">
        <Limitations>
          <Class>{$user_group_class_id}</Class>
          <Class>{$user_class_id}</Class>
          <Section>{$users_section_id}</Section>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
        </Limitations>
      </Policy>
      <Policy module="teamroom" function="manage">
      </Policy>
      <Policy module="content" function="edit">
        <Limitations>
          <Class>internal:CLASS_BLOG</Class>
          <Class>internal:CLASS_WIKI</Class>
          <Class>{$user_group_class_id}</Class>
          <Class>internal:CLASS_FORUM</Class>
          <Class>internal:CLASS_EVENTCALENDAR</Class>
          <Class>internal:CLASS_TASKLIST</Class>
          <Class>internal:CLASS_FILEFOLDER</Class>
          <Class>internal:CLASS_MILESTONEFOLDER</Class>
          <Class>{$folder_class_id}</Class>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
      <Policy module="content" function="read">
        <Limitations>
          <Subtree>{$guestUserGroupObject.main_node.path_string}</Subtree>

{undef $guestUserGroupObject}

        </Limitations>
      </Policy>
    </Role>
    <Role name="Teamroom {'Read Forum'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_3">
      <Policy module="content" function="read">
        <Limitations>
          <Class>internal:CLASS_FORUM</Class>
          <Class>internal:CLASS_FORUMREPLY</Class>
          <Class>internal:CLASS_FORUMTOPIC</Class>
        </Limitations>
      </Policy>
    </Role>
    <Role name="Teamroom {'Use Forum'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_4">
      <Policy module="content" function="create">
        <Limitations>
          <Class>internal:CLASS_FORUMREPLY</Class>
          <Class>internal:CLASS_FORUMTOPIC</Class>
        </Limitations>
      </Policy>
      <Policy module="content" function="edit">
        <Limitations>
          <Class>internal:CLASS_FORUMREPLY</Class>
          <Class>internal:CLASS_FORUMTOPIC</Class>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
      <Policy module="content" function="remove">
        <Limitations>
          <Class>internal:CLASS_FORUMREPLY</Class>
          <Class>internal:CLASS_FORUMTOPIC</Class>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
    </Role>
    <Role name="Teamroom {'Read Blog'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_5">
      <Policy module="content" function="read">
        <Limitations>
          <Class>internal:CLASS_BLOG</Class>
          <Class>internal:CLASS_BLOGPOST</Class>
        </Limitations>
      </Policy>
      <Policy module="content" function="create">
        <Limitations>
          <Class>internal:CLASS_COMMENT</Class>
          <ParentClass>internal:CLASS_BLOGPOST</ParentClass>
        </Limitations>
      </Policy>
      <Policy module="content" function="edit">
        <Limitations>
          <Class>internal:CLASS_COMMENT</Class>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
      <Policy module="content" function="read">
        <Limitations>
          <Class>internal:CLASS_COMMENT</Class>
          <Section>{$public_section_id}</Section>
        </Limitations>
      </Policy>
    </Role>
    <Role name="Teamroom {'Use Blog'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_6">
      <Policy module="content" function="create">
        <Limitations>
          <Class>internal:CLASS_BLOGPOST</Class>
          <ParentClass>internal:CLASS_BLOG</ParentClass>
        </Limitations>
      </Policy>
      <Policy module="content" function="edit">
        <Limitations>
          <Class>internal:CLASS_BLOGPOST</Class>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
      <Policy module="content" function="remove">
        <Limitations>
          <Class>internal:CLASS_BLOGPOST</Class>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
    </Role>
    <Role name="Teamroom {'Read Calendar'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_7">
      <Policy module="content" function="read">
        <Limitations>
          <Class>internal:CLASS_EVENT</Class>
          <Class>internal:CLASS_EVENTCALENDAR</Class>
        </Limitations>
      </Policy>
    </Role>
    <Role name="Teamroom {'Use Calendar'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_8">
      <Policy module="content" function="create">
        <Limitations>
          <Class>internal:CLASS_EVENT</Class>
          <ParentClass>internal:CLASS_EVENTCALENDAR</ParentClass>
        </Limitations>
      </Policy>
      <Policy module="content" function="edit">
        <Limitations>
          <Class>internal:CLASS_EVENT</Class>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
        </Limitations>
      </Policy>
      <Policy module="content" function="remove">
        <Limitations>
          <Class>internal:CLASS_EVENT</Class>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
      <Policy module="event" function="split">
      </Policy>
      <Policy module="ezajax" function="search">
      </Policy>
      <Policy module="ezajax" function="subtree">
      </Policy>
    </Role>
    <Role name="Teamroom {'Read Documents'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_9">
      <Policy module="content" function="read">
        <Limitations>
          <Class>internal:CLASS_FILE</Class>
          <Class>internal:CLASS_FILEFOLDER</Class>
          <Class>internal:CLASS_FILESUBFOLDER</Class>
          <Class>{$folder_class_id}</Class>
          <Class>internal:CLASS_IMAGE</Class>
          <Class>internal:CLASS_LIGHTBOX</Class>
          <Class>internal:CLASS_QUICKTIME</Class>
          <Class>internal:CLASS_WINDOWSMEDIA</Class>
          <Class>internal:CLASS_REALVIDEO</Class>
        </Limitations>
      </Policy>
    </Role>
    <Role name="Teamroom {'Use Documents'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_10">
      <Policy module="content" function="create">
        <Limitations>
          <Class>internal:CLASS_FILE</Class>
          <Class>internal:CLASS_IMAGE</Class>
          <Class>internal:CLASS_LIGHTBOX</Class>
          <Class>internal:CLASS_FILESUBFOLDER</Class>
          <Class>internal:CLASS_QUICKTIME</Class>
          <Class>internal:CLASS_WINDOWSMEDIA</Class>
          <Class>internal:CLASS_REALVIDEO</Class>
          <ParentClass>{$folder_class_id}</ParentClass>
          <ParentClass>internal:CLASS_FILEFOLDER</ParentClass>
          <ParentClass>internal:CLASS_FILESUBFOLDER</ParentClass>
        </Limitations>
      </Policy>
      <Policy module="content" function="edit">
        <Limitations>
          <Class>internal:CLASS_FILE</Class>
          <Class>internal:CLASS_IMAGE</Class>
          <Class>internal:CLASS_LIGHTBOX</Class>
          <Class>internal:CLASS_QUICKTIME</Class>
          <Class>internal:CLASS_WINDOWSMEDIA</Class>
          <Class>internal:CLASS_REALVIDEO</Class>
          <Class>internal:CLASS_FILESUBFOLDER</Class>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
        </Limitations>
      </Policy>
      <Policy module="content" function="remove">
        <Limitations>
          <Class>internal:CLASS_FILE</Class>
          <Class>internal:CLASS_IMAGE</Class>
          <Class>internal:CLASS_LIGHTBOX</Class>
          <Class>internal:CLASS_QUICKTIME</Class>
          <Class>internal:CLASS_WINDOWSMEDIA</Class>
          <Class>internal:CLASS_REALVIDEO</Class>
          <Class>internal:CLASS_FILESUBFOLDER</Class>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
      <Policy module="ezmultiupload" function="*">
      </Policy>
    </Role>
    <Role name="Teamroom {'Read Wiki'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_11">
      <Policy module="content" function="read">
        <Limitations>
          <Class>internal:CLASS_WIKI</Class>
        </Limitations>
      </Policy>
    </Role>
    <Role name="Teamroom {'Use Wiki'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_12">
      <Policy module="content" function="create">
        <Limitations>
          <Class>internal:CLASS_WIKI</Class>
          <ParentClass>internal:CLASS_WIKI</ParentClass>
        </Limitations>
      </Policy>
      <Policy module="content" function="edit">
        <Limitations>
          <Class>internal:CLASS_WIKI</Class>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
        </Limitations>
      </Policy>
      <Policy module="content" function="remove">
        <Limitations>
          <Class>internal:CLASS_WIKI</Class>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
    </Role>
    <Role name="Teamroom {'Read Tasks'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_13">
      <Policy module="content" function="read">
        <Limitations>
          <Class>internal:CLASS_TASK</Class>
          <Class>internal:CLASS_TASKLIST</Class>
        </Limitations>
      </Policy>
    </Role>
    <Role name="Teamroom {'Use Tasks'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_14">
      <Policy module="content" function="create">
        <Limitations>
          <Class>internal:CLASS_TASK</Class>
          <ParentClass>internal:CLASS_TASKLIST</ParentClass>
        </Limitations>
      </Policy>
      <Policy module="content" function="edit">
        <Limitations>
          <Class>internal:CLASS_TASK</Class>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
        </Limitations>
      </Policy>
      <Policy module="tasklist" function="modify">
      </Policy>
      <Policy module="content" function="remove">
        <Limitations>
          <Class>internal:CLASS_TASK</Class>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
    </Role>
    <Role name="Teamroom {'Read Milestones'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_15">
      <Policy module="content" function="read">
        <Limitations>
          <Class>internal:CLASS_MILESTONE</Class>
          <Class>internal:CLASS_MILESTONEFOLDER</Class>
        </Limitations>
      </Policy>
    </Role>
    <Role name="Teamroom {'Use Milestones'|i18n( 'ezteamroom/install/roles' )}" createRole="true" referenceID="ROLE_16">
      <Policy module="content" function="create">
        <Limitations>
          <Class>internal:CLASS_MILESTONE</Class>
          <ParentClass>internal:CLASS_MILESTONEFOLDER</ParentClass>
        </Limitations>
      </Policy>
      <Policy module="content" function="edit">
        <Limitations>
          <Class>internal:CLASS_MILESTONE</Class>
          <Section>internal:SECTION_TEAMROOM</Section>
          <Section>{$public_section_id}</Section>
        </Limitations>
      </Policy>
      <Policy module="content" function="remove">
        <Limitations>
          <Class>internal:CLASS_MILESTONE</Class>
          <Owner>1</Owner>
        </Limitations>
      </Policy>
    </Role>
  </CreateRole>
  <ProccessInformation comment="Create teamroom content" />
  <CreateContent parentNode="{$teamroom_parent_node}">
        <ContentObject contentClass="teamroom_personal_frontpage" section="{$public_section_id}" remoteID="{$teamroom_parent_node}_teamrooms">
            <Attributes>
                <title>{'Welcome. Success with eZ Teamrooms.'|i18n( 'ezteamroom/install/teamroomcontent' )}</title>
                <short_title>Teamrooms</short_title> {* This one should NOT be translated, otherwise the PathPrefix will not work!!! *}
                <description parseReferences="true">&lt;embed size=&quot;large&quot; custom:offset=&quot;0&quot; custom:limit=&quot;5&quot; object_id=&quot;[internal:TEAMROOM_TITLE_IMAGE]&quot; /&gt;Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In tempor. Aenean molestie, mauris ultrices vestibulum luctus, augue risus mattis est, viverra vestibulum diam quam vitae lorem. Nunc lacus tellus, molestie eleifend, dictum quis, fermentum eu, diam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Curabitur hendrerit lectus non nunc. In vulputate, est sed pellentesque congue, est diam ullamcorper enim, a laoreet magna lorem vitae eros. Cras dignissim dictum risus. Sed lectus. Nullam sem. Mauris ac mauris.</description>
                <num_of_columns>4</num_of_columns>
                <allow_minimization>1</allow_minimization>
                <default_arrangement></default_arrangement>
            </Attributes>
            <SetReference attribute="object_id" value="TEAMROOM_ROOT" />
            <SetReference attribute="node_id" value="TEAMROOM_ROOT_NODE" />
            <Childs>
                <ContentObject contentClass="teamroom_box_folder" section="{$public_section_id}" remoteID="{$teamroom_parent_node}_teamrooms_boxes">
                    <Attributes>
                        <name>{'Boxes'|i18n( 'ezteamroom/install/teamroomcontent' )}</name>
                    </Attributes>
                    <SetReference attribute="object_id" value="TEAMROOM_BOXPOOL" />
                    <SetReference attribute="node_id" value="TEAMROOM_BOXPOOL_NODE" />
                    <Childs>
                        <ContentObject contentClass="teamroom_infobox" section="{$public_section_id}" remoteID="{$teamroom_parent_node}_teamrooms_box_mytlightbox">
                            <Attributes>
                                <header>{'Lightbox selection'|i18n( 'ezteamroom/install/teamroomcontent' )}</header>
                                <box_icon>internal:ICON_619</box_icon>
                                <content></content>
                                <url></url>
                                <module_url>ezjscore/run/lightbox/view/lightboxselection</module_url>
                                <check_access></check_access>
                            </Attributes>
                            <SetReference attribute="object_id" value="LIGHTBOXSELECTION_BOX_OBJECT" />
                        </ContentObject>
                        <ContentObject contentClass="teamroom_infobox" section="{$public_section_id}" remoteID="{$teamroom_parent_node}_teamrooms_box_myteamrooms">
                            <Attributes>
                                <header>{'My Teamrooms'|i18n( 'ezteamroom/install/teamroomcontent' )}</header>
                                <box_icon>internal:ICON_613</box_icon>
                                <content></content>
                                <url></url>
                                <check_access></check_access>
                                <module_url parseReferences="true">ezjscore/run/content/view/myteamrooms/[internal:TEAMROOM_ROOT_NODE]</module_url>
                            </Attributes>
                            <SetReference attribute="object_id" value="MYTEAMROOMS_BOX_OBJECT" />
                        </ContentObject>
{*
                        <ContentObject contentClass="teamroom_infobox" section="{$public_section_id}" remoteID="{$teamroom_parent_node}_teamrooms_box_help">
                            <Attributes>
                                <header>{'Help'|i18n( 'ezteamroom/install/teamroomcontent' )}</header>
                                <box_icon>internal:ICON_168</box_icon>
                                <content>{'Some help text'|i18n( 'ezteamroom/install/teamroomcontent' )}</content>
                                <url></url>
                                <module_url></module_url>
                                <check_access></check_access>
                            </Attributes>
                            <SetReference attribute="object_id" value="HELP_BOX_OBJECT" />
                        </ContentObject>
*}
                        <ContentObject contentClass="teamroom_infobox" section="{$public_section_id}" remoteID="{$teamroom_parent_node}_teamrooms_box_allteamrooms">
                            <Attributes>
                                <header>{'All Teamrooms'|i18n( 'ezteamroom/install/teamroomcontent' )}</header>
                                <box_icon>internal:ICON_224</box_icon>
                                <content>Teamrooms</content>
                                <url></url>
                                <module_url parseReferences="true">ezjscore/run/content/view/teamroomlist/[internal:TEAMROOM_ROOT_NODE]</module_url>
                                <check_access></check_access>
                            </Attributes>
                            <SetReference attribute="object_id" value="ALLTEAMROOMS_BOX_OBJECT" />
                        </ContentObject>
                        <ContentObject contentClass="teamroom_infobox" section="{$public_section_id}" remoteID="{$teamroom_parent_node}_createteamroom_box">
                            <Attributes>
                                <header>{'Create Teamroom'|i18n( 'ezteamroom/install/teamroomcontent' )}</header>
                                <box_icon>internal:ICON_226</box_icon>
                                <content>{'Add your teamroom and get all the things to manage your team.'|i18n( 'ezteamroom/install/teamroomcontent' )}</content>
                                <check_access>teamroom/create</check_access>
                            </Attributes>
                            <SetReference attribute="node_id" value="CREATETEAMROOM_BOX_ROOT_NODE" />
                            <SetReference attribute="object_id" value="CREATETEAMROOM_BOX_OBJECT" />
                        </ContentObject>
                        <ContentObject contentClass="teamroom_infobox" section="{$public_section_id}" remoteID="{$teamroom_parent_node}_createteamroom_box">
                            <Attributes>
                                <module_url parseReferences="true">ezjscore/run/content/view/createteamroom/[internal:CREATETEAMROOM_BOX_ROOT_NODE]</module_url>
                            </Attributes>
                        </ContentObject>
                        <ContentObject contentClass="teamroom_infobox" section="{$public_section_id}" remoteID="{$teamroom_parent_node}_teamrooms_box_lightboxes">
                            <Attributes>
                                <header>{'Lightboxes'|i18n( 'ezteamroom/install/teamroomcontent' )}</header>
                                <box_icon>internal:ICON_619</box_icon>
                                <content></content>
                                <url></url>
                                <module_url>ezjscore/run/lightbox/view/lightboxlist</module_url>
                                <check_access></check_access>
                            </Attributes>
                        </ContentObject>
                        <ContentObject contentClass="teamroom_infobox" section="{$public_section_id}" remoteID="{$teamroom_parent_node}_teamrooms_box_latestmessages">
                            <Attributes>
                                <header>{'Latest Messages'|i18n( 'ezteamroom/install/teamroomcontent' )}</header>
                                <box_icon>internal:ICON_620</box_icon>
                                <content></content>
                                <url></url>
                                <module_url parseReferences="true">ezjscore/run/content/view/latestmessages/[internal:TEAMROOM_ROOT_NODE]</module_url>
                                <check_access></check_access>
                            </Attributes>
                            <SetReference attribute="object_id" value="LATESTMESSAGES_BOX_OBJECT" />
                        </ContentObject>
                    </Childs>
                </ContentObject>
            </Childs>
        </ContentObject>
        <ContentObject contentClass="teamroom_personal_frontpage" section="{$public_section_id}" remoteID="{$teamroom_parent_node}_teamrooms">
            <Attributes>
                <default_arrangement parseReferences="true">[[[internal:CREATETEAMROOM_BOX_OBJECT],[internal:LIGHTBOXSELECTION_BOX_OBJECT]],[[internal:ALLTEAMROOMS_BOX_OBJECT]],[[internal:MYTEAMROOMS_BOX_OBJECT]],[[internal:LATESTMESSAGES_BOX_OBJECT]]]</default_arrangement>
            </Attributes>
        </ContentObject>
    </CreateContent>
    <ProccessInformation comment="Creating siteaccess" />
    <SetSettings>
      <SettingsFile name="site.ini" location="{$site_access_dir}">
        <SettingsBlock name="ContentSettings">
            <CachedViewModes>full;sitemap;pdf;module_widget;module_widget_latest;manage;teamrooms</CachedViewModes>
            <CachedViewPreferences>
              <value key="full">teamroom_files_list_limit=10;teamroom_folder_list_limit=10;teamroom_milestone_list_limit=10;teamroom_list_limit=10;teamroom_forum_list_limit=10;personalfrontpage_widgetlist_[internal:TEAMROOM_ROOT_NODE]=0;personalfrontpage_displaydescription=2;teamroom_blog_list_limit=10;teamroom_calendar_limit=10;teamroom_documents_list_limit=10;teamroom_tasklist_list_limit=10;teamroom_list_limit;teamroom_member_list_limit=10</value>
            </CachedViewPreferences>
        </SettingsBlock>
        <SettingsBlock name="Session">
            <RememberMeTimeout>259200</RememberMeTimeout>
        </SettingsBlock>
        <SettingsBlock name="SiteSettings">
            <IndexPage>/content/view/full/[internal:TEAMROOM_ROOT_NODE]</IndexPage>
            <DefaultPage>/content/view/full/[internal:TEAMROOM_ROOT_NODE]</DefaultPage>
            <SiteName>{'eZ Teamroom'|i18n( 'ezteamroom/install/sitename' )}</SiteName>
            <SiteURL>{$host_url}</SiteURL>
            <LoginPage>embedded</LoginPage>
        </SettingsBlock>
        <SettingsBlock name="RegionalSettings">
            <Locale>{$language}</Locale>
            <ContentObjectLocale>{$language}</ContentObjectLocale>
            <ShowUntranslatedObjects>disabled</ShowUntranslatedObjects>
            <SiteLanguageList>
              <value></value>
              <value>{$language}</value>
            </SiteLanguageList>
            <TextTranslation>{if $language|eq( 'eng-GB' )}disabled{else}enabled{/if}</TextTranslation>
        </SettingsBlock>
        <SettingsBlock name="SiteAccessSettings">
            <RequireUserLogin>true</RequireUserLogin>
            <ShowHiddenNodes>false</ShowHiddenNodes>
            <PathPrefix>Teamrooms</PathPrefix>
        </SettingsBlock>
        <SettingsBlock name="UserSettings">
            <DefaultUserPlacement>{$guest_group_node_id}</DefaultUserPlacement>
        </SettingsBlock>
      </SettingsFile>
      <SettingsFile name="event.ini" location="{$site_access_dir}">
        <SettingsBlock name="AttendeeSettings">
          <SearchRootNode>[internal:TEAMROOM_ROOT_NODE]</SearchRootNode>
          <ClassIdentifierFilter>teamroom_room</ClassIdentifierFilter>
        </SettingsBlock>
      </SettingsFile>
      <SettingsFile name="teamroom.ini" location="{$site_access_dir}">
        <SettingsBlock name="TeamroomSettings">
          <TeamroomPoolNodeID>[internal:TEAMROOM_ROOT_NODE]</TeamroomPoolNodeID>
        </SettingsBlock>
      </SettingsFile>
      <SettingsFile name="upload.ini" location="{$site_access_dir}">
        <SettingsBlock name="CreateSettings">
            <MimeClassMap>
              <value></value>
              <value key="image">image</value>
              <value key="video/quicktime">quicktime</value>
              <value key="video/x-msvideo">windows_media</value>
              <value key="video/vnd.rn-realvideo">real_video</value>
              <value key="application/vnd.rn-realmedia">real_video</value>
              <value key="application/x-shockwave-flash">flash</value>
            </MimeClassMap>
            <DefaultClass>teamroom_file</DefaultClass>
        </SettingsBlock>
        <SettingsBlock name="teamroom_file_ClassSettings">
            <FileAttribute>file</FileAttribute>
            <NameAttribute>name</NameAttribute>
            <NamePattern>&lt;original_filename_base&gt;</NamePattern>
        </SettingsBlock>
      </SettingsFile>
      <SettingsFile name="browse.ini" location="{$site_access_dir}">
        <SettingsBlock name="SelectLinkNodeID">
          <StartNode>[internal:TEAMROOM_ROOT_NODE]</StartNode>
        </SettingsBlock>
        <SettingsBlock name="SelectLinkObjectID">
          <StartNode>[internal:TEAMROOM_ROOT_NODE]</StartNode>
        </SettingsBlock>
        <SettingsBlock name="AddRelatedObjectToOE">
          <StartNode>[internal:TEAMROOM_ROOT_NODE]</StartNode>
        </SettingsBlock>
      </SettingsFile>
      <SettingsFile name="teamroom.ini" location="settings/override">
        <SettingsBlock name="TeamroomSettings">
          <TeamroomClassID>[internal:CLASS_TEAMROOM]</TeamroomClassID>
          <PrivateSectionID>[internal:SECTION_TEAMROOM]</PrivateSectionID>
          <PublicSectionID>[{$public_section_id}]</PublicSectionID>
          <VisibilityList>
           <value></value>
           <value>private</value>

    {if $use_internal|eq( 'yes' )}

           <value>internal</value>

    {/if}

           <value>protected</value>
           <value>public</value>
          </VisibilityList>
        </SettingsBlock>
        <SettingsBlock name="VisibilitySettings_private">
          <TeamroomSection>[internal:SECTION_TEAMROOM]</TeamroomSection>
          <SubTreeSection>[internal:SECTION_TEAMROOM]</SubTreeSection>
        </SettingsBlock>
        <SettingsBlock name="VisibilitySettings_public">
          <TeamroomSection>[{$public_section_id}]</TeamroomSection>
          <SubTreeSection>[{$public_section_id}]</SubTreeSection>
        </SettingsBlock>

    {if $use_internal|eq( 'yes' )}

        <SettingsBlock name="VisibilitySettings_internal">
          <TeamroomSection>[{$public_section_id}]</TeamroomSection>
          <SubTreeSection>[internal:SECTION_TEAMROOM]</SubTreeSection>
        </SettingsBlock>

    {/if}

        <SettingsBlock name="VisibilitySettings_protected">
          <TeamroomSection>[{$public_section_id}]</TeamroomSection>
          <SubTreeSection>[internal:SECTION_TEAMROOM]</SubTreeSection>
        </SettingsBlock>
        <SettingsBlock name="PermissionSettings">
          <TeamroomRoleList>
            <value>[internal:ROLE_3]</value>
            <value>[internal:ROLE_4]</value>
            <value>[internal:ROLE_5]</value>
            <value>[internal:ROLE_6]</value>
            <value>[internal:ROLE_7]</value>
            <value>[internal:ROLE_8]</value>
            <value>[internal:ROLE_9]</value>
            <value>[internal:ROLE_10]</value>
            <value>[internal:ROLE_11]</value>
            <value>[internal:ROLE_12]</value>
            <value>[internal:ROLE_13]</value>
            <value>[internal:ROLE_14]</value>
            <value>[internal:ROLE_15]</value>
            <value>[internal:ROLE_16]</value>
          </TeamroomRoleList>
          <TeamroomDefaultRoleList>
            <value>[internal:ROLE_3]</value>
            <value>[internal:ROLE_5]</value>
            <value>[internal:ROLE_7]</value>
            <value>[internal:ROLE_9]</value>
            <value>[internal:ROLE_11]</value>
            <value>[internal:ROLE_13]</value>
            <value>[internal:ROLE_15]</value>
          </TeamroomDefaultRoleList>
          <TeamroomMemberGroupRole>[internal:ROLE_1]</TeamroomMemberGroupRole>
          <TeamroomLeaderGroupRole>[internal:ROLE_2]</TeamroomLeaderGroupRole>
        </SettingsBlock>
        <SettingsBlock name="TeamroomIconSettings">
          <Icon003>[internal:ICON_003]</Icon003>
          <Icon168>[internal:ICON_168]</Icon168>
          <Icon170>[internal:ICON_170]</Icon170>
          <Icon224>[internal:ICON_224]</Icon224>
          <Icon226>[internal:ICON_226]</Icon226>
          <Icon613>[internal:ICON_613]</Icon613>
          <Icon618>[internal:ICON_618]</Icon618>
          <Icon619>[internal:ICON_619]</Icon619>
          <Icon620>[internal:ICON_620]</Icon620>
          <Icon673>[internal:ICON_673]</Icon673>
          <Icon674>[internal:ICON_674]</Icon674>
          <Icon675>[internal:ICON_675]</Icon675>
          <Icon676>[internal:ICON_676]</Icon676>
          <Icon677>[internal:ICON_677]</Icon677>
          <Icon678>[internal:ICON_678]</Icon678>
          <Icon679>[internal:ICON_679]</Icon679>
        </SettingsBlock>
      </SettingsFile>
    </SetSettings>
    <ProccessInformation comment="Activating siteaccess" />
    <SetSettings>
      <SettingsFile name="site.ini" location="settings/override">
        <SettingsBlock name="SiteAccessSettings">
            <AvailableSiteAccessList>
              <value>{$site_access_name}</value>
            </AvailableSiteAccessList>
            <URIMatchMapItems>
              <value>{$sa_abbr};{$site_access_name}</value>
            </URIMatchMapItems>
        </SettingsBlock>
        <SettingsBlock name="Session">
            <SessionNamePerSiteAccess value="enabled" />
        </SettingsBlock>
        <SettingsBlock name="SiteSettings">
            <SiteList>
              <value>{$site_access_name}</value>
            </SiteList>
        </SettingsBlock>
      </SettingsFile>
      <SettingsFile name="site.ini" location="{$admin_site_access_dir}">
        <SettingsBlock name="SiteAccessSettings">
            <RelatedSiteAccessList>
              <value>{$site_access_name}</value>
            </RelatedSiteAccessList>
        </SettingsBlock>
      </SettingsFile>
      <SettingsFile name="contentstructuremenu.ini" location="{$admin_site_access_dir}">
        <SettingsBlock name="TreeMenu">
            <ShowClasses>
              <value>teamroom_personal_frontpage</value>
              <value>teamroom_room</value>
              <value>teamroom_blog</value>
              <value>teamroom_box_folder</value>
              <value>teamroom_milestone_folder</value>
              <value>teamroom_task_list</value>
            </ShowClasses>
        </SettingsBlock>
      </SettingsFile>
    </SetSettings>
    <ProccessInformation comment="Creating workflows" />
    <CreateWorkflow>
      <WorkflowGroup name="Teamroom">
        <Workflow name="{'Create Teamroom'|i18n( 'ezteamroom/install/workflows' )}" workflowTypeString="group_ezserial" referenceID="WORKFLOW_CREATETEAMROOM">
          <Event description="Setup structure from XML" placement="1" workflowTypeString="event_ezxmlpublisher">
            <Data />
          </Event>
        </Workflow>
        <Workflow name="{'Approve Member Registration'|i18n( 'ezteamroom/install/workflows' )}" workflowTypeString="group_ezserial" referenceID="WORKFLOW_APPROVEMEMBERREGISTRATION">
          <Event description="Approve" placement="1" workflowTypeString="event_ezapprovememberregistration">
            <Data />
          </Event>
        </Workflow>
        <Workflow name="{'Set Teamroom Section'|i18n( 'ezteamroom/install/workflows' )}" workflowTypeString="group_ezserial" referenceID="WORKFLOW_SETSECTION">
          <Event description="Set Section" placement="1" workflowTypeString="event_ezsetsection">
            <Data />
          </Event>
        </Workflow>
        <Workflow name="{'Set Current Teamroom'|i18n( 'ezteamroom/install/workflows' )}" workflowTypeString="group_ezserial" referenceID="WORKFLOW_SETCURRENTTEAMROOM">
          <Event description="Set Section" placement="1" workflowTypeString="event_ezsetteamroom">
            <Data />
          </Event>
        </Workflow>
        <Workflow name="{'Post Publish Multiplexer'|i18n( 'ezteamroom/install/workflows' )}" workflowTypeString="group_ezserial" referenceID="WORKFLOW_POSTPUBLISH">
          <Event description="Class: Teamroom" placement="1" workflowTypeString="event_ezmultiplexer">
            <Data>
              <data_int1>[internal:WORKFLOW_CREATETEAMROOM]</data_int1>
              <data_text1>-1</data_text1>
              <data_text3>[internal:CLASS_TEAMROOM]</data_text3>
            </Data>
          </Event>
          <Event description="Class: Teamroom" placement="2" workflowTypeString="event_ezmultiplexer">
            <Data>
              <data_int1>[internal:WORKFLOW_SETSECTION]</data_int1>
              <data_text1>-1</data_text1>
              <data_text3>[internal:CLASS_TEAMROOM]</data_text3>
            </Data>
          </Event>
        </Workflow>
        <Workflow name="{'Set Teamroom Membership'|i18n( 'ezteamroom/install/workflows' )}" workflowTypeString="group_ezserial" referenceID="WORKFLOW_TEAMROOM">
          <Event description="Membership" placement="1" workflowTypeString="event_ezmultiplexer">
            <Data>
              <data_int1>[internal:WORKFLOW_SETCURRENTTEAMROOM]</data_int1>
              <data_text1>[internal:SECTION_TEAMROOM],[{$public_section_id}],1</data_text1>
              <data_text2>12,42</data_text2>
              <data_text3>-1</data_text3>
            </Data>
          </Event>
        </Workflow>
      </WorkflowGroup>
      <Trigger module="content" operation="publish" connectType="after" workflowID="internal:WORKFLOW_POSTPUBLISH" />
      <Trigger module="teamroom" operation="register" connectType="before" workflowID="internal:WORKFLOW_APPROVEMEMBERREGISTRATION" />
    </CreateWorkflow>
    <ProccessInformation comment="Assigning roles" />
    <AssignRoles>
        <RoleAssignment roleID="internal:ROLE_USETEAMROOM"     assignTo="{$guest_group_id}" />
        <RoleAssignment roleID="internal:ROLE_USELIGHTBOX"     assignTo="{$guest_group_id}" />
    </AssignRoles>
</eZXMLImporter>
{/set-block}