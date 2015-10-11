component accessors=true output=false persistent=false extends="wheels"{

	public function init(){

    }

	public void function InitJSONRequest(){
		params.format = "json";
		provides("json");
		InitResponse();
    }

	public void function InitResponse(){
		request.response = new models.RestResponse().new();
    }

	private void function sendResponse() output="false" {

			// Build Response Struct to Ensure Only "API Contract" Elements are Delivered
			local.response = {
						  "success" : request.response.getSuccess()
						, "message" : request.response.getMessage()
						, "data"  	: request.response.getData()
						, "errors"	: request.response.getErrors()
			};

			// Set Response Status Code Header
			getPageContext().getResponse().setstatus(request.response.getStatusCode());

			// Log Responses
			//logResponse(responseData:local.response, additionaldata:{"authorization":params.headers.authorization});

			// Render Response
			renderWith(local.response);
		}

}