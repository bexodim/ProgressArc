angular.module 'ProgressArc', []
 
## controller to generate two random values
    .controller 'getNumbers', ['$scope',($scope) ->
        $scope.values = {expected: .5, actual: .6} ## start values
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
                
                getColor = (actual, expected) ->
                    ## changing colors based on actual behind expected ##
                    actualIsBehind = actual < expected
                    lagDecimal = Math.abs(actual - expected)/expected
                    color = '#70C03D' ## bright green
                    if actualIsBehind
                        color = switch
                            when lagDecimal > 0.75 then '#EE5422' ## red
                            when lagDecimal > 0.50 then '#E3C215' ## orange
                            when lagDecimal > 0.25 then '#D9DF13' ## yellow
                            else '#ADEB1A' ## green
                    color
            
                rawSvg = element.find("svg")[0]; ##coffee-script?
                svg = d3.select rawSvg
                    .attr 'width', canvasWidth
                    .attr 'height', canvasHeight

                values = scope.ngModel
                ##console.log scope.ngModel

                arcExpected = d3.svg.arc()
                    .innerRadius expectedArcRadius-10
                    .outerRadius expectedArcRadius
                    .startAngle 0

                arcActual = d3.svg.arc()
                    .innerRadius actualArcRadius-20
                    .outerRadius actualArcRadius
                    .startAngle 0

                svg.selectAll('*').remove() ##coffee-script?

                # bgcircle for style
                svg.append 'circle'
                    .attr 'cx', actualArcRadius
                    .attr 'cy', actualArcRadius
                    .attr 'r', expectedArcRadius-30
                    .attr 'class', 'bgcircle'

                drawExpected = svg.append 'path'
                    .datum {endAngle: values.expected*2*Math.PI}
                    .attr 'd', arcExpected
                    .attr 'transform', 'translate('+actualArcRadius+','+actualArcRadius+')'
                    .attr 'class', 'arcExpected'

                drawActual = svg.append 'path'
                    .datum {endAngle: values.actual*2*Math.PI, color: '#70C03D'}
                    .attr 'd', arcActual
                    .attr 'transform', 'translate('+actualArcRadius+','+actualArcRadius+')'
                    .attr 'fill', getColor values.actual, values.expected ## fill here because it's dynamic

                ## percentage
                percentageText = svg.append 'text'
                    .attr 'x', actualArcRadius
                    .attr 'y', actualArcRadius
                    .text(() ->
                        v = Math.round 100*values.actual
                        v+"%")
                    .attr 'class', 'midTextLarge'


                ## "progress"
                svg.append 'text'
                    .attr 'x', actualArcRadius
                    .attr 'y', 1.25*actualArcRadius
                    .text 'Progress'
                    .attr 'class', 'midTextSmall'
                
                

                scope.$watchCollection 'ngModel', (newValue) ->
                    ## only if there is a newValue redo this
                    if (newValue)
                        
                        ## interpolates the angle based on time
                        arcTween = (transition, newAngle, arc) ->
                            
                            transition.attrTween('d', (d) ->
                                interpolate = d3.interpolate d.endAngle,newAngle
                                (t) ->
                                    d.endAngle = interpolate t
                                    arc d)
                        
                        drawActual.transition()
                            .duration 750
                            .call arcTween, values.actual*2*Math.PI, arcActual
                            .attr 'fill', (d) ->
                                getColor values.actual, values.expected
                            
                        drawExpected.transition()
                            .duration 750
                            .call arcTween, values.expected*2*Math.PI, arcExpected
                            
                        percentageText.transition()
                            .text(() ->
                                v = Math.round 100*values.actual
                                v+"%")
        }