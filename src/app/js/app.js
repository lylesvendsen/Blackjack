'use strict';

/* App Module */

var gameApp = angular.module('gameApp', [
  'ngRoute',
  'gameControllers',
  'gameServices'
]);

gameApp.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
    when('/game', {
        templateUrl: 'partials/table.htm',
        controller: 'GameCtrl'
      }).
      otherwise({
        redirectTo: '/game'
      });
  }]);
