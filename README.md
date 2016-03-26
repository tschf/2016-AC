# 2016 APEX Dashboard Competition

## Third party resources

### Logo

The application logo uses a German Map (src/img/DE.png) which was sourced from https://github.com/googlei18n/region-flags. According the the `COPYING` documentation, these were grabbed from Wikipedia and checked to be in the public domain or exempt from copyright.

### Map Visualisation

The visualisation for the map was created by using:

* D3JS - https://github.com/mbostock/d3; and
* TopoJSON - https://github.com/mbostock/topojson

Applicable license agreement for these two libraries:

>Copyright (c) 2012-2016, Michael Bostock
>All rights reserved.
>
>Redistribution and use in source and binary forms, with or without
>modification, are permitted provided that the following conditions are met:
>
>* Redistributions of source code must retain the above copyright notice, this
>  list of conditions and the following disclaimer.
>
>* Redistributions in binary form must reproduce the above copyright notice,
>  this list of conditions and the following disclaimer in the documentation
>  and/or other materials provided with the distribution.
>
>* The name Michael Bostock may not be used to endorse or promote products
>  derived from this software without specific prior written permission.
>
>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
>AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
>IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
>DISCLAIMED. IN NO EVENT SHALL MICHAEL BOSTOCK BE LIABLE FOR ANY DIRECT,
>INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
>BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
>DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
>OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
>NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
>EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The underlying data used to render the German map was sourced from http://www.naturalearthdata.com/. Specifically, the `10m Admin 1 - States, Provinces` data collection. The data is stated as being in the public domain: http://www.naturalearthdata.com/about/terms-of-use/

The data is a shape file, which needs to be converted into a format that d3 and more specifically topoJSON can understand. The is a two part process. Using the command `ogr2ogr` to get the file in a GeoJSON format.

```bash
ogr2ogr -f GeoJSON -where "ADM0_A3 = 'DEU'" states.json ne_10m_admin_1_states_provinces.shp
```

This outputs a GeoJSON file named `states.json`. The next step is to convert this into a topoJSON file. In this command we can limit the data to include only data fields we care about, namely the `id` property being the adm1_code and the name of the state (which is a small subset of what's available in the shape file).

```bash
topojson -o de.json --id-property adm1_code --properties name=name -- states.json
```

This produces the final data file we will use containing all necessary data points to draw the German map with the topojson library.
