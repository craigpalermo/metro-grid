'use strict'


metroApp = angular.module('metroApp', [])


# load data from api, format it, then add it to scope
loadData = ($scope, $http, apiUrl, apiKey) ->
  console.log "Loading data..."

  $http(
    method: "get"
    url: "/GetPrediction"
  ).then( (response) ->
      stations = {}

      for train in response.data['Trains']
          # get location, line, and min of current train
          location = train['LocationName']
          line = train['Line']
          min = train['Min']

          # add current train's station to stations dict if not already
          if not (location of stations)
              stations[location] = {}

          # add cur line to cur train's station in station's dict
          if not (line of stations[location])
              stations[location][line] = {}

          # add cur train's destination and time
          stations[location][line][train['DestinationName']] = min

      # convert dictionary to list so we can order and filter results
      stationList = []

      for k,v of stations
          station = {'name': k, 'data': v}
          stationList.push station

      # hide loading spinner
      $('#loading-spinner').hide()

      # add list to scope
      $scope.stations = stationList

  , (response) ->
    console.log "Request failed"
    console.log response
  )


metroApp.controller 'StationListCtrl', ($scope, $http) ->
    # make initial call to retrieve and load data
    loadData($scope, $http)

    # reload data on an interval
    setInterval ->
      # make API call
      loadData($scope, $http)
    , 20000

