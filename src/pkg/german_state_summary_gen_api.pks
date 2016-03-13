create or replace package german_state_summary_gen_api
as

    --Helper for getting the ranking with an ordinal (1'st', 2'nd', etc)
    function num_ordinal(p_num in number)
    return varchar2;

    function get_sentence(
        p_adm1_code in fed_state_map.adm1_code%type
    )
    return varchar2;

end german_state_summary_gen_api;
