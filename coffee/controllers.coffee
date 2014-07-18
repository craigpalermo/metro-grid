'use strict'

metroApp = angular.module('metroApp', [])

# function to alternate API keys to avoid rate limiting
getApiKey = ->
  if Math.floor(Math.random() * 2) + 1 is 1
    'yvccw5n4uyw4z8fggkex2h5t'  # wmata watch
  else
    '8yr3spbddv9eu6tgkxvu9kay'  # wmata watch 2

loadData = ($scope, $http, apiUrl) ->
  console.log "Loading data..."
  $http.jsonp(apiUrl).success (data, status) ->
      stations = {}

      for train in data['Trains']
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


metroApp.controller 'StationListCtrl', ($scope, $http) ->
    # get API key and construct query URL
    apiKey = getApiKey()
    apiUrl = "http://api.wmata.com/StationPrediction.svc/json/GetPrediction/All?api_key=#{apiKey}&callback=JSON_CALLBACK"

    loadData($scope, $http, apiUrl)

    # reload data on an interval
    setInterval ->
      # make API call
      loadData($scope, $http, apiUrl)
    , 20000

