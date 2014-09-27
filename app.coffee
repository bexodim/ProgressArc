angular.module 'ProgressArc', []
 
## controller to generate two random values
    .controller 'getNumbers', ['$scope',($scope) ->
        $scope.values = {expected: .9, actual: .6} ## start values
        ## need to ask exactly what the two numbers mean in terms of arc
    ]
    ## directive that injects svg element into page
    .directive 'ngProgressbar', () ->
        return {
            restrict: 'A' ## attribute
            require: '^ngModel'
            scope:
                ngModel: '='
            template: '<h4>Expected value is {{ ngModel.expected }} and actual value is {{ ngModel.actual }}.</h4><svg></svg>'
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
                        console.log scope.ngModel
                        
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
                        
                        svg.append 'path'
                            .attr 'd', arcActual
                            .attr 'transform', 'translate(100,100)'       
            
        }