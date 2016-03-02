# Notes

## Federal States

|From Tobias|In shapefile|State Code|adm1_code|
|---|---|---|---|
|BadenWürttemberg|Baden-Württemberg|BW|DEU-1573|
|Bayern|Bayern|BY|DEU-1591|
|Berlin|Berlin|BE|DEU-1599|
|Brandenburg|Brandenburg|BE|DEU-3487|
|Bremen|Bremen|HB|DEU-1575|
|Hamburg|Hamburg|HH|DEU-1578|
|Hessen|Hessen|HE|DEU-1574|
|MecklenburgVorpommern|Mecklenburg-Vorpommern|MV|DEU-3488|
|Niedersachsen|Niedersachsen|NI|DEU-1576|
|NordrheinWestfalen|Nordrhein-Westfalen|NW|DEU-1572|
|RheinlandPfalz|Rheinland-Pfalz|RP|DEU-1580|
|Saarland|Saarland|SL|DEU-1581|
|SachsenAnhalt|Sachsen-Anhalt|ST|DEU-1600|
|Sachsen|Sachsen|SN|DEU-1601|
|SchleswigHolstein|Schleswig-Holstein|SH|DEU-1579|
|Thüringen|Thüringen|TH|DEU-1577|

The names have a difference, so should use the state code (`postal`) as a lookup.
Berlin and Brandenburg have the same postal code, need to use `adm1_code` (or `adm1_cod1`)

## Converting the data

First it needs to be converted into a GeoJSON file. For this, we filter the data on rows where the country code is DEU.

```bash
 ogr2ogr -f GeoJSON -where "ADM0_A3 = 'DEU'" states.json ne_10m_admin_1_states_provinces.shp
```

Then, we want to convert this into a topojson file:

```bash
topojson -o output.json --id-property adm1_code --properties name=name -- states.json
```

## CSS Generator for HeatMap

```plsql
begin

for i in (
with population_data as (
    select population, fed_state_map.code, max(population) over (order by 1) max_pop
    from gdb_ger_fs_population
    join fed_state_map on (fed_state_map.state_name = gdb_ger_fs_population.federal_state)
    where year = 2014
    order by population desc
)
select population_data.code, round(1-(max_pop-population)/max_pop,2) opacity
from population_data
)
loop
    dbms_output.put_line('.' || i.code || ' { fill: rgba(177,23,23,' || i.opacity || '); }');
end loop;
end;
```

## EU Countries

English          | Non-english
---              | ---
Austria          | Österreich
Belgium          | Belgien
Bulgaria         | Bulgarien
Croatia          | Kroatien
Cyprus           | Zypern
Czech Republic   | Tschechische Republik
Denmark          | Dänemark
Estonia          | Estland
Finland          | Finnland
France           | Frankreich
Germany          | Deutschland
Hungary          | Ungarn
Ireland          | Irland
Italy            | Italien
Latvia           | Lettland
Lithuania        | Litauen
Luxembourg       | Luxemburg
Malta            | Malta
Netherlands      | Niederlande
Poland           | Polen
Portugal         | Portugal
Romania          | Rumänien
Slovakia         | Slowakei
Slovenia         | Slowenien
Spain            | Spanien
Sweden           | Schweden
United Kingdom   | Vereinigtes Königreich

source: http://europa.eu/about-eu/countries/index_en.htm
