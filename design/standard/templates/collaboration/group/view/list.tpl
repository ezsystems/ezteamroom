<div class="border-box">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>



    <div class="border-ml">
      <div class="border-mr">
        <div class="border-mc float-break">

            {def $frontpagestyle='noleftcolumn rightcolumn'}
            <div class="content-view-full">
                <div class="class-user_group {$frontpagestyle}">

                <div class="attribute-header">
                    <h1>{"User profile"|i18n("ezteamroom/membership")}</h1>
                </div>

                <div class="columns-frontpage float-break">
                    <div class="center-column-position">
                        <div class="user-edit">






















<div class="summary">
<div class="box_background">
{default parent_group_id=0
         current_depth=0
         offset=$view_parameters.offset item_limit=10
         summary_indentation=10}
<h1 class="context-title">{"Group list for '%1'"|i18n('ezteamroom/collaboration',,array($collab_group.title|wash))}</h1>

{let  group_item_count=fetch("collaboration","item_count",hash("parent_group_id",$collab_group.id))
      group_item_list=fetch("collaboration","item_list",hash("limit",$item_limit,"offset",$offset,"parent_group_id",$collab_group.id))}

<table width="100%" cellspacing="6" cellpadding="0" border="0">
<tr>
  <td valign="top">

{section show=$group_item_count}

{include uri="design:collaboration/item_list.tpl" item_list=$group_item_list}

{include name=Navigator
         uri='design:navigator/google.tpl'
         page_uri=concat("/collaboration/group/list/",$collab_group.id)
         item_count=$group_item_count
         view_parameters=$view_parameters
         item_limit=$item_limit}

{section-else}
<p>{"No items in group."|i18n('ezteamroom/collaboration')}</p>
{/section}

  </td>

  <td valign="top" align="left" width="1">

  {include uri="design:collaboration/group_tree.tpl" current_depth=$current_depth
           summary_indentation=$summary_indentation parent_group_id=$parent_group_id}

  </td>
</tr>

</table>

{/let}
{/default}
</div>
</div>


















                        </div>

                    </div>

                    <div class="right-column-position">
                        <div class="right-column">

{include uri='design:user/edit_menu.tpl' add_form = true()}

                        </div>
                    </div>

              </div>
            </div>
          </div>

        </div>
      </div>
    </div>



    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
