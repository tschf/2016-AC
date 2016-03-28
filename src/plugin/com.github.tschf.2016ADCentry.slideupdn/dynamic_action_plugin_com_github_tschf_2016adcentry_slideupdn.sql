set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.3.00.03'
,p_default_workspace_id=>1894194404629990
,p_default_application_id=>103
,p_default_owner=>'DASH_COMP'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_github_tschf_2016adcentry_slideupdn
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(2382958203255117)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.GITHUB.TSCHF.2016ADCENTRY.SLIDEUPDN'
,p_display_name=>'Slide up/Slide down'
,p_category=>'EFFECT'
,p_supported_ui_types=>'DESKTOP'
,p_javascript_file_urls=>'#PLUGIN_FILES#slideupdown.js'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'function render_me2 (',
'    p_dynamic_action in apex_plugin.t_dynamic_action,',
'    p_plugin         in apex_plugin.t_plugin ',
')',
'return apex_plugin.t_dynamic_action_render_result',
'as',
'',
'    l_da_render_result apex_plugin.t_dynamic_action_render_result;',
'',
'    l_slideUp_selector p_dynamic_action.attribute_01%type;',
'    l_slideDown_selector p_dynamic_action.attribute_02%type;',
'    l_slideDuration p_dynamic_action.attribute_03%type;',
'',
'begin',
'',
'    l_slideUp_selector := p_dynamic_action.attribute_01;',
'    l_slideDown_selector := p_dynamic_action.attribute_02;',
'    l_slideDuration := p_dynamic_action.attribute_03;',
'',
'    l_da_render_result.javascript_function := q''!',
'',
'    function(){',
'        slideupdown.slideUp(''#slideUpSelector#'', #duration#, function(){slideupdown.slideDown(''#slideDownSelector#'', #duration#);});',
'    }',
'',
'    !'';',
'',
'    l_da_render_result.javascript_function := ',
'        replace(',
'            l_da_render_result.javascript_function',
'          , ''#slideUpSelector#''',
'          , l_slideUp_selector',
'        );',
'',
'    l_da_render_result.javascript_function := ',
'        replace(',
'            l_da_render_result.javascript_function',
'          , ''#slideDownSelector#''',
'          , l_slideDown_selector',
'        );',
'        ',
'    l_da_render_result.javascript_function := ',
'        replace(',
'            l_da_render_result.javascript_function',
'          , ''#duration#''',
'          , to_number(l_slideDuration)',
'        );',
'',
'',
'    return l_da_render_result;',
'end render_me2;'))
,p_render_function=>'render_me2'
,p_standard_attributes=>'REQUIRED'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_files_version=>12
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2383132900275524)
,p_plugin_id=>wwv_flow_api.id(2382958203255117)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'jQuery selector to slide up'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2383438843277483)
,p_plugin_id=>wwv_flow_api.id(2382958203255117)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'jQuery selector to slide down'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2389708092607183)
,p_plugin_id=>wwv_flow_api.id(2382958203255117)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Slide duration'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'800'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_help_text=>'As from the jQuery documentation, "A string or number determining how long the animation will run.". This relates to the config "duration". Read more at the jQuery documentation here: http://api.jquery.com/slideup/'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '76617220736C6964657570646F776E203D207B0A0A20202020736C69646555703A2066756E6374696F6E20736C696465557028757053656C6563746F722C206475726174696F6E2C20636F6D706C65746543616C6C6261636B29207B0A20202020202020';
wwv_flow_api.g_varchar2_table(2) := '202428757053656C6563746F72292E736C6964655570287B0A2020202020202020202020206475726174696F6E3A206475726174696F6E2C0A202020202020202020202020636F6D706C6574653A20636F6D706C65746543616C6C6261636B0A20202020';
wwv_flow_api.g_varchar2_table(3) := '202020207D293B0A202020207D2C0A0A20202020736C696465446F776E3A2066756E6374696F6E20736C696465446F776E28646F776E53656C6563746F722C206475726174696F6E297B0A20202020202020202428646F776E53656C6563746F72292E73';
wwv_flow_api.g_varchar2_table(4) := '6C696465446F776E287B0A2020202020202020202020206475726174696F6E3A206475726174696F6E0A20202020202020207D293B0A202020207D0A0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(2385388331401491)
,p_plugin_id=>wwv_flow_api.id(2382958203255117)
,p_file_name=>'slideupdown.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
