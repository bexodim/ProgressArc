angular.module 'ProgressArc', []
 
## controller to generate two random values
    .controller 'getNumbers', ['$scope',($scope) ->
        $scope.values = {expected: .5, actual: .25} ## start values
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
                            .attr 'width', 600
                            .attr 'height', 600

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
                            .innerRadius 160
                            .outerRadius 170
                            .startAngle 0
                            .endAngle values.expected*2*Math.PI

                        arcActual = d3.svg.arc()
                            .innerRadius 180
                            .outerRadius 200
                            .startAngle 0
                            .endAngle values.actual*2*Math.PI
                        
                        svg.selectAll('*').remove() ##coffee-script?
                        svg.append 'path'
                            .attr 'd', arcExpected
                            .attr 'transform', 'translate(200,200)'
                            .attr 'fill', '#E9E9E9'
                        
                        svg.append 'path'
                            .attr 'd', arcActual
                            .attr 'transform', 'translate(200,200)'
                            .attr 'fill', color
                            ##.attr 'stroke-linecap', 'round' ##this is not working
                        
                        ## percentage
                        svg.append 'text'
                            .attr 'x', arcActual.outerRadius()
                            .attr 'y', arcActual.outerRadius()
                            .text(() ->
                                v = Math.round 100*(values.actual)
                                v+"%")
                            .attr 'fill', '#3B2E2A'
                            .attr 'font-size', '6em'
                            .attr 'text-anchor', 'middle'
                            .attr 'dominant-baseline', 'middle'
                        
                        ## "progress"
                        svg.append 'text'
                            .attr 'x', arcActual.outerRadius()
                            .attr 'y', 250 ## 1.25*arcActual.outerRadius()
                            .text("Progress")
                            .attr 'fill', '#3B2E2A'
                            .attr 'font-size', '2em'
                            .attr 'text-anchor', 'middle'
                            .attr 'dominant-baseline', 'middle'
            
        }