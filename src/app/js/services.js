'use strict';

/* Services */

	// Game Service
		var gameServices = angular.module('gameServices', ['ngResource']);
		
		gameServices.factory('Game', ['$resource',
		  function($resource){
		    return $resource('/game/:action', {}, {
		    	get: {method:'GET', params:{}, isArray:false}
		    });
		  }]);
		
		gameServices.factory('Player', ['$resource',
		  function($resource){
		    return $resource('/game/action/do/:action/playerid/:playerid', {}, {
		    	action: {method:'GET', params:{}, isArray:false}
		    });
		  }]);
		                  
		gameServices.factory('Dealer', ['$resource',
  		  function($resource){
  		    return $resource('/game/dealeraction', {}, {
  		    	go:{method:'GET', params:{}, isArray:false}
  		    });
  		  }]);
		
		gameServices.factory('Table', ['$resource',
    		  function($resource){
    		    return $resource('/game/:action', {}, {
    		    	newDeal:{method:'GET', params:{}, isArray:false}
    		    });
    		}]);
		                      		