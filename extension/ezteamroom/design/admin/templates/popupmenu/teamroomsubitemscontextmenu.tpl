{if fetch( 'user', 'has_access_to', hash( 'module', 'teamroom', 'function', 'register' ) )}

<script type="text/javascript">
menuArray['SubitemsContextMenu']['elements']['child-menu-teamroom'] = new Array();
menuArray['SubitemsContextMenu']['elements']['child-menu-teamroom']['url'] = {"/teamroom/register/%objectID%"|ezurl};
</script>
<hr/>
<a id="child-menu-teamroom" href="#" onmouseover="ezpopmenu_mouseOver( 'SubitemsContextMenu' );">{"Membership"|i18n("ezteamroom/teamroom")}</a>

{/if}