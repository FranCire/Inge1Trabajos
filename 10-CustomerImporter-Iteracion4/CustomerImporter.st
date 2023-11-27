!classDefinition: #PersistentSet category: 'CustomerImporter'!
Set subclass: #PersistentSet
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentSet methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:25:31'!
initializeOn: aSession from: aNonPersistentSet

	session := aSession.
	self addAll: aNonPersistentSet ! !


!PersistentSet methodsFor: 'adding' stamp: 'HAW 11/14/2023 08:23:40'!
add: newObject

	super add: newObject.
	session persist: newObject.
	
	^newObject! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PersistentSet class' category: 'CustomerImporter'!
PersistentSet class
	instanceVariableNames: ''!

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:24:32'!
on: aSession

	^self on: aSession from: #()! !

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:25:00'!
on: aSession from: aNonPersistentSet

	^self new initializeOn: aSession from: aNonPersistentSet
! !


!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'system'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 21:15:52'!
test01ValidDataIsImportedCorrectly

	CustomerImporter valueFrom: self validImportData into: system..

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 21:15:52'!
test02CanNotImportAddressWithoutCustomer

	self
		should: [ CustomerImporter valueFrom: self addressWithoutCustomerData into: system. ]
		raise: Error - MessageNotUnderstood
		withMessageText: CustomerImporter canNotImportAddressWithoutCustomerErrorDescription

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test03DoesNotImportRecordsStartingWithCButMoreCharacters

	self
		shouldFailImporting: self invalidCustomerRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:49:03'!
test04DoesNotImportRecordsStartingWithAButMoreCharacters

	self
		shouldFailImporting: self invalidAddressRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:49:36'!
test05CanNotImportAddressRecordWithLessThanSixFields

	self
		shouldFailImporting: self addressRecordWithLessThanSixFields
		messageText: CustomerImporter invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:51:14'!
test06CanNotImportAddressRecordWithMoreThanSixFields

	self
		shouldFailImporting: self addressRecordWithMoreThanSixFields
		messageText: CustomerImporter invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test07CanNotImportCustomerRecordWithLessThanFiveFields

	self
		shouldFailImporting: self customerRecordWithLessThanFiveFields
		messageText: CustomerImporter invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test08CanNotImportCustomerRecordWithMoreThanFiveFields

	self
		shouldFailImporting: self customerRecordWithMoreThanFiveFields
		messageText: CustomerImporter invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 20:01:43'!
test09CannotImportEmptyLine

	self
		shouldFailImporting: self emptyLine
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !


!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:22:05'!
assertAddressOf: importedCustomer at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince

	| importedAddress |

	importedAddress := importedCustomer addressAt: aStreetName ifNone: [ self fail ].
	self assert: aStreetName equals: importedAddress streetName.
	self assert: aNumber equals: importedAddress streetNumber.
	self assert: aTown equals: importedAddress town.
	self assert: aZipCode equals: importedAddress zipCode.
	self assert: aProvince equals: importedAddress province.

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:34:30'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := system customerWithIdentificationType: anIdType number: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:34:37'!
assertImportedOneCustomerWithoutAddress

	| importedCustomer |

	self assert: 1 equals: system numberOfCustomers.
	importedCustomer := system customerWithIdentificationType: 'D' number: '22333444'.
	self assert: importedCustomer isAddressesEmpty
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:33:18'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: system numberOfCustomers! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:33:24'!
assertNoCustomerWasImported

	^ self assert: 0 equals: system numberOfCustomers! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:15:52'!
shouldFailImporting: aReadStream messageText: anErrorMessageText asserting: anAssertionBlock

	self
		should: [ CustomerImporter valueFrom: aReadStream into: system. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anErrorMessageText equals: anError messageText.
			anAssertionBlock value ]

	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 21:36:16'!
setUp

	system := Environment current createCustomerSystem.
	system start.
	system beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 20:12:16'!
tearDown

	system commit.
	system stop
	! !


!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:41:20'!
addressRecordWithLessThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:51:35'!
addressRecordWithMoreThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs,x'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:14:13'!
addressWithoutCustomerData

	^ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:53:41'!
customerRecordWithLessThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:55:59'!
customerRecordWithMoreThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444,x'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 20:02:57'!
emptyLine

	^ReadStream on: '
'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:34:25'!
invalidAddressRecordStartData

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
AA,San Martin,3322,Olivos,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:22:55'!
invalidCustomerRecordStartData

	^ReadStream on: 'CC,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 18:08:08'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


!classDefinition: #SupplyImportTest category: 'CustomerImporter'!
TestCase subclass: #SupplyImportTest
	instanceVariableNames: 'supplierSystem customerSystem supplier'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 01:58:51'!
emptyImportData
	
	^ReadStream on: '
	'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 02:12:14'!
extraAddressLettersImportData
	
	^ReadStream on: 'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
EC,D,5456774
ARBOL,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 02:06:47'!
extraCustomerLettersImportData
	
	^ReadStream on: 'S,Supplier1,D,123
NCART,Pepe,Sanchez,D,22333444
EC,D,5456774
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 02:11:08'!
extraExistingCustomerLettersImportData
	
	^ReadStream on: 'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
ECAR,D,5456774
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 02:06:00'!
extraSupplierLettersImportData
	
	^ReadStream on: 'S,Supplier1,D,123
Saxo,Supplier1,A,1234
NC,Pepe,Sanchez,D,22333444
EC,D,5456774
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 00:47:32'!
lessThan3ExistingCustomerFieldsImportData
	
	^ReadStream on: 'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
EC,D
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 00:46:10'!
lessThan4SupplierFieldsImportData
	
	^ReadStream on: 'S,Supplier1,D
