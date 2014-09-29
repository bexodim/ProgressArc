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
        
    
    
    ## angle calculation testing
    it 'ensure getAngle returns 0 when actual = 0', () ->
        setup.scope.arcProperties.actual = 0
        expect(setup.scope.arcProperties.getAngle(setup.scope.arcProperties.actual)).toEqual(0)
        
    it 'ensure getAngle returns PI when actual = 0.5', () ->
        setup.scope.arcProperties.actual = 0.5
        expect(setup.scope.arcProperties.getAngle(setup.scope.arcProperties.actual)).toEqual(Math.PI)
    
    it 'ensure getAngle returns 2*PI when actual = 1', () ->
        setup.scope.arcProperties.actual = 1
        expect(setup.scope.arcProperties.getAngle(setup.scope.arcProperties.actual)).toEqual(2*Math.PI)
    
    ###
    it 'ensure exception thrown and angle = 0 when user inputs negative', () ->
        setup.scope.arcProperties.actual = -1
        angleFn = ->
            setup.scope.arcProperties.getAngle(setup.scope.arcProperties.actual)

        expect(angleFn).toThrow()
    ###
    
    ###
    it 'ensure exception thrown and angle = 0 when user inputs > 1', () ->
        setup.scope.arcProperties.actual = 2
        angleFn = ->
            setup.scope.arcProperties.getAngle(setup.scope.arcProperties.actual)

        expect(angleFn).toThrow()
    ###

    ## color class calculation testing
    it 'ensure getClass returns red when actual is lagging expected by more than 75%', () ->
        expected = 1
        actual = 0.24
        expect(setup.scope.arcProperties.getClass(actual,expected)).toEqual('redarc')
        
    it 'ensure getClass returns orange when actual is lagging expected by more than 50%', () ->
        expected = 1
        actual = 0.49
        expect(setup.scope.arcProperties.getClass(actual,expected)).toEqual('orangearc')
        
    it 'ensure getClass returns yellow when actual is lagging expected by more than 25%', () ->
        expected = 1
        actual = 0.74
        expect(setup.scope.arcProperties.getClass(actual,expected)).toEqual('yellowarc')
        
    it 'ensure getClass returns green when actual is lagging expected at all', () ->
        expected = 1
        actual = 0.9
        expect(setup.scope.arcProperties.getClass(actual,expected)).toEqual('greenarc')
        
    it 'ensure getClass returns bright green when actual is the same or greater than expected', () ->
        expected = 0.9
        actual = 0.9
        actualtoo = 0.95
        expect(setup.scope.arcProperties.getClass(actual,expected)).toEqual('brightgreenarc')
        expect(setup.scope.arcProperties.getClass(actualtoo,expected)).toEqual('brightgreenarc')