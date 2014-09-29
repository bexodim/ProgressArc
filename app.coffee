angular.module 'ProgressArc', []
    
    ## ArcPropertiesController
    ## sets default values for expected and actual values
    ## getAngle calculates arc angle based on actual and expected values
    ## getColor calculates the color of the actual arc based on how far actual is behind expected
    .controller 'ArcPropertiesController', ['$scope',($scope) ->
        $scope.arcProperties =
            expected: .5
            actual: .6
            getAngle: (decimal) ->
                decimal*2*Math.PI
            getClass: (actual, expected) ->
                actualIsBehind = actual < expected
                lagDecimal = Math.abs(actual - expected)/expected
                
                colorClass = switch
                    when actualIsBehind && lagDecimal > 0.75 then 'redarc' ## red
                    when actualIsBehind && lagDecimal > 0.50 then 'orangearc' ## orange
                    when actualIsBehind && lagDecimal > 0.25 then 'yellowarc' ## yellow
                    when actualIsBehind && lagDecimal then 'greenarc' ## light green
                    else 'brightgreenarc' ## bright green
                colorClass

    ]

    ## ngProgessbar
    ## directive injects empty svg element into page using d3.js
    ## creates expected and actual arcs and appends them to the svg
    ## creates text to display progress and appends them to the svg
    ## watches for changes to the model
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
            
                rawSvg = element.find('svg')[0]
                svg = d3.select rawSvg
                    .attr 'width', canvasWidth
                    .attr 'height', canvasHeight
                
                ## arc definitions
                arcExpected = d3.svg.arc()
                    .innerRadius expectedArcRadius-10
                    .outerRadius expectedArcRadius
                    .startAngle 0

                arcActual = d3.svg.arc()
                    .innerRadius actualArcRadius-20
                    .outerRadius actualArcRadius
                    .startAngle 0

                svg.append 'circle' # bgcircle for style
                    .attr 'cx', actualArcRadius
                    .attr 'cy', actualArcRadius
                    .attr 'r', expectedArcRadius-30
                    .attr 'class', 'bgcircle'

                ## draws arcs defined above
                drawExpected = svg.append 'path'
                    .datum {endAngle: arcProperties.getAngle(arcProperties.expected)}
                    .attr 'd', arcExpected
                    .attr 'transform', 'translate('+actualArcRadius+','+actualArcRadius+')'
                    .attr 'class', 'arcExpected'

                drawActual = svg.append 'path'
                    .datum {endAngle: arcProperties.getAngle(arcProperties.actual)}
                    .attr 'd', arcActual
                    .attr 'transform', 'translate('+actualArcRadius+','+actualArcRadius+')'
                    .attr 'class', arcProperties.getClass(arcProperties.actual, arcProperties.expected)

                ## draws text
                percentageText = svg.append 'text'
                    .attr 'x', actualArcRadius
                    .attr 'y', actualArcRadius
                    .text(() ->
                        v = Math.round 100*arcProperties.actual
                        v+"%")
                    .attr 'class', 'midTextLarge'

                svg.append 'text'
                    .attr 'x', actualArcRadius
                    .attr 'y', 1.25*actualArcRadius
                    .text 'Progress'
                    .attr 'class', 'midTextSmall'

                ## function watches for change in ngModel, specifically actual and expected values
                ## creates transitions to the next state using d3.js tween for arc angles and colors
                scope.$watchCollection 'ngModel', (newValue) ->
                    
                    ## only if there is a newValue
                    if (newValue)
                        
                        ## arcTween
                        ## interpolates the old angles and new angle based on time
                        ## returns the arc angle for each t
                        arcTween = (transition, newAngle, arc) ->
                            transition.attrTween('d', (d) ->
                                interpolate = d3.interpolate d.endAngle,newAngle
                                (t) ->
                                    d.endAngle = interpolate t
                                    arc d)
                        
                        ## adds transition to actual arc
                        ## interpolates angle and color
                        drawActual.transition()
                            .duration 750
                            .call arcTween, arcProperties.getAngle(arcProperties.actual), arcActual
                            .attr 'class', arcProperties.getClass(arcProperties.actual, arcProperties.expected)
                            
                        ## adds transition to expected arc
                        ## interpolates angle
                        drawExpected.transition()
                            .duration 750
                            .call arcTween, arcProperties.getAngle(arcProperties.expected), arcExpected
                        
                        ## adds transition to actual arc percentage
                        percentageText.transition()
                            .text(() ->
                                v = Math.round 100*arcProperties.actual
                                v+"%")
        }