NC,Pepe,Sanchez,D,22333444
EC,D,5456774
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 00:44:31'!
lessThan5CustomerFieldsImportData
	
	^ReadStream on: 'S,Supplier1,D,123
NC,Pepe,Sanchez,D
EC,D,5456774
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 00:45:05'!
lessThan6AddressFieldsImportData
	
	^ReadStream on: 'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
EC,D,5456774
A,San Martin,3322,Olivos,1636
A,Maipu,888,Florida,1122,Buenos Aires'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 00:47:27'!
moreThan3ExistingCustomerFieldsImportData
	
	^ReadStream on: 'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
EC,D,5456774,Pepe
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 00:45:57'!
moreThan4SupplierFieldsImportData
	
	^ReadStream on: 'S,Supplier1,D,123,Pepe
NC,Pepe,Sanchez,D,22333444
EC,D,5456774
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 00:44:24'!
moreThan5CustomerFieldsImportData
	
	^ReadStream on: 'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444,Pepe
EC,D,5456774
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 00:44:59'!
moreThan6AddressFieldsImportData
	
	^ReadStream on: 'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
EC,D,5456774
A,San Martin,3322,Olivos,1636,BsAs,Pepe
A,Maipu,888,Florida,1122,Buenos Aires'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 01:45:37'!
noSupplierImportData
	
	^ReadStream on: 'NC,Pepe,Sanchez,D,22333444
EC,D,5456774
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'
	! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 00:57:39'!
supplier

	^ supplierSystem supplierWithIdentificationType: 'D'  number: '123'! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 00:22:13'!
validExistingCustomerImportData
	
	^ReadStream on: 'C,Juan,Cozzani,D,5456774'.! !

!SupplyImportTest methodsFor: 'test data' stamp: 'FC 11/27/2023 02:30:07'!
validSupplyImportData
	
	^ReadStream on: 'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
EC,D,5456774
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'
	! !


!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 01:24:26'!
test01ValidSupplierDataIsImportedCorrectly
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	SupplyImporter valueFrom: self validSupplyImportData into: supplierSystem with: customerSystem.
	
	self assertSuppliersAreCorrectlyImported.
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 02:04:58'!
test02CannotImportCustomerWithLessThan5Fields
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self lessThan5CustomerFieldsImportData
	 messageText: (SupplyImporter invalidCustomerRecordErrorDescription) asserting: 
		[self assertCorrectNumberOfImportedSuppliers.
		self assertSupplierDataIsCorrectlyImported.
		self assertNoCustomerWasImported].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 02:04:50'!
test03CannotImportCustomerWithMoreThan5Fields
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self moreThan5CustomerFieldsImportData
	 messageText: (SupplyImporter invalidCustomerRecordErrorDescription) asserting: 
		[self assertCorrectNumberOfImportedSuppliers.
		self assertSupplierDataIsCorrectlyImported.
		self assertNoCustomerWasImported].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 02:04:37'!
test04CannotImportExistingCustomerWithMoreThan3Fields
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self moreThan3ExistingCustomerFieldsImportData 
	 messageText: (SupplyImporter invalidExistingCustomerRecordErrorDescription ) asserting: 
		[self assertCorrectNumberOfImportedSuppliers.
		self assertSupplierDataIsCorrectlyImported.
		self assertNoExistingCustomerWasImported].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 02:04:26'!
test05CannotImportExistingCustomerWithLessThan3Fields
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self lessThan3ExistingCustomerFieldsImportData 
	 messageText: (SupplyImporter invalidExistingCustomerRecordErrorDescription ) asserting: 
		[self assertCorrectNumberOfImportedSuppliers.
		self assertSupplierDataIsCorrectlyImported.
		self assertNoExistingCustomerWasImported].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 01:35:10'!
test06CannotImportAddressWithMoreThan6Fields
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self moreThan6AddressFieldsImportData 
	 messageText: (SupplyImporter invalidAddressRecordErrorDescription ) asserting: 
		[self assertSupplierDataIsCorrectlyImported.
		self assertSupplierAndSupplierCustomersAreCorrectlyImported.
		self assertNoImportedAddresses ].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 01:34:57'!
test07CannotImportAddressWithLessThan6Fields
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self lessThan6AddressFieldsImportData 
	 messageText: (SupplyImporter invalidAddressRecordErrorDescription ) asserting: 
		[self assertSupplierDataIsCorrectlyImported.
		self assertSupplierAndSupplierCustomersAreCorrectlyImported.
		self assertNoImportedAddresses].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 01:42:19'!
test08CannotImportSupplierWithMoreThan4Fields
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self moreThan4SupplierFieldsImportData 
	 messageText: (SupplyImporter invalidSupplierRecordErrorDescription) asserting: 
		[self assertNoSupplierWasImported].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 01:43:57'!
test09CannotImportSupplierWithLessThan4Fields
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self lessThan4SupplierFieldsImportData 
	 messageText: (SupplyImporter invalidSupplierRecordErrorDescription) asserting: 
		[self assertNoSupplierWasImported].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 01:54:37'!
test10CannotImportWithoutSupplier
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self noSupplierImportData 
	 messageText: (SupplyImporter cannotImportRecordsWithNoSupplier ) asserting: 
		[self assertNoSupplierWasImported].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 01:57:56'!
test11CannotImportEmptyLine
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self emptyImportData 
	 messageText: (SupplyImporter invalidRecordTypeErrorDescription ) asserting: 
		[self assertNoSupplierWasImported].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 02:08:07'!
test12CannotImportSupplierEntryWithExtraLetters
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self extraSupplierLettersImportData 
	 messageText: (SupplyImporter invalidRecordTypeErrorDescription ) asserting: 
		[self assertCorrectNumberOfImportedSuppliers.
		self assertSupplierDataIsCorrectlyImported ].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 02:09:44'!
