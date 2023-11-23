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
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'FC 11/16/2023 20:22:39'!
assertPepeSanchezWasImportedButNotHisAddresses

	|importedCustomer|
		importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
		self assert: importedCustomer hasNoAddressAt: 'San Martin'! !

!ImportTest methodsFor: 'tests' stamp: 'FC 11/23/2023 01:37:59'!
shouldFailWhenImporting: dataToImport andCheck: postFailChecks

	^ self should: [CustomerImporter valueFrom: self lessThan6AddressFieldsImportData into: session.] 
	raise: Error withExceptionDo: [:error | 
		self assert: error messageText equals: CustomerImporter cannotImportAddressEntryWithLessThan6FieldsErrorDescription.
		self assertPepeSanchezWasImportedButNotHisAddresses.
	]! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 18:17:51'!
test01Import

	CustomerImporter valueFrom: self validImportData into: session..

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests' stamp: 'FC 11/23/2023 01:39:34'!
test02CannotImportCustomerEntriesWithLessThan5Fields
	self shouldFailWhenImporting: self lessThan5CustomerFieldsImportData andCheck: [:error |
		self assert: error messageText equals: CustomerImporter cannotImportCustomerEntryWithLessThan5FieldsErrorDescription.
		self assertCustomerIsNotInDatabaseWithIdentificationType: 'D' number: '22333444'.
	].
! !

!ImportTest methodsFor: 'tests' stamp: 'FC 11/23/2023 01:40:07'!
test03CannotImportCustomerEntriesWithMoreThan5Fields

	self shouldFailWhenImporting: self moreThan5CustomerFieldsImportData andCheck: [:error |
		self assert: error messageText equals: CustomerImporter cannotImportCustomerEntryWithMoreThan5FieldsErrorDescription.
		self assertCustomerIsNotInDatabaseWithIdentificationType: 'D' number: '22333444'.
	].! !

!ImportTest methodsFor: 'tests' stamp: 'FC 11/23/2023 01:40:32'!
test04CannotImportAddressEntriesWithLessThan6Fields
	
	self shouldFailWhenImporting: self lessThan6AddressFieldsImportData andCheck: [:error | 
		self assert: error messageText equals: CustomerImporter cannotImportAddressEntryWithLessThan6FieldsErrorDescription.
		self assertPepeSanchezWasImportedButNotHisAddresses.
	].! !

!ImportTest methodsFor: 'tests' stamp: 'FC 11/23/2023 01:40:52'!
test05CannotImportAddressEntriesWithMoreThan6Fields

	self shouldFailWhenImporting: self moreThan6AddressFieldsImportData andCheck: [:error | 
		self assert: error messageText equals: CustomerImporter cannotImportAddressEntryWithMoreThan6FieldsErrorDescription.
		self assertPepeSanchezWasImportedButNotHisAddresses.
	].
! !

!ImportTest methodsFor: 'tests' stamp: 'FC 11/23/2023 01:41:13'!
test06CannotImportWhenStartsWithCAndHasMoreCharacters
	
	self shouldFailWhenImporting: self startsWithCAndHasMoreCharacters andCheck: [:error | 
		self assert: error messageText equals: CustomerImporter cannotImportEntryWithInvalidTypeErrorDescription.
		self assert: (session selectAllOfType: Customer) isEmpty.
	].! !

!ImportTest methodsFor: 'tests' stamp: 'FC 11/23/2023 01:41:36'!
test07CannotImportWhenStartsWithAAndHasMoreCharacters

	self shouldFailWhenImporting: self startsWithAAndHasMoreCharacters andCheck: [:error | 
		self assert: error messageText equals: CustomerImporter cannotImportEntryWithInvalidTypeErrorDescription.
		self assert: (session selectAllOfType: Customer) isEmpty.
	].! !

!ImportTest methodsFor: 'tests' stamp: 'FC 11/23/2023 01:41:52'!
test08CannotImportEmptyData
	
	self shouldFailWhenImporting:self emptyImportData  andCheck: [:error | 
		self assert: error messageText equals: CustomerImporter cannotImportEmptyDataErrorDescription.
	].! !

!ImportTest methodsFor: 'tests' stamp: 'FC 11/23/2023 01:42:16'!
test09CannotImportAddressWithNoCustomer
	self shouldFailWhenImporting: self addressWithNoCustomerImportData andCheck: [:error | 
		self assert: error messageText equals: CustomerImporter cannotImportAddressWithNoCustomerErrorDescription.
	].! !


!ImportTest methodsFor: 'assertions' stamp: 'FC 11/16/2023 20:15:26'!
assert: importedCustomer hasNoAddressAt: aStreetName

	| hasAdresss |
	hasAdresss := true.
	importedCustomer addressAt: aStreetName ifNone: [ hasAdresss := false].
	self deny: hasAdresss.

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

