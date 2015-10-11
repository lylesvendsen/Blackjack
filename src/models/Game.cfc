
component accessors=true output=false persistent=false extends="_Model"{

	/*
	 * 	Game States
	 * 0 = Not Started
	 * 1 = Active
	 * 2 = Active - Dealer's Active
	 * 3 = Play Complete
	 * 4 = Game Ended
	 **/


	// TODO Check For 21 on deal for dealer (Auto Loss)

	public void function init(){

    }


    public any function new(numeric decks=3, numeric players=0){
    	this["gameid"] = createUuid();
		this["decks"] = arguments.decks;
		this["shoe"] = {};
		this["state"] = 0;
		this["table"] = {
			"activeplayerIndex" = 0
			,"players" : []
		};

		shuffleCards();

		// Add Dealer to Players
		addPlayer(0,"Dealer",1);

		for(local.i=1;  local.i LTE min(arguments.players, 5); local.i++){
			addPlayer(playerid:local.i, name:"Player #local.i#", seat:local.i+1); // Add Default Players
		}

		return this;
    }



	public any function shuffleCards(){
		this.shoe = new deck().new(decks:this.decks);
		this.state = 0;

		return this;
    }


    public any function addPlayer(required numeric playerid, name="Player", numeric seat=0){
    	// TODO this should do a look up



    	// Checks if the seat is taken
	    	local.seatTaken = false;
	    	for(local.player IN this.table.players){
				if(arguments.seat == local.player.seat){
					local.seatTaken = true;
				}
			}

		// Add player If game has not started
	    	if(this.state == 0 && !local.seatTaken){
				local.player = new gameplayer().new(argumentCollection:arguments);
				local.player.id = arguments.playerid;
				local.player.seat = arguments.seat;

				arrayAppend(this.table.players,  local.player);

				sortPlayer();  // This maintains deal order by seat
	    	}

		return this;
    }


    private void function sortPlayer(){

		local.playerSeats = [{},{},{},{},{},{}];
		local.players = [];

			if(this.state == 0){
				for(local.player IN this.table.players){
					local.playerSeats[local.player.seat] = local.player;
				}

				for(local.player IN local.playerSeats){
					if(structKeyExists(local.player, "id")){
						arrayAppend(local.players,  local.player);
					}
				}

				this.table.players = local.players;
			}
    }



    public any function hit(required numeric playerid){
    	// TODO check if valid player for game

		if((this.state == 1 || this.state == 2)  && this.table.activeplayerIndex > 0){
			local.activePlayer = this.table.players[this.table.activeplayerIndex];

			if(arguments.playerid ==local.activePlayer.id && local.activePlayer.game.status == 1 ){
				local.activePlayer.addCard(this.shoe.deal());
			}else{
				// Throw Exception For Invalid Action/Player
				writeDump("Invalid Player Action");
				abort;
			}

			// Test Player Status
				if(local.activePlayer.game.status > 1){
					// Advance Active Player
						advanceActivePlayer();
				}
		}else{
			// Throw Exception For Invalid State
			writeDump("Invalid Game State");
				abort;
		}

		return this;
    }


	public any function stay(required numeric playerid){
    	// TODO check if valid player for game

		if((this.state == 1) && this.table.activeplayerIndex > 0){
			local.activePlayer = this.table.players[this.table.activeplayerIndex];

			if(arguments.playerid ==local.activePlayer.id && local.activePlayer.game.status == 1){
				// Advance Active Player
						advanceActivePlayer();
			}else{
				// Throw Exception For Invalid Action/Player
				writeDump("Invalid Player Action");
				abort;
			}
		}else{
			advanceActivePlayer();
			// Throw Exception For Invalid State
			//writeDump("Invalid Game State");
			//abort;
		}

		return this;
    }

	public any function dealerAction(){
    	// TODO check if valid player for game
		if(this.state == 2 && this.table.activeplayerIndex == 1){
			local.dealer = this.table.players[1];

			if(local.dealer.game.count < 17){
				hit(local.dealer.id);

				if(local.dealer.game.count >= 17){
					dealerAction();
				}
			}else{
				// Stay
				this.state = 3;
				calcWinners();
			}
		}else if(this.table.activeplayerIndex == 0){
			calcWinners();
		}

		return this;
    }


	 private any function calcWinners(){
	 		if(this.state == 3){
    			// Set Win Player Statuses
    			local.dealer = this.table.players[1];
    			for(local.player IN this.table.players){
    				if(local.player.id != local.dealer.id){
    					// Calculate The Winners
    					local.player.calcWin(local.dealer.game.count);
    				}
    			}
    			// End Game
    			this.state = 4;
	 		}
	 }


	  private any function checkActivePlayers(){
	  		// Check If There Are Any Players Left
	 		local.endGame = true;
			local.dealer = this.table.players[1];

			for(local.player IN this.table.players){
   				if(local.player.id != local.dealer.id && local.player.game.status ==  1){
   					// Someone is Still in it To Win it!
   					local.endGame = false;
   				}
   			}

   			if(local.endGame){
   				// Sorry Game Over
				this.state = 3;
   				calcWinners();
   			}
	 }

    public any function advanceActivePlayer(){
    	if(this.state == 1){
    		if(this.table.activeplayerIndex > 1){
    			--this.table.activeplayerIndex; // Decrement Player Index;
    		}

			if(this.table.activeplayerIndex == 1 && this.state == 1){
				this.state = 2;
				// Dealer's Turn
						checkActivePlayers();


			}else if(this.table.activeplayerIndex > 1 && this.table.players[this.table.activeplayerIndex].game.status > 1){
   				// Advance Again - Active Player Can Not Play
   				advanceActivePlayer();
   			}

		}else{
			// Throw Exception For Invalid State
			//writeDump("Invalid Game State");
			//abort;
		}
		return this;
    }




    public any function deal(){
    	// Deal if game state is 0
    	if(this.state == 0){
    		local.players = this.table.players;
    		local.playerCount = arrayLen(local.players);

			// Active Players
			activatePlayers();

			// Deal Two Cards Per Player
    		for(local.i=1;  local.i LTE 2; local.i++){
    			// Dealing from the end of the array to the begining to deal to the dealer last
	    		for(local.p=local.playerCount;  local.p GT 0; --local.p){
					this.table.players[local.p].addCard(this.shoe.deal(), true);
	    		}
    		}


			if(this.table.players[1].game.count == 21){
				// Dealer was dealt 21 Game Over. Check Up His Sleeves!
				this.state = 3;
   				calcWinners();
			}

    	}

		// Start Game
		startGame();

		return this;
    }


     public any function clearTable(){
    	// Clear if game state is 3

    	// Add player If game has not started
    	if(this.state == 4){
    		// Clear Hands
    		local.players = this.table.players;
    		for(local.player IN local.players){
				local.player.clearHand();
	    	}

	    	// New/Shuffle Deck(s)
	    	if(this.shoe.shuffleIndex < this.shoe.discardIndex){
				shuffleCards();
			}

	    	this.table.activeplayerIndex = 0;
			this.state = 0;

    	}
		return this;
    }

    private any function activatePlayers(){
    	// Add player If game has not started
    	if(this.state == 0){
    		local.players = this.table.players;
    		for(local.player IN local.players){
				local.player.enterGame();
	    	}
    	}

		return this;
    }

	public any function startGame(){
		if(this.state == 0){
			this.table.activeplayerIndex = arrayLen(this.table.players)+1;
			this.state = 1;
			advanceActivePlayer();
		}

		return this;
    }


	public any function getPublicValues(){

		local.players = duplicate(this.table.players);


		if(this.state < 2 && arrayLen(local.players) && arrayLen(local.players[1].game.hand)){
			local.players[1].game.hand[2] = this.shoe.cardNew();
			local.players[1].game.count = local.players[1].game.hand[1];
			local.players[1].record = {};
		}

		// Append Status Struct
		local.playerindex = 0;
   		for(local.player IN local.players){
   			local.playerindex = local.playerindex + 1;
			local.player.game.status = local.player.getStatus(local.playerindex, this.table.activeplayerIndex, this.state);
    	}

		return {
			"gameid":this.gameid
			,"table":{
					"players":local.players
					,"activeplayerIndex":this.table.activeplayerIndex
				}
			,"decks":this.decks
			,"state":this.state
			,"shoe":{
				 "deckcount" = this.shoe.deckcount
				,"discardIndex" =  this.shoe.discardIndex
				,"shuffleIndex" =  this.shoe.shuffleIndex
			}
		};
    }


}