test13CannotImportCustomerEntryWithExtraLetters
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self extraCustomerLettersImportData 
	 messageText: (SupplyImporter invalidRecordTypeErrorDescription ) asserting: 
		[self assertCorrectNumberOfImportedSuppliers.
		self assertSupplierDataIsCorrectlyImported.
		self assertNoCustomerWasImported.].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 02:09:51'!
test14CannotImportExistingCustomerEntryWithExtraLetters
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self extraExistingCustomerLettersImportData 
	 messageText: (SupplyImporter invalidRecordTypeErrorDescription ) asserting: 
		[self assertCorrectNumberOfImportedSuppliers.
		self assertSupplierDataIsCorrectlyImported.
		self assertPepeSanchezWasImportedCorrectly.
		self assertNoExistingCustomerWasImported.].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 02:11:50'!
test15CannotImportAddressEntryWithExtraLetters
	
	CustomerImporter valueFrom: self validExistingCustomerImportData into: customerSystem.
	self shouldFailImporting: self extraAddressLettersImportData 
	 messageText: (SupplyImporter invalidRecordTypeErrorDescription ) asserting: 
		[self assertCorrectNumberOfImportedSuppliers.
		self assertSupplierDataIsCorrectlyImported.
		self assertPepeSanchezWasImportedCorrectly.
		self assertJuanCozzaniWasImportedCorrectly.
		self assertNoImportedAddresses ].
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'tests' stamp: 'FC 11/27/2023 02:22:37'!
test16CannotImportExistingCustomerThatDoesNotExist
	
	self shouldFailImporting: self extraAddressLettersImportData 
	 messageText: (SupplyImporter cannotImportNonExistentCustomer ) asserting: 
		[self assertCorrectNumberOfImportedSuppliers.
		self assertSupplierDataIsCorrectlyImported.
		self assertPepeSanchezWasImportedCorrectly. ].
	
	
	
	
	
		
	
	! !


!SupplyImportTest methodsFor: 'assertions' stamp: 'FC 11/27/2023 00:37:06'!
assertCorrectNumberOfImportedSuppliers

	^ self assert: supplierSystem numberOfSuppliers equals: 1! !

!SupplyImportTest methodsFor: 'assertions' stamp: 'FC 11/27/2023 01:13:15'!
assertJuanCozzaniWasImportedCorrectly

	|tino|
	tino := customerSystem customerWithIdentificationType: 'D' number: '5456774'.
	self assert: tino firstName equals: 'Juan'.
	self assert: tino lastName equals: 'Cozzani'.
	self assert: tino identificationType equals: 'D'.
	self assert: tino identificationNumber equals: '5456774'! !

!SupplyImportTest methodsFor: 'assertions' stamp: 'FC 11/27/2023 01:00:48'!
assertNoCustomerWasImported
	self assert: 0 equals: self supplier customers size.
	self assert: 1 equals: customerSystem numberOfCustomers.
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'assertions' stamp: 'FC 11/27/2023 01:09:05'!
assertNoExistingCustomerWasImported
	self assert: 1 equals: self supplier customers size.
	self assert: 2 equals: customerSystem numberOfCustomers.
	
	
	
	
	
		
	
	! !

!SupplyImportTest methodsFor: 'assertions' stamp: 'FC 11/27/2023 01:34:54'!
assertNoImportedAddresses

	^ self assert: self supplier isAddressesEmpty! !

!SupplyImportTest methodsFor: 'assertions' stamp: 'FC 11/27/2023 01:42:19'!
assertNoSupplierWasImported

	^ self assert: supplierSystem numberOfSuppliers equals: 0! !

!SupplyImportTest methodsFor: 'assertions' stamp: 'FC 11/27/2023 00:35:02'!
assertPepeSanchezWasImportedCorrectly

	|pepe|
	pepe := customerSystem customerWithIdentificationType: 'D' number: '22333444'.
	self assert: pepe firstName equals: 'Pepe'.
	self assert: pepe lastName equals: 'Sanchez'.
	self assert: pepe identificationType equals: 'D'.
	self assert: pepe identificationNumber equals: '22333444'! !

!SupplyImportTest methodsFor: 'assertions' stamp: 'FC 11/27/2023 00:39:25'!
assertSupplierAddressesAreCorrectlyImported

	supplier addressAt:'San Martin'  ifNone: [self fail].
	supplier addressAt: 'Maipu' ifNone: [self fail]! !

!SupplyImportTest methodsFor: 'assertions' stamp: 'FC 11/27/2023 01:25:36'!
assertSupplierAndSupplierCustomersAreCorrectlyImported

	self assertCorrectNumberOfImportedSuppliers.
	
	self assertSupplierDataIsCorrectlyImported.
	
	self assertPepeSanchezWasImportedCorrectly.
	
	self assertJuanCozzaniWasImportedCorrectly! !

!SupplyImportTest methodsFor: 'assertions' stamp: 'FC 11/27/2023 00:57:39'!
assertSupplierDataIsCorrectlyImported

	supplier := self supplier.
	self assert: supplier supplierName equals: 'Supplier1'.
	self assert: supplier identificationType equals: 'D'.
	self assert: supplier identificationNumber equals: '123'! !

!SupplyImportTest methodsFor: 'assertions' stamp: 'FC 11/27/2023 01:25:37'!
assertSuppliersAreCorrectlyImported

	 
	self assertSupplierAndSupplierCustomersAreCorrectlyImported.
	
	self assertSupplierAddressesAreCorrectlyImported.! !

