{set $tpl_info = hash(
        'language',             hash(   'info',     'Language which eZ teamroom is installed in.',
                                        'type',     'string',
                                        'default',  'eng-GB'
                                    )
)}
{set-block variable='xml_data'}
<eZXMLImporter>
  <ProccessInformation comment="Creating classes" />
  <CreateClass>
    <ContentClass isContainer="true" identifier="teamroom_wiki" remoteID="" objectNamePattern="&lt;title&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_WIKI">
      <Names {$language}="{"Teamroom wiki"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
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
      </Attributes>
    </ContentClass>
    <ContentClass isContainer="false" identifier="teamroom_wiki_page" remoteID="" objectNamePattern="&lt;title&gt;" urlAliasPattern="" classExistAction="extend" referenceID="CLASS_WIKI_PAGE">
      <Names {$language}="{"Teamroom wiki page"|i18n( 'ezteamroom/install/classes' )}" always-available="{$language}"/>
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
      </Attributes>
    </ContentClass>
  </CreateClass>
</eZXMLImporter>
{/set-block}
