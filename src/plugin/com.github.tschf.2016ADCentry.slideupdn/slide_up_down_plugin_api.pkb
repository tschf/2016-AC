create or replace package body slide_up_down_plugin_api
as

    function render_me (
        p_dynamic_action in apex_plugin.t_dynamic_action,
        p_plugin         in apex_plugin.t_plugin
    )
    return apex_plugin.t_dynamic_action_render_result
    as

        l_da_render_result apex_plugin.t_dynamic_action_render_result;

        l_slideUp_selector p_dynamic_action.attribute_01%type;
        l_slideDown_selector p_dynamic_action.attribute_02%type;

    begin

        l_slideUp_selector := p_dynamic_action.attribute_01;
        l_slideDown_selector := p_dynamic_action.attribute_02;

        l_da_render_result.javascript_function := q'!

        function(){
            slideupdown.slideUp('#slideUpSelector#', function(){slideupdown.slideDown('#slideDownSelector#')});
        }

        !';

        l_da_render_result.javascript_function :=
            replace(
                l_da_render_result.javascript_function
              , '#slideUpSelector#'
              , l_slideUp_selector
            );

        l_da_render_result.javascript_function :=
            replace(
                l_da_render_result.javascript_function
              , '#slideDownSelector#'
              , l_slideDown_selector
            );


        return l_da_render_result;
    end render_me;

end slide_up_down_plugin_api;
