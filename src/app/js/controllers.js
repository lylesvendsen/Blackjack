'use strict';

/* Controllers */

var gameControllers = angular.module('gameControllers', []);

gameControllers.controller('GameCtrl', ['$scope', 'Game', 'Player', 'Dealer', '$timeout', 'Table',
 function($scope, Game, Player, Dealer, $timeout, Table) {
		$scope.tableStatus = 0;
		$scope.deckOptions = [{name:'1 Deck', value:1}, {name:'2 Decks', value:2}, {name:'3 Decks', value:3},{name:'4 Decks', value:4},{name:'5 Decks', value:5}];
		$scope.playerOptions = [{name:'1 Player', value:1}, {name:'2 Players', value:2}, {name:'3 Players', value:3},{name:'4 Players', value:4},{name:'5 Players', value:5}];
		$scope.decks = $scope.deckOptions[2];
		$scope.players = $scope.playerOptions[4];
	
	// Game Resources
	  	$scope.hit = function(playerid) {
	  		$scope.game = Player.action({action:'hit',playerid:playerid});
	    };
	    
	    $scope.stay = function(playerid) {
	  		$scope.game = Player.action({action:'stay',playerid:playerid});
	    };
	    
	    $scope.dealerGo = function() {
	  		$scope.game = Dealer.go();
	    };
	
	    $scope.newDeal = function() {
	  		$scope.game = Table.newDeal({action:'clearTable'});
	    };
    
	    
	    $scope.newGame = function() {
	    	$scope.tableStatus = 1;
	    	$scope.game = Game.get({action:'new',players:$scope.players.value,decks:$scope.decks.value});
	     };
    
    // Set Dealer Action Watch Process
	    $scope.$watch("game.data.table.activeplayerIndex", function(newValue, oldValue) {
	        var timeoutPromise;
	        var dealerActionDelay = 2000; 
	    	if(newValue && newValue == 1 &&$scope.game.data.state == 2 ){
	    		$timeout.cancel(timeoutPromise);  // Cancel Timeout
	    	     timeoutPromise = $timeout(function(){   //Set Dealer Action Timeout
	    	    	 $scope.dealerGo();
	    	     },dealerActionDelay );
	    	}
	      });
    

		// Load New Game
	    	//$scope.newGame();
	  
  
 }]);