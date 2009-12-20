{def $prio=0}
{if and(is_set($attribute.content.0),$attribute.content.0|ne(''))}
{set $prio=$attribute.content.0}
{/if}

<img src={concat('images/state/',$prio,'.png')|ezdesign} alt="state_icon" />