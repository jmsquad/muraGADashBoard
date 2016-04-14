component accessors=true  {
	property array errors;

	public any function init(){
		variables.errors = arrayNew(1);
	}

	public any function set(required any data){
		var prop = "";

		if(isQuery(arguments.data) and arguments.data.recordcount){
			for(prop in arguments.data.columnlist){
				//exception for the case when "" comes in for a numeric value. Just skip it. (It happens with ID's)
				if(NOT (listFindNoCase('integer,numeric,float,double',getPropertyType(prop)) AND arguments.data[prop][1] eq "" ))
					setValue(prop,arguments.data[prop][1]);
			}
		}
		else{
			for(prop in structKeyList(arguments.data)){
				//exception for the case when "" comes in for a numeric value. Just skip it. (It happens with ID's)
				if(NOT (listFindNoCase('integer,numeric,float,double',getPropertyType(prop)) AND arguments.data[prop] eq "" ))
					setValue(prop,arguments.data[prop]);
			}
		}

		return this;
	}

	public any function setValue(string property, any value){
		if(structKeyExists(this,'set#property#')){
			try{
				return evaluate('set#property#(value)');
			}catch(any e){
				if(listFindNoCase('timestamp,date',getPropertyType(property)) AND len(value) eq 0){
					return;
				}
				writeDump("property=#property#");
				writeDump("value=");
				writeDump(value);
				writeDump(e);
				abort;
			}
		}
	}

	public any function getValue(string property){
		if(structKeyExists(this,'get#arguments.property#'))
			return evaluate('this.get#property#()');
		else
			return "";
	}

	public any function clearErrors(){
		variables.errors = [];
	}

	public boolean function hasErrors(){
		return arrayLen(variables.errors) gt 0;
	}

	public array function getErrors(){
		return errors;
	}

	public any function setError(required string message, any exception){
		var errStruct = {};
		errStruct.message = arguments.message;
		if(isDefined('arguments.exception')){
			errStruct.exception = arguments.exception;
		}
		else{
			errStruct.exception = "";
		}
		arrayAppend(variables.errors,errStruct);
	}

	public struct function getAllValues(){
		local.returnVar = {};

		local.beanProperties = getMetaData(this).properties;

		for(local.col in local.beanProperties){
			if(isSimpleValue(this.getValue(local.col.name)))
				local.returnVar[local.col.name] = this.getValue(local.col.name);
		}

		return local.returnVar;
	}

	private string function getPropertyType(required string property){
		local.props = getMetaData(this).properties;
		for(local.prop in local.props){
			if(local.prop.name eq arguments.property){
				return local.prop.type;
			}
		}
		return "notFound";
	}

}

