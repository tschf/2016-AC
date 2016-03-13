create or replace PACKAGE GERMAN_MAP_PLUGIN_API AS

    type rt_state_pop_info is record (
        pct_of_max NUMBER,
        population_count v_germany_population.population%type,
        state_name v_germany_population.federal_state%type
    );

    type ct_state_pop_perc is table of rt_state_pop_info
        index by fed_state_map.adm1_code%type;

    function render_me(
        p_region              in apex_plugin.t_region,
        p_plugin              in apex_plugin.t_plugin,
        p_is_printer_friendly in boolean
    )
    return apex_plugin.t_region_render_result;

    function get_state_pcts_of_pop_max_json (
        p_region in apex_plugin.t_region,
        p_plugin in apex_plugin.t_plugin
    )
    return apex_plugin.t_region_ajax_result;

    function get_state_pop_info(
        p_year in v_germany_population.year%type
    )
    return ct_state_pop_perc;

    function get_current_population_year
    return v_germany_population.year%type;

END GERMAN_MAP_PLUGIN_API;
