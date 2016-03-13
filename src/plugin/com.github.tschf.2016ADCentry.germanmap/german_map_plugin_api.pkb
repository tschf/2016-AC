create or replace PACKAGE BODY GERMAN_MAP_PLUGIN_API AS

    type rt_rgb_colour is record(
        red NUMBER,
        green NUMBER,
        blue NUMBER
    );


    function get_current_population_year
    return v_germany_population.year%type
    as
        l_year v_germany_population.year%type;
    begin
        select max(year)
        into l_year
        from v_germany_population;

        return l_year;
    end get_current_population_year;

    function get_colour_as_rgb(
        p_colour_code in varchar2
    )
    return rt_rgb_colour
    as
        l_return_colour rt_rgb_colour;

        l_red varchar2(2);
        l_green varchar2(2);
        l_blue varchar2(2);

        lc_red_idx constant number := 1;
        lc_green_idx constant number := 3;
        lc_blue_idx constant number := 5;

        lc_hex_len constant number := 2;

        l_hex_colour varchar2(7);
    begin
        l_hex_colour := p_colour_code;
        if substr(l_hex_colour, 1, 1) = '#'
        then
            l_hex_colour := substr(l_hex_colour, 2);
        end if;

        l_red := substr(l_hex_colour, lc_red_idx, lc_hex_len);
        l_green := substr(l_hex_colour, lc_green_idx, lc_hex_len);
        l_blue := substr(l_hex_colour, lc_blue_idx, lc_hex_len);

        l_return_colour.red := to_number(l_red, 'xx');
        l_return_colour.green := to_number(l_green, 'xx');
        l_return_colour.blue := to_number(l_blue, 'xx');

        return l_return_colour;
    end;

    function get_timeline_dom
    return varchar2
    as
        l_timeline varchar2(4000);
        l_current_year v_germany_population.year%type;
    begin

        l_current_year := get_current_population_year();

        l_timeline := '<h4>Time period:</h4><ul id="timeline">';

        for population_year in (
            select distinct year
            from v_Germany_population
            where year between (l_current_year-4) and l_current_year
            order by year asc
        )
        loop
            if l_current_year = population_year.year
            then
                l_timeline :=
                    l_timeline
                    || '<li class="active"><a href="#">'
                    || population_year.year
                    || '</a></li>'
                    || chr(13) || chr(10);
            else
                l_timeline :=
                    l_timeline
                    || '<li><a href="#">'
                    || population_year.year
                    || '</a></li>'
                    || chr(13) || chr(10);
            end if;


        end loop;

        l_timeline := l_timeline || '</ul>';

        return l_timeline;

    end get_timeline_dom;

    procedure output_map_dom
    as
        l_base_dom varchar2(4000);
        l_timeline_dom varchar2(4000);
    begin
        l_base_dom := q'!
<div id="mapContainer">
    #timeline#
    <svg id="germanMap"></svg>
    <div id="legend">
        <h4>Population legend</h4>
        <div id="colourGrid" class="flexBox">
            <div class="area heat10"></div>
            <div class="area heat20"></div>
            <div class="area heat30"></div>
            <div class="area heat40"></div>
            <div class="area heat50"></div>
            <div class="area heat60"></div>
            <div class="area heat70"></div>
            <div class="area heat80"></div>
            <div class="area heat90"></div>
            <div class="area heat100"></div>
        </div>
    <div>
        <span>Min</span>
        <span class="rightAligned">Max</span>
    </div>

</div>
</div>
!';

        l_timeline_dom := get_timeline_dom;
        l_base_dom := replace(l_base_dom, '#timeline#', l_timeline_dom);

        htp.p(l_base_dom);

    end;

    procedure output_static_style
    as
    begin

        htp.p(q'!
<style type="text/css">
#mapContainer {
    text-align: center;
    width: 960px;
    margin: 0 auto;
}

svg {

    stroke: white;
    stroke-width: 0.2px;
}

.bold { font-weight: bold; }

