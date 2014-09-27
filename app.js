// Generated by CoffeeScript 1.8.0
(function() {
  angular.module('ProgressArc', []).controller('getNumbers', [
    '$scope', function($scope) {
      return $scope.values = {
        expected: .5,
        actual: .75
      };
    }
  ]).directive('ngProgressbar', function() {
    return {
      restrict: 'A',
      require: '^ngModel',
      scope: {
        ngModel: '='
      },
      template: '<svg></svg>',
      link: function(scope, element, attributes) {
        return scope.$watchCollection('ngModel', function(newValue) {
          var actualIsBehind, arcActual, arcExpected, color, lagDecimal, rawSvg, svg, values;
          if (newValue) {
            rawSvg = element.find("svg")[0];
            svg = d3.select(rawSvg).attr('width', 500).attr('height', 500);
            values = scope.ngModel;
            actualIsBehind = values.actual < values.expected;
            lagDecimal = Math.abs(values.actual - values.expected) / values.expected;
            color = "#70C03D";
            if (actualIsBehind) {
              color = (function() {
                switch (false) {
                  case !(lagDecimal > 0.75):
                    return "#EE5422";
                  case !(lagDecimal > 0.50):
                    return "#E3C215";
                  case !(lagDecimal > 0.25):
                    return "#D9DF13";
                  default:
                    return "#ADEB1A";
                }
              })();
            }
            arcExpected = d3.svg.arc().innerRadius(80).outerRadius(85).startAngle(0).endAngle(values.expected * 2 * Math.PI);
            arcActual = d3.svg.arc().innerRadius(90).outerRadius(100).startAngle(0).endAngle(values.actual * 2 * Math.PI);
            svg.selectAll('*').remove();
            svg.append('path').attr('d', arcExpected).attr('transform', 'translate(100,100)').attr('fill', '#E9E9E9');
            svg.append('path').attr('d', arcActual).attr('transform', 'translate(100,100)').attr('fill', color);
            svg.append('text').attr('x', 50).attr('y', 125).text(function() {
              var v;
              v = Math.round(100 * values.actual);
              return v + "%";
            }).attr('fill', '#3B2E2A').attr('font-size', '4em');
            return svg.append('text').attr('x', 75).attr('y', 145).text("Progress").attr('fill', '#3B2E2A').attr('font-size', '1em');
          }
        });
      }
    };
  });

}).call(this);
