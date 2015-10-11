component accessors=true output=false persistent=false extends="_Model"{

	public void function init(){

    }


    public any function new(numeric decks=1, boolean shuffle=true){
		this["decks"] = arguments.decks;
		this["cards"] = [];
		this["discardIndex"] = 0;
		this["shuffleIndex"] = 0;

		local.arySuits = ["C","S","H","D"];
		local.aryFace = ["J","Q","K","A"];

		for(local.deckCount=1;  local.deckCount LTE this.decks; local.deckCount++){
			for(local.suit IN local.arySuits){
				for(local.i=2;  local.i LTE 14; local.i++){

					if(local.i == 14){
						local.value = 11;
						local.face = local.aryFace[local.i-10];
					}else if(local.i > 10){
						local.value = 10;
						local.face = local.aryFace[local.i-10];
					}else{
						local.value = local.i;
						local.face = local.i;
					}

					// Add Card
					arrayAppend(this.cards, cardNew(suit:local.suit, value:local.value, face:local.face)
					);
				}
			}
		}

		this["deckcount"] = arrayLen(this.cards);

		if(arguments.shuffle){
			// Shuffle Deck
			this.shuffle();
		}
		return this;
    }

     public struct function cardNew(string suit="", numeric value=0, string face=0){
    		return	 {
					  "suit":arguments.suit
					, "value":arguments.value
					, "face":arguments.face
				};
     }

    public any function shuffle(numeric shuffleCount=4){
    	for(local.i=1;  local.i LTE arguments.shuffleCount; local.i++){
			CreateObject("java",  "java.util.Collections").Shuffle(this.cards);
    	}

		// Set Shuffle Index
		setShuffleIndex();
		return this;
    }


    private void function setShuffleIndex(){
    	local.max = this.deckcount - 20;
    	local.min = local.max - int(local.max * .1);

    	local.randSeed = right(GetTickCount(), 6);

    	randomize(local.randSeed);

    	this["shuffleIndex"] = randrange(local.min, local.max);

    }


    public struct function deal(){
			this.discardIndex++;
			if(this.discardIndex <= this.deckcount){
				local.card = duplicate(this.cards[this.discardIndex]);
			}else{
				local.card = cardNew();
			}

    		return local.card;
    }

}