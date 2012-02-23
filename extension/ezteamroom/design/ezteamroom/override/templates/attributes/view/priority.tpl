{switch match=$attribute.data_int}
    {case match=5}
        {'low'|i18n('ezteamroom/tasks')}
    {/case}
    {case match=4}
        {'tepid'|i18n('ezteamroom/tasks')}
    {/case}
    {case match=3}
        {'normal'|i18n('ezteamroom/tasks')}
    {/case}
    {case match=2}
        {'medium'|i18n('ezteamroom/tasks')}
    {/case}
    {case match=1}
        {'high'|i18n('ezteamroom/tasks')}
    {/case}
    {case}
    {/case}
{/switch}
