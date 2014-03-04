'use strict'

### Controllers ###

angular.module('app.controllers', [])

.controller('NavCtrl', [
  '$scope'
  '$location'
  '$resource'
  'Restangular'

($scope, $location, $resource, Restangular) ->

  # Uses the url to determine if the selected
  # menu item should have the class active.
  $scope.$location = $location
  $scope.$watch('$location.path()', (path) ->
    $scope.activeNavId = path || '/'
  )

  # getClass compares the current url with the id.
  # If the current url starts with the id it returns 'active'
  # otherwise it will return '' an empty string. E.g.
  #
  #   # current url = '/products/1'
  #   getClass('/products') # returns 'active'
  #   getClass('/orders') # returns ''
  #
  $scope.getClass = (id) ->
    if $scope.activeNavId.substring(0, id.length) == id
      return 'active'
    else
      return ''

  $scope.user = Restangular.one('Users', 'Current').get().$object;
])

.controller('DashboardCtrl', [
  '$scope'
  'Restangular'

($scope, Restangular) ->
  $scope.events = Restangular.all('Events').getList().$object;
])

.controller('AdminDashboardCtrl', [
  '$scope'

($scope) ->
  $scope.events = [
    title: "One"
    location: "Here"
  ,
    title: "Two"
    location: "There"
  ]
])

.controller('EventCtrl', [
  '$scope', '$routeParams', 'Restangular', '$modal'

($scope, $routeParams, Restangular, $modal) ->
  eventID = $routeParams.eventID
  console.log(eventID)
  $scope.attendees = []
  $scope.user = Restangular.one('Users', 'Current').get().$object;
  eventRoute = Restangular.one('Events', eventID)
  eventRoute.get().then((data) ->
    $scope.event = data
    if ($scope.event.UsersInEvent.length + $scope.event.GuestsInEvent.length == 0)
      $scope.attendees.push({name:"No one :(", id: -1})
    else
      for user in $scope.event.UsersInEvent
        userObj = {}
        userObj['name'] = user.WindowsName
        if user.Name?
          userObj['name'] = user.Name
        userObj['type'] = 'user'
        userObj['id'] = user.UserID
        $scope.attendees.push(userObj)
      for guest in $scope.event.GuestsInEvent
        guestObj = {}
        hostName = '?'
        if guest.Host?
          if guest.Host.Name?
            hostName = guest.Host.Name
          else
            hostName = guest.Host.WindowsName
        guestObj['name'] = guest.Name + " " + hostName
        guestObj['type'] = 'guest'
        guestObj['id'] = guest.GuestID
        $scope.attendees.push(guestObj)
  )

  $scope.addUser = ->
    eventRoute.post('AddUser')

  $scope.removeUser = -> 
    eventRoute.post('RemoveUser')

  $scope.addGuest = ->
    modalInstance = $modal.open(
      templateUrl: 'guestModal.html'
      controller: 'GuestModalCtrl',
      resolve:
        eventID: ->
          eventID
    )
])

.controller('GuestModalCtrl', ['$scope','$modalInstance', 'Restangular', 'eventID'
  ($scope, $modalInstance, Restangular, eventID) ->
    $scope.add = (guestName) ->
      guest = 
        Name: guestName
        EventID: eventID
      Restangular.one('Events',eventID).post('AddGuest', guest)
      close()
    $scope.cancel = ->
      close()

    close = ->
      $modalInstance.dismiss('cancel')
])