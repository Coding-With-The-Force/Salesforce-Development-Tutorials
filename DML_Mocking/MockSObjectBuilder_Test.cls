@isTest
private class MockSObjectBuilder_Test {

	private static String TEST_NAME = 'Raymond Powell';
	private static String TEST_NAME_2 = 'Henery Kennsington';
	private static String TEST_PHONE = '1234567890';
	private static String CHILD_LABEL_OPPORTUNITIES = 'Opportunities';
	private static String FIELD_LABEL_NAME = 'Name';
	private static String FIELD_LABEL_OWNER = 'Owner';

	@isTest
	static void build_hasStarterSObject_shouldMaintainPreviousFields() {
		Account acc = new Account(Owner = new User(), Phone = TEST_PHONE);
		MockSObjectBuilder mockAccountBuilder = new MockSObjectBuilder(acc);

		mockAccountBuilder.setField('Name', TEST_NAME);

		Test.startTest();
		Account mockAccount = (Account) mockAccountBuilder.build();
		Test.stopTest();

		System.assertEquals(TEST_NAME, mockAccount.Name, 'Account should have correct mock set name.');
		System.assertEquals(TEST_PHONE, mockAccount.Phone, 'Account should have correct previously set phone number.');
		System.assertEquals(new User(), mockAccount.Owner, 'Account should have previously set Owner.');
	}

	@isTest
	static void build_hasSObjectType_shouldBuildEmptySObject() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();

		Test.startTest();
		Account mockAccount = (Account) mockAccountBuilder.build();
		Test.stopTest();

