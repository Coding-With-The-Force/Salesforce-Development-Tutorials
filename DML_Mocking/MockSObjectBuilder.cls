public with sharing class MockSObjectBuilder {

	public SObjectType mockType {get; private set;}

	private String starterSObject;

	private static Integer idCount = 1;

	private Map<SObjectField, String> fieldToValue = new Map<SObjectField, String>();
	private Map<ChildRelationship, List<String>> relationshipToChild = new Map<ChildRelationship, List<String>>();
	private Map<String, String> parentsByLabels = new Map<String, String>();

	//Initialize a builder with an sobject type
	public MockSObjectBuilder(SObjectType type) {
		mockType = type;
	}

	//Initialize a builder with an existing sobject
	public MockSObjectBuilder(SObject starterObject) {
		mockType = starterObject.getSObjectType();
		starterSObject = JSON.serialize(starterObject);
	}

	//Set a normal field on the sobject using the schema field name
	public MockSObjectBuilder setField(SObjectField field, String value) {
		fieldToValue.put(field, value);
		return this;
	}

	//Set a normal field on the sobject using the string field name
	public MockSObjectBuilder setField(String field, String value) {
		SObjectField describeField = getDescribeFieldFromString(field);
		setField(describeField, value);
		return this;
	}

	//Set a date field on the sobject using the string field name
	public MockSObjectBuilder setField(String field, Date value) {
		SObjectField describeField = getDescribeFieldFromString(field);
		String stringifiedValue = trimQuotes(JSON.serialize(value));
		setField(describeField, stringifiedValue);
		return this;
	}

	//Set a datetime field on the sobject using the string field name
	public MockSObjectBuilder setField(String field, Datetime value) {
		SObjectField describeField = getDescribeFieldFromString(field);
		String stringifiedValue = trimQuotes(JSON.serialize(value));
		setField(describeField, stringifiedValue);
		return this;
	}

	//Trim the last quote from json values when building strings
	private String trimQuotes(String longValue) {
		return longValue.substring(1, longValue.length() - 1);
	}

	//Parse the json string for a fields value using schema field name
	public String getField(SObjectField field) {

		String value = '';

		if (fieldToValue.containsKey(field)) {
			value = fieldToValue.get(field);
		}
		return value;
	}

	//Parse the json string for a fields value using string field name
	public String getField(String field) {
		SObjectField describeField = getDescribeFieldFromString(field);
		return getField(describeField);
	}

	//Get the schema value from a string field name
	private SObjectField getDescribeFieldFromString(String field) {
		return mockType.getDescribe().fields.getMap().get(field);
	}

	//Convenience function to set a new id on an sobject being built
	public MockSObjectBuilder setId() {
		setField('Id', getMockId());
		return this;
	}

	//Get a mock id of the instantiated type
	public String getMockId() {
		return getMockId(mockType);
	}

	//Utility method to get an id of a given type
	public static String getMockId(SObjectType objectType) {

		String nextIdCount = String.valueOf(idCount++);

		return objectType.getDescribe().getKeyPrefix()
				+ getFillerZeros(nextIdCount)
				+ nextIdCount;
	}

	//Determine how many 0s are needed to pad the id for the correct length of id
	private static String getFillerZeros(String nextIdCount) {
		return '0'.repeat(12-nextIdCount.length());
	}

	//Gets a schema child relationship given its string name
	public ChildRelationship getChildRelationship(String childLabel) {

		ChildRelationship relationship;

		for (ChildRelationship childRel : mockType.getDescribe().getChildRelationships()) {
			if (childRel.getRelationshipName() == childLabel) {
				relationship = childRel;
			}
		}

		return relationship;
	}

	//Sets a parent object and id for the current build object
	public MockSObjectBuilder setParent(String parentLabel, SObject parent) {

		if (parent != null) {

			String idKey = getIdFieldNameFromRelationshipName(parentLabel);
			if (getDescribeFieldFromString(idKey) != null) {
				parentsByLabels.put(parentLabel, JSON.serialize(parent));
				setParentId(parentLabel, parent);
			}
		}

		return this;
	}

	//Sets up the parent id from a parent object label
	private void setParentId(String parentLabel, SObject parent) {
		if (parent != null && parent.Id != null) {
			String idKey = getIdFieldNameFromRelationshipName(parentLabel);
			setField(idKey, parent.Id);
		}
	}

	//Determines methodology for naming parent id field: '__c' for custom, 'Id' for standard
	private String getIdFieldNameFromRelationshipName(String parentLabel) {

		String idKey = '';
		if (parentLabel.contains('__r')) {
			idKey = parentLabel.substring(0, parentLabel.length() - 1) + 'c';
		} else {
			idKey = parentLabel + 'Id';
		}
		return idKey;
	}

	//Sets a child object for a string child relationship name
	public MockSObjectBuilder setChild(String childLabel, SObject child) {
		return setChild(getChildRelationship(childLabel), JSON.serialize(child));
	}

	//Sets multiple children for a string child relationship name
	public MockSObjectBuilder setChildren(String childLabel, List<SObject> children) {
		List<String> serializedChildren = new List<String>();
		for (SObject child : children) {
			serializedChildren.add(JSON.serialize(child));
		}
		return setChildren(getChildRelationship(childLabel), serializedChildren);
	}

	//Sets a serialized (string-form) child from a child relationship string name
	public MockSObjectBuilder setChild(String childLabel, String serializedChild) {
		return setChild(getChildRelationship(childLabel), serializedChild);
	}

	//Sets multiple serialized (string-form) children from a child relationship string name
	public MockSObjectBuilder setChildren(String childLabel, List<String> serializedChildren) {
		return setChildren(getChildRelationship(childLabel), serializedChildren);
	}

	//Sets multiple children for a schema child relationship name
	public MockSObjectBuilder setChild(ChildRelationship childRel, String serializedChild) {
		setChildren(childRel, new List<String>{serializedChild});
		return this;
	}

	//Sets multiple children for a schema child relationship name
	public MockSObjectBuilder setChildren(ChildRelationship childRel, List<String> serializedChildren) {
		if (!relationshipToChild.containsKey(childRel)) {
			relationshipToChild.put(childRel, new List<String>());
		}
		for (String child : serializedChildren) {
			relationshipToChild.get(childRel).add(child);
		}
		return this;
	}

	//Builds the currently building sobject
	public SObject build() {

		String jsonSObject = getSerializedSObject();
		SObject mockObject = (SObject) JSON.deserialize(jsonSObject, SObject.class);

		return mockObject;
	}

	//Returns the string-form of the currently uilding object
	public String getSerializedSObject() {

		String jsonSObject = '';

		if (starterSObject == null) {
			jsonSObject = JSON.serialize(mockType.newSObject());
		} else {
			jsonSObject = starterSObject;
		}

		jsonSObject = openJson(jsonSObject)
				+ appendJsonFields()
				+ appendParents()
				+ appendChildRelationships()
				+ closeJson();

		return jsonSObject;
	}

	//JSON parsing function
	//Opens the json object
	private String openJson(String jsonSObject) {
		return jsonSObject.substring(0, jsonSObject.length() - 1);
	}

	//JSON parsing function
	//Appends a field to the JSON object
	private String appendJsonFields() {
		String fieldsToAppend = '';
		for (SObjectField field : fieldToValue.keySet()) {
			fieldsToAppend += ',"' + field + '":"' + fieldToValue.get(field) + '"';
		}
		return fieldsToAppend;
	}

	//JSON parsing function
	//Appends a parent object to the JSON object
	private String appendParents() {
		String parentsToAppend = '';
		for (String parentLabel : parentsByLabels.keySet()) {
			parentsToAppend += ',"';
			parentsToAppend += parentLabel;
			parentsToAppend += '":';
			parentsToAppend += parentsByLabels.get(parentLabel);
		}
		return parentsToAppend;
	}

	//JSON parsing function
	//Appends children objects to the JSON object
	private String appendChildRelationships() {
		String childrenToAppend = '';
		for (ChildRelationship relationship : relationshipToChild.keySet()) {
			List<String> serializedChildren = relationshipToChild.get(relationship);
			childrenToAppend += getRelationshipName(relationship)
					+ getRelationshipHeaderInfo(serializedChildren.size())
					+ getRecordStart()
					+ getChildRecords(serializedChildren)
					+ closeChildList();
		}
		return childrenToAppend;
	}

	//JSON parsing function
	//Appends a parent object to the JSON object
	private String getRelationshipName(ChildRelationship relationship) {
		return ',"' + relationship.getRelationshipName() + '":{';
	}

	//JSON parsing function
	//Appends a child relationship header
	private String getRelationshipHeaderInfo(Integer childCount) {
		return'"totalSize":' + childCount + ',"done":true,';
	}

	//JSON parsing function
	//Appends the beginning of the child list
	private String getRecordStart() {
		return '"records":[';
	}

	//JSON parsing function
	//AAppends the list of child records
	private String getChildRecords(List<String> serializedChildren) {
		String childRecords = '';
		for (String child : serializedChildren) {
			childRecords += child + ',';
		}
		childRecords = childRecords.substring(0, childRecords.length() - 1);
		return childRecords;
	}

	//JSON parsing function
	//Appends the JSON child list closing
	private String closeChildList() {
		return ']}';
	}

	//JSON parsing function
	//Appends the JSON object closing
	private String closeJson() {
		return '}';
	}
}