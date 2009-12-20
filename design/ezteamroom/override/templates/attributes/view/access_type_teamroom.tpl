{if is_set( $view_type )|not()}

    {def $view_type = 'normal'}

{/if}

{def         $access_type = $attribute.content.0
         $visibility_list = ezini( "TeamroomSettings", "VisibilityList", "teamroom.ini" )
               $css_class = ''
     $configuration_block = ''
         $visibility_name = ''
              $icon_title = 'icon'}

{if $view_type|eq( 'simple' )}

    {set $visibility_name = ezini( concat( "VisibilitySettings_", $access_type ), "Title", "teamroom.ini" )}

    {$visibility_name|wash()}

{else}

    {foreach $visibility_list as $visibility}

        {set $configuration_block = concat( "VisibilitySettings_", $visibility )}

        {if ezini_hasvariable( $configuration_block, "CSSClass", "teamroom.ini" )}

            {if $visibility|eq( $access_type )}

                {set $css_class = concat( ezini( $configuration_block, "CSSClass", "teamroom.ini" ), '_active' )}

            {else}

                {set $css_class = ezini( $configuration_block, "CSSClass", "teamroom.ini" )}

            {/if}

        {else}

            {set $css_class = ''}

        {/if}

        {set      $icon_title = ezini( $configuration_block, "IconTitle", "teamroom.ini" )
             $visibility_name = ezini( $configuration_block, "Title", "teamroom.ini" )}

        <div class="image{if $visibility|eq($access_type)} selected{/if}">
         <div class="access_type_image{if $css_class|ne( '' )} {$css_class}{/if}"{if $visibility|eq($access_type)} title="{$icon_title|wash()}"{/if}></div>

        {$visibility_name|wash()}

        </div>

    {/foreach}

{/if}

{undef $access_type $visibility_list $css_class $configuration_block $visibility_name $icon_title}
