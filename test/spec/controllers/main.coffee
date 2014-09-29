describe 'Unit: ArcPropertiesController', () ->
    ## Load the module with MainController
    beforeEach(module('ProgressArc'))

    setup = {}
    ## inject the $controller and $rootScope services
    ## in the beforeEach block
    beforeEach inject ($controller, $rootScope) ->
        ## Create a new scope that's a child of the $rootScope
        setup.scope = $rootScope.$new()
        
        ## Create the controller
        setup.ctrl = $controller 'ArcPropertiesController', {
          $scope: setup.scope
        }
    
    ## for getColor
    ## create mockvalues for each actual from 0 to 1 in steps of .2 vs each expected
    mockvalues = []
        
    
    
    ## function testing
    it 'ensure getAngle returns fraction of circle', () ->
        expect(setup.scope.arcProperties.getAngle(setup.scope.arcProperties.actual)).toEqual(1.2*Math.PI)

    it 'ensure getColor returns colored class', () ->
        expect(setup.scope.arcProperties.getClass(setup.scope.arcProperties.actual, setup.scope.arcProperties.expected)).toEqual('brightgreenarc')
 
###
describe 'Integration/E2E Testing', () ->

    it 'ensure user can change actual and expected values', () ->
        
    it 'ensure actual arc and expected arc are visible', () ->
        
    it 'ensure percentage text is visible', () ->
 ###       
