angular.module 'ProgressArc', []
 
## controller to generate two random values
.controller 'getNumbers', ($scope) ->
    $scope.expected = Math.random()
    $scope.actual = Math.random()
	