		System.assertEquals(new Account(), mockAccount, 'Does not have default implementation of class');
	}

	@isTest
	static void build_hasFieldSet_objectShouldHaveFieldSet() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();

		SObjectField nameField = Account.Name.getDescribe().getSObjectField();
		mockAccountBuilder.setField(nameField, TEST_NAME);

		Test.startTest();
		Account mockAccount = (Account) mockAccountBuilder.build();
		Test.stopTest();

		System.assertEquals(TEST_NAME, mockAccount.Name, 'Object should have correct name.');
	}

	@isTest
	static void build_hasReadOnlyFieldSet_objectShouldHaveFieldSet() {

		MockSObjectBuilder mockUserBuilder = getTestMockUserBuilder();

		SObjectField readOnlyField = User.Name.getDescribe().getSObjectField();
		mockUserBuilder.setField(readOnlyField, TEST_NAME);

		Test.startTest();
		User mockUser = (User) mockUserBuilder.build();
		Test.stopTest();

		System.assertEquals(TEST_NAME, mockUser.Name, 'Object should have correct Name.');
	}

	@isTest
	static void build_hasDateAndDatetimeFieldSet_objectShouldHaveFieldSet() {

		MockSObjectBuilder mockOpportunityBuilder = getTestMockOpportunityBuilder();

		Datetime createdDate = Datetime.now();
		Date closeDate = Date.today();

		mockOpportunityBuilder.setField('CreatedDate', createdDate);
		mockOpportunityBuilder.setField('CloseDate', closeDate);

		Test.startTest();
		Opportunity mockOpportunity = (Opportunity) mockOpportunityBuilder.build();
		Test.stopTest();

		System.assertEquals(createdDate, mockOpportunity.CreatedDate, 'Object should have correct Close Date.');
		System.assertEquals(closeDate, mockOpportunity.CloseDate, 'Object should have correct Created Date.');
	}

	@isTest
	static void build_hasMultipleFieldsSet_objectShouldHaveAllFieldsSet() {

		MockSObjectBuilder mockUserBuilder = getTestMockUserBuilder()
				.setField(FIELD_LABEL_NAME, TEST_NAME)
				.setId();

		Test.startTest();
		User mockUser = (User) mockUserBuilder.build();
		Test.stopTest();

		System.assertEquals(TEST_NAME, mockUser.Name, 'Object should have correct Name.');
		System.assertEquals(mockUserBuilder.getField('Id'), mockUser.Id, 'Object should have correct Id.');
	}

	@isTest
	static void build_givenUnserializedChild_objectShouldHaveChild() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();

		mockAccountBuilder.setChild(CHILD_LABEL_OPPORTUNITIES, getTestMockOpportunityBuilder().setField(FIELD_LABEL_NAME, TEST_NAME).build());

		Test.startTest();
		Account mockAccount = (Account) mockAccountBuilder.build();
		Test.stopTest();

		System.assertEquals(TEST_NAME, mockAccount.Opportunities[0].Name, 'Object should have child');
	}

	@isTest
	static void build_givenChild_objectShouldHaveChild() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();

		mockAccountBuilder.setChild(CHILD_LABEL_OPPORTUNITIES, getSerializedOpp(TEST_NAME));

		Test.startTest();
		Account mockAccount = (Account) mockAccountBuilder.build();
		Test.stopTest();

		System.assertEquals(TEST_NAME, mockAccount.Opportunities[0].Name, 'Object should have child');
	}

	@isTest
	static void build_given2UnserializedChildren_objectShouldHave2Children() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();
		Opportunity opp = (Opportunity) getTestMockOpportunityBuilder()
				.setField(FIELD_LABEL_NAME, TEST_NAME)
				.build();
		Opportunity opp2 = (Opportunity) getTestMockOpportunityBuilder()
				.setField(FIELD_LABEL_NAME, TEST_NAME_2)
				.build();

		List<Opportunity> serializedChildren = new List<Opportunity>{opp, opp2};

		mockAccountBuilder.setChildren(CHILD_LABEL_OPPORTUNITIES, serializedChildren);

		Test.startTest();
		Account mockAccount = (Account) mockAccountBuilder.build();
		Test.stopTest();

		System.assertEquals(TEST_NAME, mockAccount.Opportunities[0].Name, 'Object should have first child');
		System.assertEquals(TEST_NAME_2, mockAccount.Opportunities[1].Name, 'Object should have second child');
	}

	@isTest
	static void build_given2Children_objectShouldHave2Children() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();

		List<String> serializedChildren = new List<String>{getSerializedOpp(TEST_NAME), getSerializedOpp(TEST_NAME_2)};

		mockAccountBuilder.setChildren(CHILD_LABEL_OPPORTUNITIES, serializedChildren);

		Test.startTest();
		Account mockAccount = (Account) mockAccountBuilder.build();
		Test.stopTest();

		System.assertEquals(TEST_NAME, mockAccount.Opportunities[0].Name, 'Object should have first child');
		System.assertEquals(TEST_NAME_2, mockAccount.Opportunities[1].Name, 'Object should have second child');
	}

	@isTest
	static void setParent_givenParentIsNull_shouldNotSetParent() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();
		String ownerField = FIELD_LABEL_OWNER;

		Test.startTest();
		Account mockAccount = (Account) mockAccountBuilder.setParent(ownerField, null).build();
		Test.stopTest();

		System.assertEquals(null, mockAccount.Owner, 'Object should not have parent owner');
		System.assertEquals(null, mockAccount.OwnerId, 'Object should not have parent ownerId');
	}

	@isTest
	static void setParent_givenInvalidParent_shouldNotSetParent() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();
		String invalidField = 'Invalid Field';
		User testUser = new User(Id = MockSObjectBuilder.getMockId(User.getSObjectType()), LastName = TEST_NAME);

		Test.startTest();
		Account mockAccount = (Account) mockAccountBuilder.setParent(invalidField, testUser).build();
		Test.stopTest();
	}

	@isTest
	static void build_givenParentField_shouldHaveParent() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();
		String ownerField = FIELD_LABEL_OWNER;
		User testUser = new User(Id = MockSObjectBuilder.getMockId(User.getSObjectType()), LastName = TEST_NAME);

		Test.startTest();
		Account mockAccount = (Account) mockAccountBuilder.setParent(ownerField, testUser).build();
		Test.stopTest();

		System.assertEquals(testUser.LastName, mockAccount.Owner.LastName, 'Object should have parent owner');
		System.assertEquals(testUser.Id, mockAccount.OwnerId, 'Object should have owner Id');
	}

	@isTest
	static void getSerializedSObject_givenEmptyObject_shouldReturnEmptyObject() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();

		Test.startTest();
		String accountJson = mockAccountBuilder.getSerializedSObject();
		Test.stopTest();

		System.assertEquals(JSON.serialize(new Account()), accountJson);
	}

	@isTest
	static void setField_givenField_shouldHaveField() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();
		SObjectField nameField = Account.Name.getDescribe().getSObjectField();

		Test.startTest();
		mockAccountBuilder.setField(nameField, TEST_NAME);
		Test.stopTest();

		System.assertEquals(TEST_NAME, mockAccountBuilder.getField(nameField), 'Field not found in builder.');
	}

	@isTest
	static void setField_givenFieldString_shouldHaveField() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();
		String nameField = FIELD_LABEL_NAME;

		Test.startTest();
		mockAccountBuilder.setField(nameField, TEST_NAME);
		Test.stopTest();

		System.assertEquals(TEST_NAME, mockAccountBuilder.getField(nameField), 'Field not found in builder.');
	}

	@isTest
	static void getMockId_givenNoPreviousIds_shouldReturnFirstId() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();

		Test.startTest();
		Id mockId = mockAccountBuilder.getMockId();
		Test.stopTest();

		System.assertEquals(mockAccountBuilder.mockType.getDescribe().getKeyPrefix() + '000000000001', mockId);
	}

	@isTest
	static void getMockId_givenOnePreviousId_shouldReturnSecondId() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();
		mockAccountBuilder.getMockId();

		Test.startTest();
		Id mockId = mockAccountBuilder.getMockId();
		Test.stopTest();

		System.assertEquals(mockAccountBuilder.mockType.getDescribe().getKeyPrefix() + '000000000002', mockId);
	}

	@isTest
	static void getChildRelationship_givenChildRelationshipLabel_shouldReturnChildRelationship() {

		MockSObjectBuilder mockAccountBuilder = getTestMockAccountBuilder();

		Test.startTest();
		ChildRelationship relationship = mockAccountBuilder.getChildRelationship(CHILD_LABEL_OPPORTUNITIES);
		Test.stopTest();

		System.assertEquals(CHILD_LABEL_OPPORTUNITIES, relationship.getRelationshipName());
	}

	private static MockSObjectBuilder getTestMockAccountBuilder() {
		return new MockSObjectBuilder(Account.getSObjectType());
	}

	private static MockSObjectBuilder getTestMockUserBuilder() {
		return new MockSObjectBuilder(User.getSObjectType());
	}

	private static MockSObjectBuilder getTestMockOpportunityBuilder() {
		return new MockSObjectBuilder(Opportunity.getSObjectType());
	}

	private static String getSerializedOpp(String name) {
		MockSObjectBuilder mockOpportunityBuilder = getTestMockOpportunityBuilder();
		mockOpportunityBuilder.setField(FIELD_LABEL_NAME, name);
		return mockOpportunityBuilder.getSerializedSObject();
	}
}