#legend {
  width: 200px;
  height: 25px;
  text-align: left;
  margin-left: auto;
  margin-right: 0;
}

.flexBox {
    display: flex;
}

.area {
    width: 20px;
    height:23px;
}

.ui-tooltip {
    white-space: pre-line;
}
.rightAligned {

    float: right;
}

.heat10 { background-color: rgba(177, 23, 23, 0.1); }
.heat20 { background-color: rgba(177, 23, 23, 0.2); }
.heat30 { background-color: rgba(177, 23, 23, 0.3); }
.heat40 { background-color: rgba(177, 23, 23, 0.4); }
.heat50 { background-color: rgba(177, 23, 23, 0.5); }
.heat60 { background-color: rgba(177, 23, 23, 0.6); }
.heat70 { background-color: rgba(177, 23, 23, 0.7); }
.heat80 { background-color: rgba(177, 23, 23, 0.8); }
.heat90 { background-color: rgba(177, 23, 23, 0.9); }
.heat100 { background-color: rgba(177, 23, 23, 1); }
</style>
        !');

    end;


    /*
        Render the initial state styles as an in-line stylesheet.
        So that when the map initially loads, it has the current year styles applied
        without noticing the transition between default colour and the desired.
    */
    procedure heat_map_css(
        p_colour_config in rt_rgb_colour
    )
    as

        l_initial_year v_germany_population.year%type;
        l_rule_template varchar2(4000);
        l_row_style varchar2(4000);
    begin

        l_initial_year := get_current_population_year();
        l_rule_template := q'! { fill: rgba(#R#,#G#,#B#,#A#); } !';

        htp.p('<style type="text/css">');
        htp.p('/* Initial colour application of states for the year ' || l_initial_year || '*/');

        for i in (
            with population_data as (
                select population, fed_state_map.adm1_code, max(population) over (order by 1) max_pop
                from gdb_ger_fs_population
                join fed_state_map on (fed_state_map.state_name = gdb_ger_fs_population.federal_state)
                where year = l_initial_year
                order by population desc
            )
            select population_data.adm1_code, round(1-(max_pop-population)/max_pop,2) pct_of_max
            from population_data
        )
        loop
            l_row_style := l_rule_template;

            l_row_style := replace(l_row_style, '#R#', p_colour_config.red);
            l_row_style := replace(l_row_style, '#G#', p_colour_config.green);
            l_row_style := replace(l_row_style, '#B#', p_colour_config.blue);
            l_row_style := replace(l_row_style, '#A#', i.pct_of_max);

            htp.p('.' || i.adm1_code || l_row_style);

            --htp.p('.' || i.adm1_code || ' { fill: rgba(177,23,23,' || i.pct_of_max || '); }');
        end loop;


        htp.p('</style>');

    end;

    function render_me(
        p_region              in apex_plugin.t_region,
        p_plugin              in apex_plugin.t_plugin,
        p_is_printer_friendly in boolean
    )
    return apex_plugin.t_region_render_result
    AS
        l_render_result apex_plugin.t_region_render_result;

        l_onLoad_jsCode varchar2(32767);

        l_colour_code p_region.attribute_01%type;
        l_map_width p_region.attribute_02%type;
        l_map_height p_region.attribute_03%type;

        l_rgb_colour rt_rgb_colour;
        l_initial_year v_germany_population.year%type;
    BEGIN

        l_colour_code := p_region.attribute_01;
        l_map_width := p_region.attribute_02;
        l_map_height := p_region.attribute_03;


        l_rgb_colour := get_colour_as_rgb(l_colour_code);
        l_initial_year := get_current_population_year();

        --output_static_style;
        heat_map_css(l_rgb_colour);
        output_map_dom;

        htp.p(p_plugin.file_prefix);

        apex_javascript.add_onload_code(
            p_code =>
                l_onload_jscode
                || 'germanMapRenderer.setUpMap('
                || l_map_width
                || ','
                || l_map_height
                || ',"'
                || p_plugin.file_prefix
                || '","'
                || apex_plugin.get_ajax_identifier
                ||'",'
                || l_initial_year
                || ','
                || l_rgb_colour.red
                || ','
                || l_rgb_colour.green
                || ','
                || l_rgb_colour.blue
                ||');'

                || chr(13)||chr(10)


                || 'germanMapRenderer.registerChangeTime("'
                || apex_plugin.get_ajax_identifier
                || '",'
                || l_rgb_colour.red
                || ','
                || l_rgb_colour.green
                || ','
                || l_rgb_colour.blue
                || ');'

          , p_key => NULL
        );

        RETURN l_render_result;
    END render_me;

    function get_state_pcts_of_pop_max_json (
        p_region in apex_plugin.t_region,
        p_plugin in apex_plugin.t_plugin
    )
    return apex_plugin.t_region_ajax_result
    as
        l_reg_ajax_result apex_plugin.t_region_ajax_result;
        l_year_pcts ct_state_pop_perc;
        l_adm1_code fed_state_map.adm1_code%type;--store key of l_year_pcts
        l_year NUMBER := apex_application.g_x01;
    begin



        l_year_pcts := get_state_pop_info(l_year);

        l_adm1_code := l_year_pcts.FIRST;

        --if for some reason there is not data returned in the collection
        --don't attempt to write the json object out
        if l_adm1_code is not null
        then
            apex_json.open_object;

            loop
                apex_json.open_object(l_adm1_code);

                apex_json.write('pctOfMax', l_year_pcts(l_adm1_code).pct_of_max);
                apex_json.write('stateName', l_year_pcts(l_adm1_code).state_name);
                apex_json.write('totalPopulation', l_year_pcts(l_adm1_code).population_count);

                apex_json.close_object;


                --apex_json.write(l_adm1_code, l_year_pcts(l_adm1_code).pct_of_max);
                l_adm1_code := l_year_pcts.next(l_adm1_code);
                exit when l_adm1_code is null;
            end loop;

            apex_json.close_object;
        end if;

        return l_reg_ajax_result;

    end get_state_pcts_of_pop_max_json;


    /*

        Return all the state population values as a percentage (decimal) of the
        max population for any given year. This is used for the opacity level
        of the maps heat map of population density per state (in an rgba colour
        value).

        Return an associative array indexed by ADM1_CODE.

    */
    function get_state_pop_info(
        p_year in v_germany_population.year%type
    )
    return ct_state_pop_perc
    as

        type lt_state_info is record (
            adm1_code v_germany_population.adm1_code%type,
            pct_of_max NUMBER,
            population_count v_germany_population.population%type,
            state_name v_germany_population.federal_state%type
        );

        type lt_state_fractions_of_tot is table of lt_state_info
            index by PLS_INTEGER;

        l_year_statePopInfo_intIdx lt_state_fractions_of_tot;

        l_year_statePopInfo_adm1Idx ct_state_pop_perc;

        l_state_info rt_state_pop_info;
    begin

        with population_data as (
            select
                year,
                adm1_code,
                federal_State,
                population,
                max(population) over (order by 1) max_pop
            from v_germany_population
            where year = p_year
            order by population desc
        )
        select
            adm1_code,
            round(1-(max_pop-population)/max_pop,2) pct_of_max,
            population,
            federal_State
        bulk collect into l_year_statePopInfo_intIdx
        from
            population_data;

        for state_idx in 1..l_year_statePopInfo_intIdx.COUNT
        loop

            l_state_info.pct_of_max := l_year_statePopInfo_intIdx(state_idx).pct_of_max;
            l_state_info.population_count := l_year_statePopInfo_intIdx(state_idx).population_count;
            l_state_info.state_name := l_year_statePopInfo_intIdx(state_idx).state_name;


            l_year_statePopInfo_adm1Idx(l_year_statePopInfo_intIdx(state_idx).adm1_code) := l_state_info;

        end loop;


        return l_year_statePopInfo_adm1Idx;
    end get_state_pop_info;

END GERMAN_MAP_PLUGIN_API;
