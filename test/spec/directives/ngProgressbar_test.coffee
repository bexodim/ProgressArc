### not in use ###
###
describe 'ngProgressbar', () ->

    setup = {}

    beforeEach module 'ProgressArc'
    ##beforeEach module 'test.html' ## will need some kind of template file to test

    beforeEach inject ($controller, $rootScope, $injector, $compile) ->
        setup.scope = $rootScope.$new()
        setup.ctrl = $controller 'ArcPropertiesController', {
            $scope: setup.scope
        }
        setup.compile = $compile
        
        setup.elm = angular.element '<div ng-progressbar ng-model="arcProperties"></div>'
        setup.scope.defined = false;
        $compile(setup.elm)(setup.scope)
        setup.scope.$digest()


    it 'should add an svg element', () ->
        expect(setup.elm.find('svg').length).toBe(1)
    
    it 'should add an arcActual and arcExpected path', () ->  
        expect(setup.elm.find('path').length).toBe(2)
    
    ##it 'should add an arcActual', () ->
        ##expect(setup.elm.find('arcActual').length).toBe(1)

    it 'should add percentage and progress text', () ->
        expect(setup.elm.find('text').length).toBe(2)
###