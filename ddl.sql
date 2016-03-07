create table fed_state_map(
    ID NUMBER PRIMARY KEY,
    ADM1_CODE VARCHAR2(8) NOT NULL,
    STATE_NAME VARCHAR2(30) NOT NULL,
    PREFERRED_SPELLING VARCHAR2(1) DEFAULT 'Y' NOT NULL
);
/

alter table fed_state_map
add constraint "FED_STATE_MAP_UK1" UNIQUE ("ADM1_CODE", "STATE_NAME", "PREFERRED_SPELLING");
/

alter table fed_state_map
add constraint "FED_STATE_MAP_CHK1" CHECK (PREFERRED_SPELLING IN ('Y', 'N'));
/

create sequence fed_state_map_seq;
/

create or replace trigger BI_FED_STATE_MAP
before insert on FED_STATE_MAP
for each row
begin
    :NEW.ID := fed_state_map_seq.nextval;
end BI_FED_STATE_MAP;
/

insert into fed_state_map (adm1_code, state_name, preferred_spelling) values ('DEU-1573', 'BadenWürttemberg', 'N');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1591', 'Bayern');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1599', 'Berlin');
insert into fed_state_map (adm1_code, state_name) values ('DEU-3487', 'Brandenburg');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1575', 'Bremen');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1578', 'Hamburg');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1574', 'Hessen');
insert into fed_state_map (adm1_code, state_name, preferred_spelling) values ('DEU-3488', 'MecklenburgVorpommern', 'N');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1576', 'Niedersachsen');
insert into fed_state_map (adm1_code, state_name, preferred_spelling) values ('DEU-1572', 'NordrheinWestfalen', 'N');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1580', 'RheinlandPfalz');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1581', 'Saarland');
insert into fed_state_map (adm1_code, state_name, preferred_spelling) values ('DEU-1600', 'SachsenAnhalt', 'N');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1601', 'Sachsen');
insert into fed_state_map (adm1_code, state_name, preferred_spelling) values ('DEU-1579', 'SchleswigHolstein', 'N');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1577', 'Thüringen');

insert into fed_state_map (adm1_code, state_name) values ('DEU-1573', 'Baden-Württemberg');
insert into fed_state_map (adm1_code, state_name) values ('DEU-3488', 'Mecklenburg-Vorpommern');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1572', 'Nordrhein-Westfalen');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1580', 'Rheinland-Pfalz');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1600', 'Sachsen-Anhalt');
insert into fed_state_map (adm1_code, state_name) values ('DEU-1579', 'Schleswig-Holstein');
/



create table species_simplification (
    ID NUMBER PRIMARY KEY
  , simplified_name varchar2(25) not null
  , original_name varchar2(100) not null
);
/

create sequence species_simplification_Seq;
/

create or replace trigger BI_SPECIES_SIMPLIFICATION
before insert on species_simplification
for each row
begin
    :NEW.ID := species_simplification_Seq.nextval;
end BI_SPECIES_SIMPLIFICATION;
/

alter table species_simplification
add constraint "SPECIES_SIMPLIFICATION_UK1" UNIQUE ("SIMPLIFIED_NAME", "ORIGINAL_NAME");
/

