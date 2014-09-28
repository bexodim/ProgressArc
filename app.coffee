angular.module 'ProgressArc', []

    .controller 'getNumbers', ['$scope',($scope) ->
        $scope.arcProperties =
            expected: .5
            actual: .6
            getAngle: (decimal) ->
                decimal*2*Math.PI
            getColor: (actual, expected) ->
                actualIsBehind = actual < expected
                lagDecimal = Math.abs(actual - expected)/expected
                
                color = switch
                    when actualIsBehind && lagDecimal > 0.75 then '#EE5422' ## red
                    when actualIsBehind && lagDecimal > 0.50 then '#E3C215' ## orange
                    when actualIsBehind && lagDecimal > 0.25 then '#D9DF13' ## yellow
                    when actualIsBehind && lagDecimal then '#ADEB1A' ## green
                    else '#70C03D' ## bright green
                color

    ]

    ## directive that injects svg element into page
    .directive 'ngProgressbar', () ->
        return {
            restrict: 'A' ## attribute
            require: '^ngModel'
            scope:
                ngModel: '='
            template: '<svg></svg>'
            link: (scope, element, attributes) ->
                canvasWidth = 600
                canvasHeight = 600
            
                expectedArcRadius = 175
                actualArcRadius = 200
                
                arcProperties = scope.ngModel
            
                ## defining svg and arcs
                rawSvg = element.find('svg')[0]
                svg = d3.select rawSvg
                    .attr 'width', canvasWidth
                    .attr 'height', canvasHeight

                arcExpected = d3.svg.arc()
                    .innerRadius expectedArcRadius-10
                    .outerRadius expectedArcRadius
                    .startAngle 0

                arcActual = d3.svg.arc()
                    .innerRadius actualArcRadius-20
                    .outerRadius actualArcRadius
                    .startAngle 0

                # bgcircle for style
                svg.append 'circle'
                    .attr 'cx', actualArcRadius
                    .attr 'cy', actualArcRadius
                    .attr 'r', expectedArcRadius-30
                    .attr 'class', 'bgcircle'

                ## draws the arcs
                drawExpected = svg.append 'path'
                    .datum {endAngle: arcProperties.getAngle(arcProperties.expected)}
                    .attr 'd', arcExpected
                    .attr 'transform', 'translate('+actualArcRadius+','+actualArcRadius+')'
                    .attr 'class', 'arcExpected'

                drawActual = svg.append 'path'
                    .datum {endAngle: arcProperties.getAngle(arcProperties.actual), color: '#70C03D'}
                    .attr 'd', arcActual
                    .attr 'transform', 'translate('+actualArcRadius+','+actualArcRadius+')'
                    .attr 'fill', arcProperties.getColor(arcProperties.actual, arcProperties.expected) ## fill here because it's dynamic

                ## draws percentage text
                percentageText = svg.append 'text'
                    .attr 'x', actualArcRadius
                    .attr 'y', actualArcRadius
                    .text(() ->
                        v = Math.round 100*arcProperties.actual
                        v+"%")
                    .attr 'class', 'midTextLarge'


                ## draws progress text
                svg.append 'text'
                    .attr 'x', actualArcRadius
                    .attr 'y', 1.25*actualArcRadius
                    .text 'Progress'
                    .attr 'class', 'midTextSmall'

                ## watches for change in ngModel, specifically actual and expected values
                ## transitions the arcs and text to the new values
                scope.$watchCollection 'ngModel', (newValue) ->
                    
                    ## only if there is a newValue
                    if (newValue)
                        
                        ## interpolates the angle based on time
                        arcTween = (transition, newAngle, arc) ->
                            transition.attrTween('d', (d) ->
                                interpolate = d3.interpolate d.endAngle,newAngle
                                (t) ->
                                    d.endAngle = interpolate t
                                    arc d)
                        ## actual arc transition
                        ## changes angle and color
                        drawActual.transition()
                            .duration 750
                            .call arcTween, arcProperties.getAngle(arcProperties.actual), arcActual
                            .attr 'fill', arcProperties.getColor(arcProperties.actual, arcProperties.expected)
                            
                        ## expected arc transition
                        ## changes angle
                        drawExpected.transition()
                            .duration 750
                            .call arcTween, arcProperties.getAngle(arcProperties.expected), arcExpected
                        
                        ## percentage text transition
                        percentageText.transition()
                            .text(() ->
                                v = Math.round 100*arcProperties.actual
                                v+"%")
        }