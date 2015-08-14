(function() {
  'use strict';
  var loadData, metroApp;

  metroApp = angular.module('metroApp', []);

  loadData = function($scope, $http, apiUrl, apiKey) {
    console.log("Loading data...");
    return $http({
      method: "get",
      url: "/GetPrediction"
    }).then(function(response) {
      var i, k, len, line, location, min, ref, station, stationList, stations, train, v;
      stations = {};
      ref = response.data['Trains'];
      for (i = 0, len = ref.length; i < len; i++) {
        train = ref[i];
        location = train['LocationName'];
        line = train['Line'];
        min = train['Min'];
        if (!(location in stations)) {
          stations[location] = {};
        }
        if (!(line in stations[location])) {
          stations[location][line] = {};
        }
        stations[location][line][train['DestinationName']] = min;
      }
      stationList = [];
      for (k in stations) {
        v = stations[k];
        station = {
          'name': k,
          'data': v
        };
        stationList.push(station);
      }
      $('#loading-spinner').hide();
      return $scope.stations = stationList;
    }, function(response) {
      console.log("Request failed");
      return console.log(response);
    });
  };

  metroApp.controller('StationListCtrl', function($scope, $http) {
    loadData($scope, $http);
    return setInterval(function() {
      return loadData($scope, $http);
    }, 20000);
  });

}).call(this);
