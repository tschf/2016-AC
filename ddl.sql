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
