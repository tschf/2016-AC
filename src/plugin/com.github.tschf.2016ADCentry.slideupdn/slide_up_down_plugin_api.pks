create or replace package slide_up_down_plugin_api
as

    function render_me (
        p_dynamic_action in apex_plugin.t_dynamic_action,
        p_plugin         in apex_plugin.t_plugin
    )
    return apex_plugin.t_dynamic_action_render_result;

end slide_up_down_plugin_api;
