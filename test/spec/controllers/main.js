// Generated by CoffeeScript 1.8.0
(function() {
  describe('Unit: ArcPropertiesController', function() {
    var setup;
    beforeEach(module('ProgressArc'));
    setup = {};
    beforeEach(inject(function($controller, $rootScope) {
      setup.scope = $rootScope.$new();
      return setup.ctrl = $controller('ArcPropertiesController', {
        $scope: setup.scope
      });
    }));
    it('ensure getAngle returns 0 when actual = 0', function() {
      setup.scope.arcProperties.actual = 0;
      return expect(setup.scope.arcProperties.getAngle(setup.scope.arcProperties.actual)).toEqual(0);
    });
    it('ensure getAngle returns PI when actual = 0.5', function() {
      setup.scope.arcProperties.actual = 0.5;
      return expect(setup.scope.arcProperties.getAngle(setup.scope.arcProperties.actual)).toEqual(Math.PI);
    });
    it('ensure getAngle returns 2*PI when actual = 1', function() {
      setup.scope.arcProperties.actual = 1;
      return expect(setup.scope.arcProperties.getAngle(setup.scope.arcProperties.actual)).toEqual(2 * Math.PI);
    });

    /*
    it 'ensure exception thrown and angle = 0 when user inputs negative', () ->
        setup.scope.arcProperties.actual = -1
        angleFn = ->
            setup.scope.arcProperties.getAngle(setup.scope.arcProperties.actual)
    
        expect(angleFn).toThrow()
     */

    /*
    it 'ensure exception thrown and angle = 0 when user inputs > 1', () ->
        setup.scope.arcProperties.actual = 2
        angleFn = ->
            setup.scope.arcProperties.getAngle(setup.scope.arcProperties.actual)
    
        expect(angleFn).toThrow()
     */
    it('ensure getClass returns red when actual is lagging expected by more than 75%', function() {
      var actual, expected;
      expected = 1;
      actual = 0.24;
      return expect(setup.scope.arcProperties.getClass(actual, expected)).toEqual('redarc');
    });
    it('ensure getClass returns orange when actual is lagging expected by more than 50%', function() {
      var actual, expected;
      expected = 1;
      actual = 0.49;
      return expect(setup.scope.arcProperties.getClass(actual, expected)).toEqual('orangearc');
    });
    it('ensure getClass returns yellow when actual is lagging expected by more than 25%', function() {
      var actual, expected;
      expected = 1;
      actual = 0.74;
      return expect(setup.scope.arcProperties.getClass(actual, expected)).toEqual('yellowarc');
    });
    it('ensure getClass returns green when actual is lagging expected at all', function() {
      var actual, expected;
      expected = 1;
      actual = 0.9;
      return expect(setup.scope.arcProperties.getClass(actual, expected)).toEqual('greenarc');
    });
    return it('ensure getClass returns bright green when actual is the same or greater than expected', function() {
      var actual, actualtoo, expected;
      expected = 0.9;
      actual = 0.9;
      actualtoo = 0.95;
      expect(setup.scope.arcProperties.getClass(actual, expected)).toEqual('brightgreenarc');
      return expect(setup.scope.arcProperties.getClass(actualtoo, expected)).toEqual('brightgreenarc');
    });
  });

  describe('ngProgressbar', function() {
    var setup;
    setup = {};
    beforeEach(module('ProgressArc'));
    beforeEach(inject(function($controller, $rootScope, $injector, $compile) {
      setup.scope = $rootScope.$new();
      setup.ctrl = $controller('ArcPropertiesController', {
        $scope: setup.scope
      });
      setup.compile = $compile;
      setup.elm = angular.element('<div ng-progressbar ng-model="arcProperties"></div>');
      setup.scope.defined = false;
      $compile(setup.elm)(setup.scope);
      return setup.scope.$digest();
    }));
    it('should add an svg element', function() {
      return expect(setup.elm.find('svg').length).toBe(1);
    });
    it('should add an arcActual and arcExpected path', function() {
      return expect(setup.elm.find('path').length).toBe(2);
    });
    return it('should add percentage and progress text', function() {
      return expect(setup.elm.find('text').length).toBe(2);
    });
  });

}).call(this);
