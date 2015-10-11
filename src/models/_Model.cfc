component accessors=true output=false persistent=false{

	public any function onMissingMethod(required string missingMethodName, struct missingMethodArguments={}){
		local.varname = "";
		local.name = arguments.missingMethodName;
		local.args = arguments.missingMethodArguments;
		local.var = _getMethodVar(local.name);

		if(local.var.prefix == "get"){
			param name="this.#local.var.name#" default="";
			_appendDynamicMethods(_dynamicGet, local.name);
			return this[local.var.name];
		}else if(local.var.prefix == "set"){
			_appendDynamicMethods(_dynamicSet, local.name); // Set to dynamic function
			this[local.var.name] = local.args[1];
		}else if(local.var.prefix == "is" || local.var.prefix == "has"){
			param name="this.#local.var.name#" default="false";
			_appendDynamicMethods(_dynamicIsHas, local.name); // Set to dynamic function
			return _getBoolean(this[local.var.name]);
		}
	}



	private struct function _getMethodVar(string methodName=""){
		local.name = arguments.methodName;
		local.prefixThree = left(arguments.methodName, 3);
		local.results = {
			  name=local.name
			, prefix=""
		};

		if(local.prefixThree == "get" || local.prefixThree == "set" || local.prefixThree == "has"){
			local.results.prefix = local.prefixThree;
			local.results.name = right(local.name, len(local.name)-3);
		}else if(left(local.prefixThree, 2) == "is"){
			local.results.prefix = "is";
			local.results.name = right(local.name, len(local.name)-2);
		}

		return local.results;
	}


	private any function _dynamicGet(){
		local.var =  _getMethodVar(getFunctionCalledName());
		param name="this.#local.var.name#" default="";
		return this[local.var.name];
	}

	private void function _dynamicSet(required any value){
		local.var =  _getMethodVar(getFunctionCalledName());
		this[local.var.name] = arguments.value;
	}

	private boolean function _dynamicIsHas(){
		local.var =  _getMethodVar(getFunctionCalledName());
		return  _getBoolean(this[local.var.name]);
	}

	private boolean function _dynamicFunction(){
		local.var =  getFunctionCalledName();
		return variables["_" & local.var];
	}

	private boolean function _getBoolean(required any value){
		if(isBoolean(arguments.value) && arguments.value){
			return true;
		}else{
			return false;
		}
	}


	private void function _appendDynamicMethods(required any dynamicFunction, required string method){
		param variables.appendDynamicMethodList = false;

		// Create Dynamic Method
			this[arguments.method] = dynamicFunction;

		if(variables.appendDynamicMethodList && !arrayFindNoCase(this.dynamicMethods, arguments.method)){
			// Append To Dynamic Method List
			arrayAppend(this.dynamicMethods, arguments.method);
		}
	}


	private void function _appendJavaClassError(string className={}, string method="", any catchError={detail:""}){
		param this.javaClassErrors = [];

		arrayAppend(this.javaClassErrors, {
			className = arguments.className
			,classMethod = arguments.method
			,detail = arguments.catchError.detail
		});

	}

	public struct function getProperties(){
		return this;
	}
}