describe 'ngProgressbar', () ->
  setup = {}

  beforeEach module 'ProgressArc'
  ##beforeEach module 'test.html' ## will need some kind of template file to test

  beforeEach inject ($rootScope, $compile, $injector) ->
    setup.elm = angular.element '<test defined="defined"></test>'

    setup.scope = $rootScope;
    setup.scope.defined = false;

    $compile(setup.elm)(setup.scope)
    setup.scope.$digest()
    
###
  it 'should not be initially defined', () ->
    expect(setup.elm.scope().$$childTail.isDefined()).toBe(false)
###
