/**
 * Created by gerry on 9/6/2022.
 */

public with sharing virtual class DomainObject extends fflib_SObjectDomain
{
	public DomainObject(List<sObject> sObjectList) {
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new DomainObject(sObjectList);
		}
	}

	public void setFilter(Set<String> recordTypeDevNames, List<SObject> returnListOverride, Map<Id, sObject> returnMapOverride) {
		if (records.isEmpty()) return;
		Set<String> recordTypeIdFilters = getFilteredRecordTypes(recordTypeDevNames);
		if (records != null) {
			for (sObject o : records) {
				Object obj = o.get('RecordTypeId');
				if(obj ==null) continue;
				String sObjRecType = obj.ToString();
				if (recordTypeIdFilters.contains(sObjRecType)) {
					returnListOverride.add(o);
				}
			}
		}
		if (existingRecords != null) {
			for (sObject o : existingRecords.values()) {
				Object obj = o.get('RecordTypeId');
				if(obj ==null) continue;
				String sObjRecType = obj.ToString();
				if (recordTypeIdFilters.contains(sObjRecType)) {
					returnMapOverride.put(o.Id, o);
				}
			}
		}
	}

	private Set<String> getFilteredRecordTypes(Set<String> recordTypeDevNames)
	{
		Set<String> recordTypeIdFilters = new Set<String>();
		new Set<String>();
		if (records != null && records.size() > 0) {
			Map<String, RecordTypeInfo> recordTypeInfoMap = (records[0].getSObjectType().getDescribe()).getRecordTypeInfosByDeveloperName();
			for (String recordTypeDevName : recordTypeDevNames) {
				Id recordTypeId = recordTypeInfoMap.get(recordTypeDevName).getRecordTypeId();
				if (!recordTypeIdFilters.contains(recordTypeId))
					recordTypeIdFilters.add(recordTypeId);
			}
		}
		if (existingRecords != null) {
			List<SObject> oldValuesList = new List<SObject>(existingRecords.values()); // gotta get first one and cant from map without a key or iterating
			Map<String, RecordTypeInfo> recordTypeInfoMap = (oldValuesList[0].getSObjectType().getDescribe()).getRecordTypeInfosByDeveloperName();
			for (String recordTypeDevName : recordTypeDevNames) {
				Id recordTypeId = recordTypeInfoMap.get(recordTypeDevName).getRecordTypeId();
				if (!recordTypeIdFilters.contains(recordTypeId))
					recordTypeIdFilters.add(recordTypeId);
			}
		}
		return recordTypeIdFilters;
	}
}