// Generated by CoffeeScript 1.8.0
(function() {
  angular.module('ProgressArc', []).controller('ArcPropertiesController', [
    '$scope', function($scope) {
      return $scope.arcProperties = {
        expected: .5,
        actual: .6,
        getAngle: function(decimal) {
          var angle, err;
          angle = decimal * 2 * Math.PI;
          try {
            if (decimal > 1) {
              throw "must be a fraction";
            }
            if (decimal < 0) {
              throw "does not accept negative numbers";
            }
            if (isNaN(decimal)) {
              throw "not a number";
            }
          } catch (_error) {
            err = _error;
            angle = 0;
            alert('please enter a valid number');
          }
          return angle;
        },
        getClass: function(actual, expected) {
          var actualIsBehind, colorClass, lagDecimal;
          actualIsBehind = actual < expected;
          lagDecimal = Math.abs(actual - expected) / expected;
          colorClass = (function() {
            switch (false) {
              case !(actualIsBehind && lagDecimal > 0.75):
                return 'redarc';
              case !(actualIsBehind && lagDecimal > 0.50):
                return 'orangearc';
              case !(actualIsBehind && lagDecimal > 0.25):
                return 'yellowarc';
              case !(actualIsBehind && lagDecimal):
                return 'greenarc';
              default:
                return 'brightgreenarc';
            }
          })();
          return colorClass;
        }
      };
    }
  ]).directive('ngProgressbar', function() {
    return {
      restrict: 'A',
      require: '^ngModel',
      scope: {
        ngModel: '='
      },
      template: '<svg id="svg"></svg>',
      link: function(scope, element, attributes) {
        var actualArcRadius, arcActual, arcExpected, arcProperties, canvasHeight, canvasWidth, drawActual, drawExpected, expectedArcRadius, percentageText, rawSvg, svg;
        canvasWidth = 600;
        canvasHeight = 600;
        expectedArcRadius = 175;
        actualArcRadius = 200;
        arcProperties = scope.ngModel;
        rawSvg = element.find('svg')[0];
        svg = d3.select(rawSvg).attr('width', canvasWidth).attr('height', canvasHeight);
        arcExpected = d3.svg.arc().innerRadius(expectedArcRadius - 10).outerRadius(expectedArcRadius).startAngle(0);
        arcActual = d3.svg.arc().innerRadius(actualArcRadius - 20).outerRadius(actualArcRadius).startAngle(0);
        svg.append('circle').attr('cx', actualArcRadius).attr('cy', actualArcRadius).attr('r', expectedArcRadius - 30).attr('class', 'bgcircle');
        drawExpected = svg.append('path').datum({
          endAngle: arcProperties.getAngle(arcProperties.expected)
        }).attr('d', arcExpected).attr('transform', "translate(" + actualArcRadius + ", " + actualArcRadius + ")").attr('class', 'arcExpected');
        drawActual = svg.append('path').datum({
          endAngle: arcProperties.getAngle(arcProperties.actual)
        }).attr('d', arcActual).attr('transform', "translate(" + actualArcRadius + ", " + actualArcRadius + ")").attr('class', arcProperties.getClass(arcProperties.actual, arcProperties.expected));
        percentageText = svg.append('text').attr('x', actualArcRadius).attr('y', actualArcRadius).text(function() {
          var v;
          v = Math.round(100 * arcProperties.actual);
          return v + "%";
        }).attr('class', 'midTextLarge');
        svg.append('text').attr('x', actualArcRadius).attr('y', 1.25 * actualArcRadius).text('Progress').attr('class', 'midTextSmall');
        return scope.$watchCollection('ngModel', function(newValue) {
          var arcTween;
          if (newValue) {
            arcTween = function(transition, newAngle, arc) {
              return transition.attrTween('d', function(d) {
                var interpolate;
                interpolate = d3.interpolate(d.endAngle, newAngle);
                return function(t) {
                  d.endAngle = interpolate(t);
                  return arc(d);
                };
              });
            };
            drawActual.transition().duration(750).call(arcTween, arcProperties.getAngle(arcProperties.actual), arcActual).attr('class', arcProperties.getClass(arcProperties.actual, arcProperties.expected));
            drawExpected.transition().duration(750).call(arcTween, arcProperties.getAngle(arcProperties.expected), arcExpected);
            return percentageText.transition().text(function() {
              var v;
              v = Math.round(100 * arcProperties.actual);
              return v + "%";
            });
          }
        });
      }
    };
  });

}).call(this);
