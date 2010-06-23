{default attribute_parameters=array()}

    {if $object.main_node_id|null()|not()}

        {def $aliasArray = $object.main_node.url_alias|explode( '/' )
             $aliasCount = $aliasArray|count()}

<a href="{$aliasArray|remove( $aliasCount|dec(), 1 )|implode( '/' )|ezurl( 'no' )}#{$aliasArray|remove( 0, $aliasCount|dec() )|implode( '/' )}">{$object.name|wash()}</a>

        {undef $aliasArray $aliasCount}

    {else}

        {$object.name|wash()}

    {/if}

{/default}
