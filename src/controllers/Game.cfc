/**
 * Game
 *
 * @author 34767
 * @date 10/7/15
 **/
component accessors=true output=false persistent=false extends="controller"{

	public function init(){
		super.init();
		filters("InitJSONRequest");
    }

    /*
    TODO
		Global
		* 	Check if game is active and player is part of the game could pass encrypted/hash of both for a key
			* Unencrypt or hash to compare
		* Create filter check if game was created
	*/
	public function new(){
		param params.players = 5;
		param params.decks = 3;
		local.game = new models.game()
						.new(
							 decks:min(val(params.decks),8)
							,players:min(val(params.players),5)
						); //Start New Game


		// TODO Persist Game Some How
		session.game = local.game;

		// Deal
		local.game.deal();

		request.response.data = local.game.getPublicValues();

		sendResponse();
    }


	public function clearTable(){

		// TODO Lookup Game Here
		local.game = session.game ;

		local.game.clearTable();
		local.game.deal(); // Deal

		request.response.data = local.game.getPublicValues();

		sendResponse();
    }



	public function deal(){

		// TODO Lookup Game Here
		local.game = session.game ;

		local.game.deal(); // Deal

		request.response.data = local.game.getPublicValues();
		sendResponse();
    }



	public function action(){
		param params.playerid = "-1";
		param params.do = "";

		local.game = session.game ;


		switch(params.do){
			case "hit" :
				local.game = local.game.hit(playerid:params.playerid);
			break;

			case "stay" :
				local.game = local.game.stay(playerid:params.playerid);
			break;

			default:
				local.do = "nothing";
		}


		request.response.data = local.game.getPublicValues();

		sendResponse();
    }


    public function dealerAction(){

		local.game = session.game ;

		// Dealer Go
		local.game = local.game.dealerAction();

		request.response.data = local.game.getPublicValues();

		sendResponse();
    }


	public function getGame(){

		 local.game = session.game;

		request.response.data = local.game.getPublicValues();

		sendResponse();
    }



	public function saveGame(){

		 local.game = session.game;

		request.response.data = local.game.getPublicValues();

		sendResponse();
    }




/* Pulls Full Game Info - Not For Production Use */
    public function getGameFull(){

		 local.game = session.game;

		request.response.data = local.game;

		sendResponse();
    }


}