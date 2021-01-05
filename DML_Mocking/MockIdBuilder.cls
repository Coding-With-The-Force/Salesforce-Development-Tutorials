@isTest
public with sharing class MockIdBuilder {

	public static Integer idCount = 0;

	//Get a fake id for a given SObjectType
	public static String getMockId(SObjectType objectType) {

		String nextIdCount = String.valueOf(idCount++);

		return objectType.getDescribe().getKeyPrefix()
				+ getFillerZeros(nextIdCount)
				+ nextIdCount;
	}

	//Gets how many 0's the id needs for correct length
	private static String getFillerZeros(String nextIdCount) {
		return '0'.repeat(12-nextIdCount.length());
	}
}