var germanMapRenderer = {

    width: 960,
    height: 750,
    scale: 500,

    setUpMap: function setUpMap(width, height, pluginFilePrefix, ajaxIdentifier, initialYear, red, green, blue){

        var projection = d3.geo.mercator()
            //.center([10.5, 51.35])
            .scale(500)
            .translate([width / 2, height / 2]);

        var path = d3.geo.path()
            .projection(projection);

        //pull heights of all page components, to assign an appropriate height for the map region
        var headerHeight = apex.jQuery('.t-Header-navBar').outerHeight(true);
        var timelineHeaderHeight = apex.jQuery('#mapTimeline h4').outerHeight(true);
        var timelinePointsHeight = apex.jQuery('#mapTimeline #timelinePoints').outerHeight(true);

        var legendHeaderHeight = apex.jQuery('#legend h4').outerHeight(true);
        var legendColourGrid = apex.jQuery('#legend #colourGrid').outerHeight(true);
        var legendCaption = apex.jQuery('#legend #colourGridCaption').outerHeight(true);

        //buffer so the legend isn't right on the page border
        var buffer = 30;

        //figure out the height to make the map so it fits on the page
        var computedHeight = apex.jQuery(window).height()-headerHeight-timelineHeaderHeight-timelinePointsHeight-legendHeaderHeight-legendColourGrid-legendCaption-buffer;

        var svg = d3.select("#germanMap")
            .attr("height", computedHeight);

        d3.json(pluginFilePrefix + "de.json", function(error, de) {

            var states = topojson.feature(de, de.objects.states);

            svg.selectAll(".state")
                .data(states.features)
                .enter().append("path")
                .attr("class", function(d) { return d.id + " germanState"; })
                .attr("d", path)
                .on("click", germanMapRenderer.onClickState);

            germanMapRenderer.updateMapPopulationDisplay(ajaxIdentifier, initialYear, red, green, blue);

            var generatedChart = document.getElementsByTagName("svg")[0];

            var bbox = generatedChart.getBBox();
            var viewBox = [bbox.x, bbox.y, bbox.width, bbox.height].join(" ");
            generatedChart.setAttribute("viewBox", viewBox);
        });

    },

    onClickState: function clickedState(d){
        apex.event.trigger(document, 'showstateinfo', {adm1_code: d.id});
    },

    registerChangeTime: function registerChangeTime(ajaxIdentifier, red, green, blue){

        apex.jQuery('#timelinePoints li').click(function(){

            var $period = apex.jQuery(this);
            var clickedTimePeriodYear = apex.jQuery(this).text();

            $('#timelinePoints li').removeClass('active');
            $period.addClass('active');

            germanMapRenderer.updateMapPopulationDisplay(ajaxIdentifier, clickedTimePeriodYear, red, green, blue);

            //Send a DA event should any further logic want to be introduced
            apex.event.trigger($period, 'gsm_timeclicked', { year: clickedTimePeriodYear });

        });
    },

    updateMapPopulationDisplay: function updateMapPopulationDisplay(ajaxIdentifier, year, red, green, blue){

        apex.server.plugin(
            ajaxIdentifier,
            {
                "x01" : year
            },
            {
                dataType: 'json',
                success: function(statePcts) {

                    for (state in statePcts){

                        //Format the number with spacing for every 3 digits
                        //Idea grabbed from: http://stackoverflow.com/questions/16637051/adding-space-between-numbers
                        var formattedPopulation =
                            statePcts[state]
                                .totalPopulation
                                .toString()
                                .replace(/\B(?=(\d{3})+(?!\d))/g, " ");

                        apex.jQuery('.'+state)
                            .attr('style', 'fill: rgba(' + red + ','+ green +','+ blue +',' + statePcts[state].pctOfMax + ')')
                            .attr('title', '<span class="bold">'
                                + statePcts[state].stateName
                                + '\nPopulation:</span> '
                                + formattedPopulation
                                + '\nClick for more info...');//Map region switched with charts)
                    }
                }
            }
        );
    }

};
