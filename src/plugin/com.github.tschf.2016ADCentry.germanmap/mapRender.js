var germanMapRenderer = {

    //event strings as defined in the plugin
    //use with apex.event.trigger so that DA can be picked up when these occur.
    events: {
        stateClicked: "gsm_stateclicked",
        timepointClicked: "gsm_timeclicked"

    },

    setUpMap: function setUpMap(pluginFilePrefix, ajaxIdentifier, initialYear, red, green, blue){

        var projection = d3.geo.mercator()
            .scale(500);

        var path = d3.geo.path()
            .projection(projection);

        //pull heights of all page components, to assign an appropriate height for the map region
        var headerHeight = apex.jQuery('.t-Header-navBar').outerHeight(true);//assumes UT
        var timelineHeaderHeight = apex.jQuery('#mapTimeline h4').outerHeight(true);
        var timelinePointsHeight = apex.jQuery('#mapTimeline #timelinePoints').outerHeight(true);

        var legendHeaderHeight = apex.jQuery('#legend h4').outerHeight(true);
        var legendColourGrid = apex.jQuery('#legend #colourGrid').outerHeight(true);
        var legendCaption = apex.jQuery('#legend #colourGridCaption').outerHeight(true);

        //buffer so the legend isn't right on the page border
        var buffer = 30;

        //figure out the height to make the map so it fits on the page
        var computedHeight = apex.jQuery(window).height()
            -headerHeight
            -timelineHeaderHeight
            -timelinePointsHeight
            -legendHeaderHeight
            -legendColourGrid
            -legendCaption-buffer;

        var svg = d3.select("#germanMap")
            .attr("height", computedHeight);

        //draw the map from topojson file
        d3.json(pluginFilePrefix + "de.json", function(error, de) {

            var states = topojson.feature(de, de.objects.states);

            svg.selectAll(".state")
                .data(states.features)
                .enter().append("path")
                .attr("class", function(d) { return d.id + " germanState"; })
                .attr("d", path)
                .on("click", germanMapRenderer.onClickState);

            germanMapRenderer.updateMapPopulationDisplay(ajaxIdentifier, initialYear, red, green, blue);

            //trim spacing around the svg/map
            var generatedChart = document.querySelector("svg#germanMap");
            var bbox = generatedChart.getBBox();
            var viewBox = [bbox.x, bbox.y, bbox.width, bbox.height].join(" ");
            generatedChart.setAttribute("viewBox", viewBox);
        });

    },

    //Fire event for DA to react to, when the state is clicked
    //clickSource can be: stateTooltip or state
    sendStateClicked: function(adm1Code, clickSource){

        //function adapted from: http://stackoverflow.com/a/4819886/3476713
        //return Bool of if running on a touch device
        function isTouchDevice() {

            //returns as 1 or 0
            var _isTouchDevice = 'ontouchstart' in window  // works on most browsers
                || navigator.maxTouchPoints;              // works on IE10/11 and Surface

            //convert just for easier debugging (showing true/false vs 0/1)
            return Boolean(_isTouchDevice);
        };

        apex.event.trigger(
            document,
            germanMapRenderer.events.stateClicked,
            {
                adm1_code: adm1Code,
                source: clickSource,
                isTouchDevice: isTouchDevice()
            }
        );
    },

    onClickState: function clickedState(d){
        germanMapRenderer.sendStateClicked(d.id, 'state');
    },

    registerChangeTime: function registerChangeTime(ajaxIdentifier, red, green, blue){

        apex.jQuery('#timelinePoints li').click(function(){

            var $period = apex.jQuery(this);
            var clickedTimePeriodYear = apex.jQuery(this).text();

            $('#timelinePoints li').removeClass('active');
            $period.addClass('active');

            germanMapRenderer.updateMapPopulationDisplay(ajaxIdentifier, clickedTimePeriodYear, red, green, blue);

            //Send a DA event should any further logic want to be introduced
            apex.event.trigger($period, germanMapRenderer.events.timepointClicked, { year: clickedTimePeriodYear });

        });
    },

    updateMapPopulationDisplay: function updateMapPopulationDisplay(ajaxIdentifier, year, red, green, blue){

        var throbber = apex.util.showSpinner();
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
                            .attr('title', '<div class="stateTooltipText"'
                                + 'data-adm1_code="'
                                + state
                                + '">'
                                + '<span class="bold">'
                                + statePcts[state].stateName
                                + '\nYear:</span> '
                                + statePcts[state].year
                                + '\n<span class="bold">Population:</span> '
                                + formattedPopulation
                                + '\nClick for more info...'
                                + '</div>');//Map region switched with charts)

                        throbber.remove();
                    }
                }
            }
        );
    }

};
