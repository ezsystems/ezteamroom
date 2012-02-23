{if fetch( 'user', 'has_access_to', hash( 'module', 'teamroom', 'function', 'register' ) )}

<script type="text/javascript">
menuArray['ContextMenu']['elements']['menu-teamroom'] = new Array();
menuArray['ContextMenu']['elements']['menu-teamroom']['url'] = {"/teamroom/register/%objectID%"|ezurl};
</script>
<hr/>
<a id="menu-teamroom" href="#" onmouseover="ezpopmenu_mouseOver( 'ContextMenu' );">{"Membership"|i18n("ezteamroom/teamroom")}</a>

{/if}