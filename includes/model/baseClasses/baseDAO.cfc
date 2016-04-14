component accessors=true {

	property name="fieldNamesToExclude" default="fieldNames";

	// Ben Nadel: http://www.bennadel.com/blog/149-ask-ben-converting-a-query-to-a-struct.htm
	private any function queryToStruct(required query query,boolean row=false ) {
		local.struct = structNew();
		if ( arguments.row ) {
			local.fromIndex = arguments.row;
			local.toIndex = arguments.row;
		} else {
			local.fromIndex = 1;
			local.toIndex = arguments.query.recordcount;
		}
		local.columns = listToArray(arguments.query.columnlist);
		local.columnCount = arrayLen(local.columns);
		local.dataArray = arrayNew(1);
		for ( local.rowIndex = local.fromIndex; local.rowIndex LTE local.toIndex; local.rowIndex = (local.rowIndex + 1) ) {
			ArrayAppend( local.dataArray, StructNew() );
			local.dataArrayIndex = arrayLen( local.dataArray );
			for ( local.columnIndex = 1 ; local.columnIndex LTE local.columnCount ; local.columnIndex = (local.columnIndex + 1) ) {
				local.columnName = local.columns[local.columnIndex];
				local.dataArray[local.dataArrayIndex][local.columnName] = arguments.query[local.columnName][local.rowIndex];
			}
		}
		if ( arguments.row ) {
			return local.dataArray[1];
		} else {
			return local.dataArray;
		}
	}

	private array function queryToBeanArray(required query qry, required string beanName){
		var beanArray = [];
		if(qry.recordCount eq 0)
			beanArray = [variables.beanFactory.getBean(beanName)];
		else{
			for(var row in qry){
				var bean = variables.beanFactory.getBean(beanName);
				bean.set(row);
				arrayAppend(beanArray,duplicate(bean));
			}
		}
		return beanArray;
	}

	//Validates Order by clauses. In each pair, the first must be a valid columnname, and the second must be either asc or desc.
	private string function validateOrderBy(required string orderBy){
		var returnVar = "";
		for(var i=1 ; i lte listLen(orderBy,','); i++){
			var orderPair = listGetAt(orderBy,i);
			if(listLen(orderPair, " ") eq 2
				AND listFindNoCase(variables.columnlist,listFirst(orderPair,' '))
				AND listFindNoCase('asc,desc',listLast(orderPair,' '))
				){
				returnVar = listAppend(returnVar,orderPair);
			}
		}
		if(len(returnVar) gt 0)
			return "order by " & returnVar;
		else
			return "";
	}

}
