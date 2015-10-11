component accessors=true output=false persistent=false extends="_Model"{

/*
 * Player Game Status
 * 0 = Waiting
 * 1 = Active
 * 2 = Lost via Bust
 * 3 = Lost via Dealer
 * 4 = Win
 * 5 = Push
 * 6 = Hold (Auto on 21)
 **/

	public void function init(){

    }



    public any function new(numeric id=-1, string name="Player", numeric seat=0){

		this["id"] = arguments.id;
		this["name"] = arguments.name; // Should be moved to full player record
		this["seat"] = 0;
		this["game"] = {
			 "hand" = []
			,"status":0
			,"count":0
		};
		this["record"] = {
			 "games":0
			,"wins":0
			,"loses":0
			,"pushes":0
		};
		return this;
    }

    public any function clearHand(){
    	this.game.status = 0;
    	this.game.hand = [];

    }

    public any function enterGame(){
    	if(this.game.status == 0){
    		this.game.status = 1;
    	}
    }

    public any function addCard(required struct card, boolean isDeal=false){
     	if(this.game.status == 1){
     		arrayAppend(this.game.hand, arguments.card);
     		calcCards(arguments.isDeal);
     	}
    }



	public any function calcWin(numeric dealerCount=0){
		if(this.game.status == 1 || this.game.status == 6){
			this.record.games = this.record.games + 1;
			if(this.game.count > arguments.dealerCount || arguments.dealerCount > 21){
				// Win
				this.game.status = 4;
				this.record.wins = this.record.wins + 1;
			}else if(this.game.count == arguments.dealerCount){
				// Push
				this.game.status = 5;
				this.record.pushes = this.record.pushes + 1;
			}else{
				// Lost by Dealer's Hand'
				this.game.status = 3;
				this.record.loses = this.record.loses + 1;
			}
		}else if(this.game.status == 2){
			this.record.loses = this.record.loses + 1;
		}

    }


    public any function calcCards(boolean dealCalc=false){
		this.game.count = 0;
		local.aceIndex = 0;

		for(local.i=1;  local.i LTE arrayLen(this.game.hand); local.i++){
			this.game.count += this.game.hand[local.i].value;
			if(this.game.hand[local.i].value == 11){
				local.aceIndex = local.i;
			}
		}

		if(this.game.count > 21 && local.aceIndex == 0){
			this.game.status = 2;
		}else if(this.game.count > 21){
			// Turn Last Ace to 1
				this.game.hand[local.aceIndex].value = 1;
			// Recalc Count
				calcCards(arguments.dealCalc);
		}else if(this.game.count == 21){
			if(arguments.dealCalc){
				this.game.status = 4; // Auto Win When Dealt 21
			}else{
				this.game.status = 6; // Auto Stay On 21
			}
		}
    }


	public struct function getStatus(numeric playerIndex = 1, numeric activeplayerIndex=0, numeric gameState=0){
     	local.status = {
     		"id":this.game.status
     		,"mode":""
     		,"text":""
     	};

     	if(arguments.gameState != 4 || arguments.playerIndex != 1){
	     	switch(this.game.status){
				case 1:
	     			if(this.game.status == 1 && arguments.activeplayerIndex == arguments.playerIndex){
			     		local.status.mode = "go";
			     		if(arguments.playerIndex != 1){
			     			local.status.text = "Go!";
			     		}else{
			     			local.status.text = "Taking Cards";
			     		}
			     	}else if(this.game.status == 1 && arguments.activeplayerIndex > arguments.playerIndex){
			     		local.status.mode = "wait";
			     		if(arguments.playerIndex != 1){
			     			local.status.text = "Waiting...";
			     		}else{
			     			local.status.text = "Dealing...";
			     		}
			     	}else if(this.game.status == 1 && arguments.activeplayerIndex < arguments.playerIndex){
			     		local.status.mode = "hold";
			     		local.status.text = "Hold";
			     	}
	     		break;

	     		case 2:
	     			local.status.mode = "lost";
			     	local.status.text = "Bust";
	     		break;

	     		case 3:
	     			local.status.mode = "lost";
			     	local.status.text = "Lost";
	     		break;

	     		case 4:
	     			local.status.mode = "win";
			     	local.status.text = "Winner";
	     		break;

	     		case 5:
	     			local.status.mode = "lost";
			     	local.status.text = "Push";
	     		break;

	     		case 6:
	     			local.status.mode = "win";
			     	local.status.text = "Held on 21";
	     		break;
	     	}
   		}else{
   			local.status.mode = "win";
			local.status.text = "Game Over";
   		}


     	return local.status;
    }


}