!SupplyImportTest methodsFor: 'assertions' stamp: 'FC 11/27/2023 01:00:01'!
shouldFailImporting: aReadStream messageText: anErrorMessageText asserting: anAssertionBlock

	self
		should: [ SupplyImporter valueFrom: aReadStream into: supplierSystem with: customerSystem]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anErrorMessageText equals: anError messageText.
			anAssertionBlock value ]
! !


!SupplyImportTest methodsFor: 'setUp/tearDown' stamp: 'FC 11/27/2023 02:29:30'!
setUp

	supplierSystem := Environment current createSupplierSystem.
	customerSystem := Environment current createCustomerSystem.
	supplierSystem start.
	customerSystem start.
	supplierSystem beginTransaction.
	customerSystem beginTransaction! !

!SupplyImportTest methodsFor: 'setUp/tearDown' stamp: 'FC 11/27/2023 00:40:16'!
tearDown

	supplierSystem commit.
	supplierSystem stop.
	customerSystem commit.
	customerSystem stop.! !


!classDefinition: #Address category: 'CustomerImporter'!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province

	^province! !

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province: aProvince

	province := aProvince
	! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 17:55:46'!
isAt: aStreetName

	^streetName = aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName: aStreetName

	streetName := aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber

	^streetNumber ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber: aStreetNumber

	streetNumber := aStreetNumber ! !


!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !

!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town: aTown

	town := aTown! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode: aZipCode

	zipCode := aZipCode! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id inTransaction closed'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:25'!
beginTransaction

	inTransaction := true.! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:18'!
commit

	inTransaction := false.! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 11/14/2023 08:52:30'!
close

	closed := true.! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:49:30'!
assertCanUseDatabase

	self assertIsOpen.
	self assertInTransaction ! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:43'!