insert into species_simplification (simplified_name, original_name) values ('Bovine', 'Bovine 1 bu2 J., female, livestock u.Zuchttiere');
insert into species_simplification (simplified_name, original_name) values ('Bovine', 'Bovine 2 Juälter, heifers and as breeding. Livestock');
insert into species_simplification (simplified_name, original_name) values ('Bovine', 'Bovine 2 years and older, bulls and bullocks');
insert into species_simplification (simplified_name, original_name) values ('Bovine', 'Bovine 2 years and over, dairy cows');
insert into species_simplification (simplified_name, original_name) values ('Bovine', 'Bovine 2 years and over, heifers for slaughter');
insert into species_simplification (simplified_name, original_name) values ('Bovine', 'Bovine 2 years and over, other cows');
insert into species_simplification (simplified_name, original_name) values ('Bovine', 'Calves through 8 months');
insert into species_simplification (simplified_name, original_name) values ('Bovine', 'Cattle 1 to u. 2 years, female, for slaughter');
insert into species_simplification (simplified_name, original_name) values ('Bovine', 'Cattle between 1 and 2 years, male gender');
insert into species_simplification (simplified_name, original_name) values ('Poultry', 'Duck');
insert into species_simplification (simplified_name, original_name) values ('Pig', 'Fattening pigs from 50 to less than 80 kilograms live weight');
insert into species_simplification (simplified_name, original_name) values ('Pig', 'Fattening pigs from 80 to less than 110 kilograms live weight');
insert into species_simplification (simplified_name, original_name) values ('Sheep', 'Female sheep for breeding');
insert into species_simplification (simplified_name, original_name) values ('Poultry', 'Geese');
insert into species_simplification (simplified_name, original_name) values ('Goat', 'Goats, female');
insert into species_simplification (simplified_name, original_name) values ('Goat', 'Goats, male');
insert into species_simplification (simplified_name, original_name) values ('Poultry', 'Laying hens 1/2 year old and older');
insert into species_simplification (simplified_name, original_name) values ('Sheep', 'Other sheep');
insert into species_simplification (simplified_name, original_name) values ('Pig', 'Piglet');
insert into species_simplification (simplified_name, original_name) values ('Pig', 'Porkers 110 and more kilograms live weight');
insert into species_simplification (simplified_name, original_name) values ('Poultry', 'Pullets under 1/2 year old');
insert into species_simplification (simplified_name, original_name) values ('Sheep', 'Sheep under 1 year old');
insert into species_simplification (simplified_name, original_name) values ('Poultry', 'Slaughter u. Broilers and all taps');
insert into species_simplification (simplified_name, original_name) values ('Poultry', 'Turkeys');
insert into species_simplification (simplified_name, original_name) values ('Bovine', 'Young cattle over 8 months to 1 year old, male');
insert into species_simplification (simplified_name, original_name) values ('Bovine', 'Young cattle over 8 months to 1 year, female');
insert into species_simplification (simplified_name, original_name) values ('Pig', 'Young pigs less than 50 kg live weight, excluding piglet');
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
    , adm1_code
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
  , state_code.adm1_code
  , population.population

from
    gdb_ger_fs_population population
    join fed_state_map state_code on (state_code.state_name = population.federal_state);
/

create or replace view v_germany_projected_population as
select
    federal_state
  , adm1_code
  , projection_year
  , year_population
from
    gdb_ger_fs_population_future population
    join fed_state_map state_code on (state_code.state_name = population.federal_state)
unpivot (
    year_population for projection_year in (
        YEAR_2015 as '2015',
        YEAR_2016 as '2016',
        YEAR_2017 as '2017',
        YEAR_2018 as '2018',
        YEAR_2019 as '2019',
        YEAR_2020 as '2020',
        YEAR_2021 as '2021',
        YEAR_2022 as '2022',
        YEAR_2023 as '2023',
        YEAR_2024 as '2024',
        YEAR_2025 as '2025',
        YEAR_2026 as '2026',
        YEAR_2027 as '2027',
        YEAR_2028 as '2028',
        YEAR_2029 as '2029',
        YEAR_2030 as '2030',
        YEAR_2031 as '2031',
        YEAR_2032 as '2032',
        YEAR_2033 as '2033',
        YEAR_2034 as '2034',
        YEAR_2035 as '2035',
        YEAR_2036 as '2036',
        YEAR_2037 as '2037',
        YEAR_2038 as '2038',
        YEAR_2039 as '2039',
        YEAR_2040 as '2040'
    )
)
where population_by_gender in ('total','Insgesamt');
/

create or replace view v_germany_animal_farming as
select
    federal_state
  , adm1_code
  , trim(species) species
  , farming_year
  , amount_farmed
from
    gdb_ger_fs_animal_farming farming
    join fed_state_map state_code on (state_code.state_name = farming.federal_state)
unpivot include nulls (
    amount_farmed for farming_year in (
        year_2006 as '2006',
        year_2007 as '2007',
        year_2008 as '2008',
        year_2009 as '2009',
        year_2010 as '2010',
        year_2011 as '2011',
        year_2012 as '2012',
        year_2013 as '2013',
        year_2014 as '2014',
        year_2015 as '2015'
    )
);
/

create or replace view v_germany_animal_farmin_simpl as
select
    raw_data.federal_state
  , raw_data.adm1_code
  , species_simplification.simplified_name species
  , raw_data.farming_year
  , sum(coalesce(raw_data.amount_farmed, 0)) amount_farmed
from
    v_germany_animal_farming raw_data
    join species_simplification on (raw_data.species = species_simplification.original_name)
group by
    raw_data.federal_state
  , raw_data.adm1_code
  , species_simplification.simplified_name
  , raw_data.farming_year;
/
