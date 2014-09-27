angular.module 'ProgressArc', []
 
## controller to generate two random values
    .controller 'getNumbers', ['$scope',($scope) ->
        $scope.values = {expected: .5, actual: .75} ## start values
    ]
    ## directive that injects svg element into page
    .directive 'ngProgressbar', () ->
        return {
            restrict: 'A' ## attribute
            require: '^ngModel'
            scope:
                ngModel: '='
            template: '<svg></svg>'
            ##template: '<h4>Expected value is {{ ngModel.expected }} and actual value is {{ ngModel.actual }}.</h4><svg></svg>'
            link: (scope, element, attributes) ->

                ## check to see if values have changed
                scope.$watchCollection 'ngModel', (newValue) ->
                    ## only if there is a newValue redo this
                    if (newValue)
                        rawSvg = element.find("svg")[0]; ##coffee-script?
                        svg = d3.select rawSvg
                            .attr 'width', 500
                            .attr 'height', 500

                        values = scope.ngModel
                        ##console.log scope.ngModel
                        
                        ## colors ##
                        actualIsBehind = values.actual < values.expected
                        lagDecimal = Math.abs(values.actual - values.expected)/values.expected
                        color = "#70C03D" ## green
                        if actualIsBehind
                            color = switch
                                when lagDecimal > 0.75 then "#EE5422" ## red
                                when lagDecimal > 0.50 then "#E3C215" ## orange
                                when lagDecimal > 0.25 then "#D9DF13" ## yellowish
                                else "#ADEB1A" ## lighter green
                        
                        arcExpected = d3.svg.arc()
                            .innerRadius 80
                            .outerRadius 85
                            .startAngle 0
                            .endAngle values.expected*2*Math.PI

                        arcActual = d3.svg.arc()
                            .innerRadius 90
                            .outerRadius 100
                            .startAngle 0
                            .endAngle values.actual*2*Math.PI
                        
                        svg.selectAll('*').remove() ##coffee-script?
                        svg.append 'path'
                            .attr 'd', arcExpected
                            .attr 'transform', 'translate(100,100)'
                            .attr 'fill', '#E9E9E9'
                        
                        svg.append 'path'
                            .attr 'd', arcActual
                            .attr 'transform', 'translate(100,100)'
                            .attr 'fill', color
                        
                        ## percentage
                        svg.append 'text'
                            .attr 'x', 50
                            .attr 'y', 125
                            .text(() ->
                                v = Math.round 100*(values.actual)
                                v+"%")
                            .attr 'fill', '#3B2E2A'
                            .attr 'font-size', '4em'
                        
                        ## "progress"
                        svg.append 'text'
                            .attr 'x', 75
                            .attr 'y', 145
                            .text("Progress")
                            .attr 'fill', '#3B2E2A'
                            .attr 'font-size', '1em'
            
        }