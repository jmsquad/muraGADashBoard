component accessors=true {

	remote any function getIteratorFromBeanArray(required array beanArray){
		//convert arrayOfBeans back to query
		local.qry = getQueryFromBeanArray(beanArray);

		return createObject('component','mura.iterator.queryiterator').init().setQuery(local.qry);
	}

	public query function getQueryFromBeanArray(required array beanArray){
		local.beanProperties = getMetaData(beanArray[1]).properties;

		local.columns = "";
		local.types = "";

		for(local.col in local.beanProperties){
			local.columns = listAppend(local.columns,local.col.name);
			local.types = listAppend(local.types,local.col.type);
		}

		//correct type naming
		local.types = replaceNoCase(local.types,'string','varchar','all');
		local.types = replaceNoCase(local.types,'boolean','bit','all');
		local.types = replaceNoCase(local.types,'numeric','double','all');

		local.qry = queryNew(local.columns,local.types);

		for(local.bean in beanArray){
			queryAddRow(local.qry);
			for(local.col in local.columns){
				querySetCell(local.qry,local.col,local.bean.getValue(local.col));
			}
		}

		return local.qry;
	}

}