assertInTransaction

	inTransaction ifFalse: [ self error: 'Not in transaction' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:16'!
assertIsOpen

	closed ifTrue: [ self error: 'Connection with database closed' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:09:07'!
assertTypeIsPersisted: aType

	(configuration includes: aType) ifFalse: [ self error: 'Object of type ', aType name, ' are not configured to be persisted' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
isRelationToPersist: possibleRelation

	^ possibleRelation class = Set! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 19:29:06'!
objectsOfType: aType

	^ tables at: aType ifAbsent: [ #() ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
persistAddressesOf: anObjectWithAddresses

	anObjectWithAddresses addresses do: [ :anAddress | self persist: anAddress ]
	! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
persistPossibleRelationOf: anObject at: anInstVarOffset

	| possibleRelation |
		
	possibleRelation := anObject instVarAt: anInstVarOffset.
	(self isRelationToPersist: possibleRelation) ifTrue: [ self persistRelationOf: anObject at: anInstVarOffset with: possibleRelation ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:03'!
persistRelationOf: anObject at: anInstVarOffset with: aRelation

	| persistentRelation |
	
	persistentRelation := PersistentSet on: self from: aRelation.
	anObject instVarAt: anInstVarOffset put: persistentRelation! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:34'!
persistRelationsOf: anObject

	anObject class instVarNamesAndOffsetsDo: [ :anInstVarName :anInstVarOffset | self persistPossibleRelationOf: anObject at: anInstVarOffset]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:06:24'!
tableOfType: aType

	^ tables at: aType ifAbsentPut: [ Set new ]! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:44:19'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.
	inTransaction := false.
	closed := false.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 11/14/2023 09:06:24'!
persist: anObject

	| table |

	self assertCanUseDatabase.
	self assertTypeIsPersisted: anObject class.
	self delay.
	
	table := self tableOfType: anObject class.
	self defineIdOf: anObject.
	table add: anObject.
	self persistRelationsOf: anObject.
! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:06:56'!
select: aCondition ofType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:07:12'!
selectAllOfType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !


!classDefinition: #Environment category: 'CustomerImporter'!
Object subclass: #Environment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Environment methodsFor: 'customer system' stamp: 'HAW 5/22/2022 21:41:06'!
createCustomerSystem

	self subclassResponsibility ! !

!Environment methodsFor: 'customer system' stamp: 'FC 11/27/2023 02:28:36'!
createSupplierSystem

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Environment class' category: 'CustomerImporter'!
Environment class
	instanceVariableNames: ''!

!Environment class methodsFor: 'current' stamp: 'HAW 5/22/2022 21:37:10'!
current

	^(self subclasses detect: [ :anEnvironmentClass | anEnvironmentClass isCurrent ]) new! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:46'!
environmentKey

	^ #ENV! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:46'!
environmentVariable

	^ Smalltalk at: self environmentKey! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:09'!
identifier

	self subclassResponsibility! !

!Environment class methodsFor: 'current' stamp: 'HAW 5/22/2022 21:41:36'!
isCurrent

	self subclassResponsibility ! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:46:01'!
makeCurrent

	"
	Tener en cuenta que en Smalltalk se podría poner directamente la clase de environment,
	esto es DevelopmentEnvironment o IntegrationEnvironmet o hasta una instancia de ellas,
	pero se está simulando el hecho de que esto esté definido por fuera del sistema, como una
	variable del sistema operativo - Hernan"
	
	Smalltalk at: self environmentKey put: self identifier! !


!classDefinition: #DevelopmentEnvironment category: 'CustomerImporter'!
Environment subclass: #DevelopmentEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DevelopmentEnvironment methodsFor: 'customer system' stamp: 'HAW 5/22/2022 21:38:39'!
createCustomerSystem

	^TransientCustomerSystem new! !

!DevelopmentEnvironment methodsFor: 'customer system' stamp: 'FC 11/27/2023 02:29:01'!
createSupplierSystem
	^TransientSupplierSystem new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DevelopmentEnvironment class' category: 'CustomerImporter'!
DevelopmentEnvironment class
	instanceVariableNames: ''!

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:42:50'!
identifier

	^ #DEV! !

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'SC 11/23/2023 19:53:37'!
isCurrent
	
	self makeCurrent.
	
	^(self environmentVariable = self identifier)! !


!classDefinition: #IntegrationEnvironment category: 'CustomerImporter'!
Environment subclass: #IntegrationEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!IntegrationEnvironment methodsFor: 'customer system' stamp: 'HAW 5/22/2022 21:40:48'!
createCustomerSystem

	^PersistentCustomerSystem new! !

!IntegrationEnvironment methodsFor: 'customer system' stamp: 'FC 11/27/2023 02:29:14'!
createSupplierSystem
	^PersistentSupplierSystem new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IntegrationEnvironment class' category: 'CustomerImporter'!
IntegrationEnvironment class
	instanceVariableNames: ''!

!IntegrationEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:43:07'!
identifier

	^ #INT! !

!IntegrationEnvironment class methodsFor: 'current' stamp: 'SC 11/23/2023 19:50:16'!
isCurrent

	"
	self makeCurrent
	"
	^(self environmentVariable = self identifier)! !


!classDefinition: #Party category: 'CustomerImporter'!
Object subclass: #Party
	instanceVariableNames: 'identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Party methodsFor: 'addresses' stamp: 'SC 11/23/2023 20:22:50'!
addAddress: anAddress

	addresses add: anAddress ! !

!Party methodsFor: 'addresses' stamp: 'SC 11/23/2023 20:22:55'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Party methodsFor: 'addresses' stamp: 'SC 11/23/2023 20:22:59'!
addresses

	^ addresses! !

!Party methodsFor: 'addresses' stamp: 'SC 11/23/2023 20:24:03'!
isAddressesEmpty

	^addresses isEmpty ! !


!Party methodsFor: 'identification' stamp: 'SC 11/23/2023 20:23:04'!
identificationNumber

	^identificationNumber ! !

!Party methodsFor: 'identification' stamp: 'SC 11/23/2023 20:23:08'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Party methodsFor: 'identification' stamp: 'SC 11/23/2023 20:23:11'!
identificationType

	^identificationType ! !

!Party methodsFor: 'identification' stamp: 'SC 11/23/2023 20:23:14'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Party methodsFor: 'initialization' stamp: 'SC 11/23/2023 20:23:56'!
initialize

	addresses := OrderedCollection new.! !


!classDefinition: #Customer category: 'CustomerImporter'!
Party subclass: #Customer
	instanceVariableNames: 'id firstName lastName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 17:55:17'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !


!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName

	^firstName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName: aName

	firstName := aName! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName: aLastName

	lastName := aLastName
! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType

	^identificationType ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Customer methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


!classDefinition: #Supplier category: 'CustomerImporter'!
Party subclass: #Supplier
	instanceVariableNames: 'id customers supplierName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Supplier methodsFor: 'customer' stamp: 'SC 11/23/2023 20:24:54'!
addCustomer: customerToAdd

	customers add: customerToAdd.! !

!Supplier methodsFor: 'customer' stamp: 'SC 11/23/2023 20:25:02'!
customers
	^customers! !


!Supplier methodsFor: 'initialization' stamp: 'FC 11/27/2023 00:28:21'!
initialize
	customers := Set new.
	addresses := Set new.! !


!Supplier methodsFor: 'name' stamp: 'SC 11/23/2023 20:25:42'!
supplierName
	^supplierName! !

!Supplier methodsFor: 'name' stamp: 'SC 11/23/2023 20:26:26'!
supplierName: supplierNameToSet
	supplierName := supplierNameToSet.! !


!classDefinition: #PartyImporter category: 'CustomerImporter'!
Object subclass: #PartyImporter
	instanceVariableNames: 'line record readStream newAddress newCustomer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PartyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 01:48:47'!
assertRecordNotEmpty

	record isEmpty ifTrue: [ self error: self class invalidRecordTypeErrorDescription ]! !

!PartyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 02:40:09'!
createNewAddress
	
	newAddress := Address new.
	newAddress streetName: record second.
	newAddress streetNumber: record third asNumber .
	newAddress town: record fourth.
	newAddress zipCode: record fifth asNumber .
	newAddress province: record sixth! !

!PartyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 02:41:40'!
createNewCustomer

	newCustomer := Customer new.
	newCustomer firstName: record second.
	newCustomer lastName: record third.
	newCustomer identificationType: record fourth.
	newCustomer identificationNumber: record fifth! !

!PartyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 01:49:02'!
createRecord

	^ record := line findTokens: $,! !

!PartyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 01:49:06'!
hasLineToImport

	line := readStream nextLine.
	^line notNil! !

!PartyImporter methodsFor: 'evaluating - private' stamp: 'SC 11/23/2023 20:09:26'!
importRecord

	self subclassResponsibility! !


!PartyImporter methodsFor: 'evaluating' stamp: 'SC 11/23/2023 19:45:17'!
value

	[ self hasLineToImport ] whileTrue: [
		self createRecord.
		self importRecord ].

	! !


!PartyImporter methodsFor: 'address' stamp: 'FC 11/27/2023 01:48:55'!
assertValidAddressRecord

	^ record size ~= 6 ifTrue: [ self error: self class invalidAddressRecordErrorDescription ]! !

!PartyImporter methodsFor: 'address' stamp: 'FC 11/27/2023 01:49:39'!
isAddressRecord

	^ record first = 'A'! !


!PartyImporter methodsFor: 'customer' stamp: 'FC 11/27/2023 01:48:58'!
assertValidCustomerRecord

	^ record size ~= 5 ifTrue: [ self error: self class invalidCustomerRecordErrorDescription ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PartyImporter class' category: 'CustomerImporter'!
PartyImporter class
	instanceVariableNames: ''!

!PartyImporter class methodsFor: 'error messages' stamp: 'FC 11/27/2023 01:47:46'!
canNotImportAddressWithoutCustomerErrorDescription

	^'Cannot import address without customer'! !

!PartyImporter class methodsFor: 'error messages' stamp: 'SC 11/23/2023 20:07:43'!
invalidAddressRecordErrorDescription

	^'Address record has to have six fields'! !

!PartyImporter class methodsFor: 'error messages' stamp: 'SC 11/23/2023 20:07:55'!
invalidCustomerRecordErrorDescription

	^'Invalid Customer record'! !

!PartyImporter class methodsFor: 'error messages' stamp: 'SC 11/23/2023 19:55:57'!
invalidRecordTypeErrorDescription

	^'Invalid record type'! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
PartyImporter subclass: #CustomerImporter
	instanceVariableNames: 'system'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'HAW 5/22/2022 21:15:17'!
initializeFrom: aReadStream into: aCustomerSystem

	readStream := aReadStream.
	system := aCustomerSystem ! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'HAW 5/22/2022 18:48:58'!
value

	[ self hasLineToImport ] whileTrue: [
		self createRecord.
		self importRecord ].

	! !


!CustomerImporter methodsFor: 'customer' stamp: 'FC 11/27/2023 02:42:00'!
importCustomer

	self assertValidCustomerRecord.

	self createNewCustomer.
	system add: newCustomer! !

!CustomerImporter methodsFor: 'customer' stamp: 'HAW 5/22/2022 19:23:55'!
isCustomerRecord

	^ record first = 'C'! !


!CustomerImporter methodsFor: 'address' stamp: 'HAW 5/22/2022 19:58:41'!
assertCustomerWasImported

	^ newCustomer ifNil: [ self error: self class canNotImportAddressWithoutCustomerErrorDescription ]! !

!CustomerImporter methodsFor: 'address' stamp: 'FC 11/27/2023 02:41:19'!
importAddress


	self assertCustomerWasImported.
	self assertValidAddressRecord.
	
	self createNewAddress.

	newCustomer addAddress: newAddress .! !


!CustomerImporter methodsFor: 'evaluating - private' stamp: 'HAW 5/22/2022 20:04:06'!
importRecord

	self assertRecordNotEmpty.

	self isCustomerRecord ifTrue: [ ^self importCustomer ].
	self isAddressRecord ifTrue: [ ^self importAddress ].

	self error: self class invalidRecordTypeErrorDescription! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 21:15:35'!
from: aReadStream into: aCustomerSystem

	^self new initializeFrom: aReadStream into: aCustomerSystem! !


!CustomerImporter class methodsFor: 'importing' stamp: 'HAW 5/22/2022 21:15:52'!
valueFrom: aReadStream into: aCustomerSystem

	^(self from: aReadStream into: aCustomerSystem) value! !


!classDefinition: #SupplyImporter category: 'CustomerImporter'!
PartyImporter subclass: #SupplyImporter
	instanceVariableNames: 'newSupplier supplierSystem customerSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 02:17:58'!
assertCustomerExists

	^ (customerSystem hasCustomerWithIdentificationType: record second number: record third) ifFalse: [self error: self class cannotImportNonExistentCustomer]! !

!SupplyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 01:53:40'!
assertExistingSupplier

	^ (newSupplier isNil) ifTrue: [self error: self class cannotImportRecordsWithNoSupplier]! !

!SupplyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 01:06:45'!
assertValidExistingCustomerRecord

	^ (record size = 3) ifFalse: [self error: self class invalidExistingCustomerRecordErrorDescription]! !

!SupplyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 01:43:30'!
assertValidSupplierRecord

	^ (record size = 4) ifFalse: [self error: self class invalidSupplierRecordErrorDescription]! !

!SupplyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 02:43:33'!
importAddress
	 

	self assertValidAddressRecord.
	
	self createNewAddress.
	newSupplier addAddress: newAddress.
	! !

!SupplyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 02:17:58'!
importExistingCustomer
	
	| existingCustomer |
	self assertValidExistingCustomerRecord.
	self assertCustomerExists.
	existingCustomer := customerSystem customerWithIdentificationType: record second number: record third.
	newSupplier addCustomer: existingCustomer.! !

!SupplyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 02:36:38'!
importNewCustomer
	 
	self assertValidCustomerRecord.

	self createNewCustomer.
	newSupplier addCustomer: newCustomer.
	customerSystem add: newCustomer.! !

!SupplyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 01:53:40'!
importRecord

	self assertRecordNotEmpty.

	self isSupplier ifTrue: [^self importSupplier].
	self assertExistingSupplier.
	self isNewCustomerRecord ifTrue: [^self importNewCustomer ].
	self isExistingCustomerRecord ifTrue: [^self importExistingCustomer].
	self isAddressRecord ifTrue: [^self importAddress ].

	self error: self class invalidRecordTypeErrorDescription! !

!SupplyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 01:43:30'!
importSupplier
	self assertValidSupplierRecord.
	newSupplier := Supplier new.
	newSupplier supplierName: record second.
	newSupplier identificationType: record third.
	newSupplier identificationNumber: record fourth .
	supplierSystem add: newSupplier.! !

!SupplyImporter methodsFor: 'evaluating - private' stamp: 'SC 11/23/2023 20:30:08'!
initializeFrom: aReadStream into: aSupplierSystem with: aCustomerSystem 

	readStream := aReadStream.
	supplierSystem := aSupplierSystem.
	customerSystem := aCustomerSystem ! !

!SupplyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 00:27:47'!
isExistingCustomerRecord
	^record first = 'EC'.! !

!SupplyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 00:26:57'!
isNewCustomerRecord
	^record first = 'NC'.! !

!SupplyImporter methodsFor: 'evaluating - private' stamp: 'FC 11/27/2023 00:10:56'!
isSupplier
	^(record first = 'S').! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SupplyImporter class' category: 'CustomerImporter'!
SupplyImporter class
	instanceVariableNames: ''!

!SupplyImporter class methodsFor: 'error handling' stamp: 'FC 11/27/2023 02:17:38'!
cannotImportNonExistentCustomer
	^'Cannot import a non-existent customer'! !

!SupplyImporter class methodsFor: 'error handling' stamp: 'FC 11/27/2023 01:53:05'!
cannotImportRecordsWithNoSupplier
	^'Cannot import any record without a corresponding supplier'! !

!SupplyImporter class methodsFor: 'error handling' stamp: 'FC 11/27/2023 01:03:17'!
invalidExistingCustomerRecordErrorDescription
	^'Existing customer record has to have three fields'! !

!SupplyImporter class methodsFor: 'error handling' stamp: 'FC 11/27/2023 00:42:41'!
invalidSupplierRecordErrorDescription
	^'Supplier record has to have six fields'! !


!SupplyImporter class methodsFor: 'instance creation' stamp: 'FC 11/27/2023 00:05:23'!
from: aReadStream into: aSupplierSystem with: aCustomerSystem
	^(self new initializeFrom: aReadStream into: aSupplierSystem  with: aCustomerSystem) ! !

!SupplyImporter class methodsFor: 'instance creation' stamp: 'FC 11/27/2023 00:05:43'!
valueFrom: aReadStream into: aSupplierSystem with: aCustomerSystem
	^(self from: aReadStream into: aSupplierSystem  with: aCustomerSystem) value! !


!classDefinition: #PartySystem category: 'CustomerImporter'!
Object subclass: #PartySystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PartySystem methodsFor: 'customers' stamp: 'SC 11/23/2023 20:58:44'!
add: aCustomer

	self subclassResponsibility! !


!PartySystem methodsFor: 'transactions' stamp: 'SC 11/23/2023 20:58:49'!
beginTransaction

	self subclassResponsibility! !

!PartySystem methodsFor: 'transactions' stamp: 'SC 11/23/2023 20:58:52'!
commit

	self subclassResponsibility! !


!PartySystem methodsFor: 'system lifecycle' stamp: 'SC 11/23/2023 20:58:57'!
start

	self subclassResponsibility! !

!PartySystem methodsFor: 'system lifecycle' stamp: 'SC 11/23/2023 20:59:03'!
stop

	self subclassResponsibility! !


!classDefinition: #CustomerSystem category: 'CustomerImporter'!
PartySystem subclass: #CustomerSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:17:57'!
add: aCustomer

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'customers' stamp: 'FC 11/23/2023 02:27:40'!
addCustomer: customerToAdd

	self subclassResponsibility! !

!CustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:18:38'!
customerWithIdentificationType: anIdType number: anIdNumber

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'customers' stamp: 'FC 11/27/2023 02:15:44'!
hasCustomerWithIdentificationType: anIdType number: anIdNumber

	self subclassResponsibility! !

!CustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:18:51'!
numberOfCustomers

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'customers' stamp: 'FC 11/23/2023 02:28:07'!
selectCustomers: criteriaToSelectBy

	self subclassResponsibility! !


!CustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:18:04'!
beginTransaction

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:18:16'!
commit

	self subclassResponsibility ! !


!CustomerSystem methodsFor: 'system lifecycle' stamp: 'FC 11/23/2023 02:27:50'!
close

	self subclassResponsibility! !

!CustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:10'!
start

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:13'!
stop

	self subclassResponsibility ! !


!CustomerSystem methodsFor: 'initialization' stamp: 'FC 11/23/2023 02:27:59'!
initialize

	self subclassResponsibility! !


!classDefinition: #PersistentCustomerSystem category: 'CustomerImporter'!
CustomerSystem subclass: #PersistentCustomerSystem
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:14:14'!
add: aCustomer

	^session persist: aCustomer ! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'FC 11/23/2023 02:21:15'!
addCustomer: customerToAdd
	session persist: customerToAdd ! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:09:50'!
customerWithIdentificationType: anIdType number: anIdNumber

	^(session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'FC 11/27/2023 02:15:03'!
hasCustomerWithIdentificationType: anIdType number: anIdNumber

	^(session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) size > 0! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:08:47'!
numberOfCustomers

	^(session selectAllOfType: Customer) size! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'FC 11/23/2023 02:16:22'!
selectCustomers: criteriaToSelectBy
	^(session
		select: criteriaToSelectBy 
		ofType: Customer)! !


!PersistentCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:12:39'!
beginTransaction

	session beginTransaction.
! !

!PersistentCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:13:00'!
commit

	session commit ! !


!PersistentCustomerSystem methodsFor: 'system lifecycle' stamp: 'FC 11/23/2023 02:10:20'!
close
	session close! !

!PersistentCustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 11/14/2023 09:21:54'!
start

	session := DataBaseSession for: (Array with: Address with: Customer).
	! !

!PersistentCustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 20:13:10'!
stop

	session close! !


!PersistentCustomerSystem methodsFor: 'initialization' stamp: 'FC 11/23/2023 02:09:10'!
initialize
	session := DataBaseSession for: (Array with: Address with: Customer).
! !


!classDefinition: #TransientCustomerSystem category: 'CustomerImporter'!
CustomerSystem subclass: #TransientCustomerSystem
	instanceVariableNames: 'customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientCustomerSystem methodsFor: 'system lifecycle' stamp: 'FC 11/23/2023 02:31:41'!
close

	customerSet := nil.! !

!TransientCustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:21:06'!
start

	customers := OrderedCollection new! !

!TransientCustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:23:17'!
stop

	customers := nil! !


!TransientCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:21:20'!
beginTransaction

	! !

!TransientCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:23:01'!
commit

	! !


!TransientCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:21:32'!
add: aCustomer

	customers add: aCustomer ! !

!TransientCustomerSystem methodsFor: 'customers' stamp: 'FC 11/23/2023 02:31:41'!
addCustomer: customerToAdd

	customerSet add: customerToAdd ! !

!TransientCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:22:52'!
customerWithIdentificationType: anIdType number: anIdNumber

	^customers detect: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]! !

!TransientCustomerSystem methodsFor: 'customers' stamp: 'FC 11/27/2023 02:20:09'!
hasCustomerWithIdentificationType: anIdType number: anIdNumber

	^(customers anySatisfy: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]])! !

!TransientCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:21:43'!
numberOfCustomers

	^customers size! !

!TransientCustomerSystem methodsFor: 'customers' stamp: 'FC 11/23/2023 02:36:07'!
selectCustomers: criteriaToSelectBy

	^customerSet select: criteriaToSelectBy ! !


!TransientCustomerSystem methodsFor: 'initialization' stamp: 'FC 11/23/2023 02:29:04'!
initialize! !


!classDefinition: #SupplierSystem category: 'CustomerImporter'!
PartySystem subclass: #SupplierSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierSystem methodsFor: 'customers' stamp: 'FC 11/27/2023 02:24:55'!
add: aSupplier

	self subclassResponsibility! !

!SupplierSystem methodsFor: 'customers' stamp: 'FC 11/27/2023 02:25:07'!
numberOfSuppliers

	self subclassResponsibility! !

!SupplierSystem methodsFor: 'customers' stamp: 'FC 11/27/2023 02:25:20'!
supplierWithIdentificationType: anIdType number: anIdNumber

	self subclassResponsibility! !


!SupplierSystem methodsFor: 'transactions' stamp: 'FC 11/27/2023 02:24:59'!
beginTransaction

	self subclassResponsibility! !

!SupplierSystem methodsFor: 'transactions' stamp: 'FC 11/27/2023 02:25:03'!
commit

	self subclassResponsibility! !


!SupplierSystem methodsFor: 'system lifecycle' stamp: 'FC 11/27/2023 02:25:11'!
start

	self subclassResponsibility! !

!SupplierSystem methodsFor: 'system lifecycle' stamp: 'FC 11/27/2023 02:25:15'!
stop

	self subclassResponsibility! !


!classDefinition: #PersistentSupplierSystem category: 'CustomerImporter'!
SupplierSystem subclass: #PersistentSupplierSystem
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentSupplierSystem methodsFor: 'customers' stamp: 'SC 11/23/2023 21:01:36'!
add: aSupplier

	^session persist: aSupplier ! !

!PersistentSupplierSystem methodsFor: 'customers' stamp: 'FC 11/26/2023 23:46:36'!
numberOfSuppliers
	^(session selectAllOfType: Supplier) size! !

!PersistentSupplierSystem methodsFor: 'customers' stamp: 'SC 11/23/2023 21:05:38'!
supplierWithIdentificationType: anIdType number: anIdNumber

	^(session
		select: [ :aSupplier | aSupplier identificationType = anIdType and: [ aSupplier identificationNumber = anIdNumber ]]
		ofType: Supplier) anyOne! !


!PersistentSupplierSystem methodsFor: 'transactions' stamp: 'SC 11/23/2023 20:59:50'!
beginTransaction

	session beginTransaction.
! !

!PersistentSupplierSystem methodsFor: 'transactions' stamp: 'SC 11/23/2023 21:00:02'!
commit

	session commit ! !


!PersistentSupplierSystem methodsFor: 'system lifecycle' stamp: 'SC 11/23/2023 21:01:02'!
start

	session := DataBaseSession for: (Array with: Address with: Customer with:Supplier).
! !

!PersistentSupplierSystem methodsFor: 'system lifecycle' stamp: 'SC 11/23/2023 21:01:14'!
stop

	session close! !


!classDefinition: #TransientSupplierSystem category: 'CustomerImporter'!
SupplierSystem subclass: #TransientSupplierSystem
	instanceVariableNames: 'suppliers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientSupplierSystem methodsFor: 'customers' stamp: 'FC 11/27/2023 02:25:29'!
add: aSupplier

	suppliers add: aSupplier ! !

!TransientSupplierSystem methodsFor: 'customers' stamp: 'FC 11/27/2023 02:25:37'!
numberOfSuppliers

	^suppliers size! !

!TransientSupplierSystem methodsFor: 'customers' stamp: 'FC 11/27/2023 02:26:10'!
supplierWithIdentificationType: anIdType number: anIdNumber
	^suppliers detect:[ :aSupplier | aSupplier identificationType = anIdType and: [ aSupplier identificationNumber = anIdNumber ]]
! !


!TransientSupplierSystem methodsFor: 'transactions' stamp: 'FC 11/27/2023 02:26:55'!
beginTransaction
	suppliers := Set new.! !

!TransientSupplierSystem methodsFor: 'transactions' stamp: 'FC 11/27/2023 02:26:22'!
commit

! !


!TransientSupplierSystem methodsFor: 'system lifecycle' stamp: 'FC 11/27/2023 02:26:48'!
start

! !

!TransientSupplierSystem methodsFor: 'system lifecycle' stamp: 'FC 11/27/2023 02:26:33'!
stop

	suppliers := nil.! !
