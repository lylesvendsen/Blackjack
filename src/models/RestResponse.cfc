component accessors=true output=false persistent=false extends="_Model"{

/*
 * Player Game Status
 * 0 = Waiting
 * 1 = Active
 * 2 = Busted/Lost
 * 3 = Lost
 * 4 = Win
 **/

	public void function init(){

    }



    public any function new(boolean success=1, string message="", any data={}, errors=[], numeric statuscode=200){

		this["success"] = arguments.success;
		this["message"] = arguments.message;
		this["data"] = arguments.data;
		this["errors"] = arguments.errors;
		this["statuscode"] = arguments.statuscode;

		return this;
    }


}