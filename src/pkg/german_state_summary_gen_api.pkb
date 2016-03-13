create or replace package body german_state_summary_gen_api
as

    function num_ordinal(p_num in number)
    return varchar2
    as
        l_mod10 NUMBER;
        l_mod100 NUMBER;

        l_number_ordinal varchar2(2);
    begin
        l_mod10 := mod(p_num, 10);
        l_mod100 := mod(p_num, 100);

        if l_mod10 = 1 and l_mod100 != 11
        then
            l_number_ordinal := 'st';
        elsif l_mod10 = 2 and l_mod100 != 12
        then
            l_number_ordinal := 'nd';
        elsif l_mod10 = 3 and l_mod100 != 13
        then
            l_number_ordinal := 'rd';
        else
            l_number_ordinal := 'th';
        end if;

        return p_num || l_number_ordinal;

    end num_ordinal;

    function get_state_name(
        p_adm1_code in fed_state_map.adm1_code%type
    )
    return fed_state_map.state_name%type
    as
        l_state_name fed_state_map.state_name%type;
    begin

        select state_name
        into l_state_name
        from fed_state_map
        where adm1_code = p_adm1_code
        and preferred_spelling = 'Y';

        return l_state_name;
    exception
    when no_data_found
    then
        raise_application_error(
            -20000,
            'No state with adm1_code "' || p_adm1_code || '" could be found'
        );
    end get_state_name;

    function get_state_population(
        p_adm1_code in fed_state_map.adm1_code%type
    )
    return v_Germany_population.population%type
    as

        l_population_count v_Germany_population.population%type;

    begin

        select population
        into l_population_count
        from v_germany_population
        where adm1_code = p_adm1_code
        and year = 2014;

        return l_population_count;

    end get_state_population;

    function get_population_ranking(
        p_adm1_code in fed_state_map.adm1_code%type
    )
    return varchar2
    as
        l_ranking_str varchar2(20);

        lc_most constant number := -1;
        lc_least constant number := -2;
    begin

        with analy_data as (
            select year, federal_State, population, adm1_code,
            dense_rank() over (order by population desc) low_to_high_rank,
            dense_rank() over (order by population asc) high_to_low_rank,
            count(1) over (order by 1) total_States
            from v_germany_population
            where year = 2014
            order by population
        )
        select
            case
                when low_to_high_rank/total_states = 1 then 'least'
                when high_to_low_rank/total_states = 1 then 'most'
                when low_to_high_rank/total_states > 0.5 then num_ordinal(high_to_low_rank) || ' least'
                else num_ordinal(low_to_high_rank) || ' most' end
        into l_ranking_str
        from analy_data
        where adm1_code = p_adm1_code;

        return l_ranking_str;

    end get_population_ranking;

    function get_sentence(
        p_adm1_code in fed_state_map.adm1_code%type
    )
    return varchar2
    as
        l_state_name fed_state_map.state_name%type;
        l_population_count v_Germany_population.population%type;
        l_population_count_str varchar2(20);

        l_population_rank_str varchar2(20);

    begin

        l_State_name := get_state_name(p_adm1_code);
        l_population_count := get_state_population(p_adm1_code);
        l_population_count_str := to_char(l_population_count, 'FM999G999G999G999');
        l_population_rank_str := get_population_ranking(p_adm1_code);

        return
            l_State_name
                || ' has a population of '
                || l_population_count_str
                || '. This makes it the '
                || l_population_rank_str
                || ' populated state in Germany.';
    end get_sentence;

end german_state_summary_gen_api;