!ImportTest methodsFor: 'assertions' stamp: 'FC 11/16/2023 19:51:13'!
assertCustomerIsNotInDatabaseWithIdentificationType: anIdType number: anIdNumber 

	self assert: (session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) isEmpty! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:27:57'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := self customerWithIdentificationType: anIdType number: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:12:18'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: (session selectAllOfType: Customer) size! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 11/16/2023 19:02:04'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:28:23'!
tearDown

	session commit.
	session close.
	! !


!ImportTest methodsFor: 'customer' stamp: 'HAW 5/22/2022 18:14:22'!
customerWithIdentificationType: anIdType number: anIdNumber

	^ (session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !


!ImportTest methodsFor: 'test data' stamp: 'SC 11/22/2023 20:18:59'!
addressWithNoCustomerImportData

	^ ReadStream on:
'A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImportTest methodsFor: 'test data' stamp: 'SC 11/22/2023 19:28:37'!
emptyImportData

	^ ReadStream on: '
	'! !

!ImportTest methodsFor: 'test data' stamp: 'FC 11/16/2023 19:44:07'!
lessThan5CustomerFieldsImportData

	^ ReadStream on:
'C,Pepe,Sanchez,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImportTest methodsFor: 'test data' stamp: 'FC 11/16/2023 20:08:08'!
lessThan6AddressFieldsImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImportTest methodsFor: 'test data' stamp: 'FC 11/16/2023 20:04:48'!
moreThan5CustomerFieldsImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444,17
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImportTest methodsFor: 'test data' stamp: 'FC 11/16/2023 20:23:28'!
moreThan6AddressFieldsImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs,120
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImportTest methodsFor: 'test data' stamp: 'SC 11/22/2023 19:11:08'!
startsWithAAndHasMoreCharacters

	^ ReadStream on:
'Auto,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'SC 11/22/2023 18:35:12'!
startsWithCAndHasMoreCharacters

	^ ReadStream on:
'Casa,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 18:08:08'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


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


!classDefinition: #Customer category: 'CustomerImporter'!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses'
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


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'session readStream line newCustomer newAddress addressData customerData'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'HAW 5/22/2022 18:06:47'!
initializeFrom: aReadStream into: aSession
	session := aSession.
	readStream := aReadStream.! !


!CustomerImporter methodsFor: 'assertion' stamp: 'FC 11/16/2023 20:27:41'!
assertAddressDataIsNotGreaterThanSix

	^ (addressData size > 6) ifTrue: [self error: self class
		cannotImportAddressEntryWithMoreThan6FieldsErrorDescription.]! !

!CustomerImporter methodsFor: 'assertion' stamp: 'FC 11/16/2023 20:28:10'!
assertAddressDataIsNotLessThanSix

	^ (addressData size < 6) ifTrue: [self error: self class cannotImportAddressEntryWithLessThan6FieldsErrorDescription]! !

!CustomerImporter methodsFor: 'assertion' stamp: 'FC 11/23/2023 01:23:39'!
assertAddressDataIsValid

	self assertDataIsNotEmpty.
	self assertAdressDataIsTheCorrectSize.
	self assertAddressHasCostumer! !

!CustomerImporter methodsFor: 'assertion' stamp: 'SC 11/22/2023 20:30:54'!
assertAddressHasCostumer

	^ newCustomer ifNil: [ self error: self class cannotImportAddressWithNoCustomerErrorDescription ]! !

!CustomerImporter methodsFor: 'assertion' stamp: 'FC 11/16/2023 20:28:10'!
assertAdressDataIsTheCorrectSize

	self assertAddressDataIsNotLessThanSix.
	self assertAddressDataIsNotGreaterThanSix! !

!CustomerImporter methodsFor: 'assertion' stamp: 'FC 11/16/2023 20:27:55'!
assertCustomerDataIsTheCorrectSize

	self assertCustomerDataSizeIsNotLessThanFive.
	self assertCustomerDataSizeIsNotGreaterThanFive! !

!CustomerImporter methodsFor: 'assertion' stamp: 'FC 11/23/2023 01:23:56'!
assertCustomerDataIsValid

	self assertDataIsNotEmpty.
	self assertCustomerDataIsTheCorrectSize! !

!CustomerImporter methodsFor: 'assertion' stamp: 'FC 11/16/2023 20:26:23'!
assertCustomerDataSizeIsNotGreaterThanFive

	^ (customerData size > 5) ifTrue: [self error: CustomerImporter cannotImportCustomerEntryWithMoreThan5FieldsErrorDescription.]! !

!CustomerImporter methodsFor: 'assertion' stamp: 'FC 11/16/2023 20:27:55'!
assertCustomerDataSizeIsNotLessThanFive

	^ (customerData size < 5) ifTrue: [self error: CustomerImporter cannotImportCustomerEntryWithLessThan5FieldsErrorDescription]! !

!CustomerImporter methodsFor: 'assertion' stamp: 'SC 11/22/2023 19:45:29'!
assertDataIsNotEmpty

	^ (line findTokens: $,) isEmpty ifTrue: [ self error: self class cannotImportEmptyDataErrorDescription ]! !


!CustomerImporter methodsFor: 'accessing' stamp: 'FC 11/16/2023 19:17:57'!
getNextEntry

	^ line := readStream nextLine! !

!CustomerImporter methodsFor: 'accessing' stamp: 'FC 11/16/2023 19:39:48'!
value

	"
	self importCustomers
	"
	[ self advanceToNextEntryIfItExists ] whileTrue: [
		self importEntry.
	].

	! !


!CustomerImporter methodsFor: 'import' stamp: 'FC 11/23/2023 01:23:39'!
importAddressEntry

	addressData := line findTokens: $,.
	self assertAddressDataIsValid.
	self generateAddressEntry! !

!CustomerImporter methodsFor: 'import' stamp: 'FC 11/23/2023 01:23:56'!
importCustomerEntry

	customerData := line findTokens: $,.
	self assertCustomerDataIsValid.
	self generateCustomerEntry.
	session persist: newCustomer.! !

!CustomerImporter methodsFor: 'import' stamp: 'SC 11/22/2023 19:45:29'!
importEntry
	self assertDataIsNotEmpty.
	(self isCustomerEntry) ifTrue: [^ self importCustomerEntry ].
	(self isAddressEntry) ifTrue: [^ self importAddressEntry].
	self error: self class cannotImportEntryWithInvalidTypeErrorDescription
	
	! !


!CustomerImporter methodsFor: 'entry generation' stamp: 'FC 11/16/2023 19:35:25'!
advanceToNextEntryIfItExists
	line := readStream nextLine.
	^ line notNil! !

!CustomerImporter methodsFor: 'entry generation' stamp: 'FC 11/16/2023 19:38:31'!
generateAddressEntry

	newAddress := Address new.
	newCustomer addAddress: newAddress.
	newAddress streetName: addressData second.
	newAddress streetNumber: addressData third asNumber .
	newAddress town: addressData fourth.
	newAddress zipCode: addressData fifth asNumber .
	newAddress province: addressData sixth! !

!CustomerImporter methodsFor: 'entry generation' stamp: 'FC 11/16/2023 19:39:10'!
generateCustomerEntry

	newCustomer := Customer new.
	newCustomer firstName: customerData second.
	newCustomer lastName: customerData third.
	newCustomer identificationType: customerData fourth.
	newCustomer identificationNumber: customerData fifth! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'SC 11/22/2023 19:11:23'!
isAddressEntry

	^ line beginsWith: 'A,'! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'SC 11/22/2023 18:44:05'!
isCustomerEntry

	^ line beginsWith: 'C,'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 18:06:47'!
from: aReadStream into: aSession
	^self new initializeFrom: aReadStream into: aSession! !

!CustomerImporter class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 18:11:27'!
valueFrom: aReadStream into: aSession

	^(self from: aReadStream into: aSession) value! !


!CustomerImporter class methodsFor: 'error handling' stamp: 'FC 11/16/2023 19:54:24'!
cannotImportAddressEntryWithLessThan6FieldsErrorDescription
	^'Cannot import address entry with less than six fields'.
	! !

!CustomerImporter class methodsFor: 'error handling' stamp: 'FC 11/16/2023 20:05:41'!
cannotImportAddressEntryWithMoreThan6FieldsErrorDescription
	^'Cannot import address entry with more than six fields'.
	! !

!CustomerImporter class methodsFor: 'error handling' stamp: 'SC 11/22/2023 20:22:53'!
cannotImportAddressWithNoCustomerErrorDescription
	^'Cannot import an address without a customer'.
	! !

!CustomerImporter class methodsFor: 'error handling' stamp: 'FC 11/16/2023 19:53:59'!
cannotImportCustomerEntryWithLessThan5FieldsErrorDescription
	^'Cannot import customer entry with less than five fields'.
	! !

!CustomerImporter class methodsFor: 'error handling' stamp: 'FC 11/16/2023 20:05:30'!
cannotImportCustomerEntryWithMoreThan5FieldsErrorDescription
	^'Cannot import customer entry with more than five fields'.
	! !

!CustomerImporter class methodsFor: 'error handling' stamp: 'SC 11/22/2023 19:14:58'!
cannotImportEmptyDataErrorDescription
	^'Cannot import an empty entry'.
	! !

!CustomerImporter class methodsFor: 'error handling' stamp: 'SC 11/22/2023 19:08:19'!
cannotImportEntryWithInvalidTypeErrorDescription
	^'Cannot import entry with invalid type'.
	! !


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
