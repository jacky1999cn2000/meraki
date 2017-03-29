global class LeadWrapperIterable implements Iterator<List<LeadWrapper>>{

	/*
		an Iterable class for List<LeadWrapper>, so we can iterate the entire list, and return corresponding list via next() and previous()
	*/

	List<LeadWrapper> entireList {get;set;}
	List<LeadWrapper> returnList {get;set;}
	Integer currentIndex {get;set;}
	Integer pageSize {get;set;}

	public LeadWrapperIterable(List<LeadWrapper> leadWrapperList) {
		returnList = new List<LeadWrapper>();
		entireList = leadWrapperList;
		pageSize = 10;
		currentIndex = 0;
	}

	global Boolean hasNext(){
		if(currentIndex >= entireList.size()){
			return false;
		}else{
			return true;
		}
	}

	global Boolean hasPrevious(){
		if(currentIndex <= pageSize){
			return false;
		}else{
			return true;
		}
	}

	global List<LeadWrapper> next(){

		System.debug('***next');

		returnList.clear();

		Integer startIndex;
		Integer size = entireList.size();

		if(hasNext()){
			if((currentIndex + pageSize) >= size){
				startIndex = currentIndex;
				currentIndex = size;
			}else{
				startIndex = currentIndex;
				currentIndex = currentIndex + pageSize;
			}

			System.debug('***startIndex '+startIndex);
			System.debug('***currentIndex '+currentIndex);

			for(Integer i=startIndex; i<currentIndex; i++){
				returnList.add(entireList[i]);
			}
		}

		return returnList;
	}

	global List<LeadWrapper> previous(){

		System.debug('***previous');

		returnList.clear();

		Integer startIndex;
		Integer size = entireList.size();

		if(hasPrevious()){
			if(currentIndex == size){
				if(Math.mod(size, pageSize) > 0){
					currentIndex = size - Math.mod(size, pageSize);
					startIndex = currentIndex - pageSize;
				}else{
					currentIndex = size - pageSize;
					startIndex = currentIndex - pageSize;
				}
			}else{
				currentIndex = currentIndex - pageSize;
				startIndex = currentIndex - pageSize;
			}

			System.debug('***startIndex '+startIndex);
			System.debug('***currentIndex '+currentIndex);

			for(Integer i=startIndex; i<currentIndex; i++){
				returnList.add(entireList[i]);
			}
		}

		return returnList;
	}
}
