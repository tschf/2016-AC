create table fed_state_map(
    CODE VARCHAR2(8) PRIMARY KEY,
    STATE_NAME VARCHAR2(30) NOT NULL
);
/

insert into fed_state_map values ('DEU-1573', 'BadenWürttemberg');
insert into fed_state_map values ('DEU-1591', 'Bayern');
insert into fed_state_map values ('DEU-1599', 'Berlin');
insert into fed_state_map values ('DEU-3487', 'Brandenburg');
insert into fed_state_map values ('DEU-1575', 'Bremen');
insert into fed_state_map values ('DEU-1578', 'Hamburg');
insert into fed_state_map values ('DEU-1574', 'Hessen');
insert into fed_state_map values ('DEU-3488', 'MecklenburgVorpommern');
insert into fed_state_map values ('DEU-1576', 'Niedersachsen');
insert into fed_state_map values ('DEU-1572', 'NordrheinWestfalen');
insert into fed_state_map values ('DEU-1580', 'RheinlandPfalz');
insert into fed_state_map values ('DEU-1581', 'Saarland');
insert into fed_state_map values ('DEU-1600', 'SachsenAnhalt');
insert into fed_state_map values ('DEU-1601', 'Sachsen');
insert into fed_state_map values ('DEU-1579', 'SchleswigHolstein');
insert into fed_state_map values ('DEU-1577', 'Thüringen');
/

create or replace view v_eu_populations as
select
    country
  , year
  , population
from gdb_world_population
where country in (
    'Österreich',
    'Belgien',
    'Bulgarien',
    'Deutschland',
    'Kroatien',
    'Zypern',
    'Tschechische Republik',
    'Dänemark',
    'Estland',
    'Finnland',
    'Frankreich',
    'Deutschland',
    'Ungarn',
    'Irland',
    'Italien',
    'Lettland',
    'Litauen',
    'Luxemburg',
    'Malta',
    'Niederlande',
    'Polen',
    'Portugal',
    'Rumänien',
    'Slowakei',
    'Slowenien',
    'Spanien',
    'Schweden',
    'Vereinigtes Königreich'
);
/

create or replace view v_bordering_population as
select country, year, population
from gdb_world_population
where country in
(
    'Belgien',
    'Niederlande',
    'Dänemark',
    'Polen',
    'Tschechische Republik',
    'Österreich',
    'Frankreich',
    'Luxemburg',
    'Schweiz'
);
/

create or replace view v_germany_gender_population as
select
      year
    , federal_state
    , code adm1_code
    , gender
    , gender_population population
    , population state_total_population
    , round((gender_population/population)*100,2) percentage_of_state
from
    gdb_ger_fs_population population
    join fed_state_map state_code on (state_code.state_name = population.federal_state)
unpivot (
    gender_population for gender in (gender_men as 'Male', gender_woman as 'Female')
);
/

create or replace view v_germany_population as
select
    population.year
  , population.federal_state
  , state_code.code adm1_code
  , population.population

from
    gdb_ger_fs_population population
    join fed_state_map state_code on (state_code.state_name = population.federal_state);
/
