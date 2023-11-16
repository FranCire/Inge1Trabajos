!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'test objects' stamp: 'FC 11/16/2023 00:11:22'!
alem
	|alem|
	alem := Address new.
	alem province: 'CABA'.
	alem streetName: 'Alem'.
	alem streetNumber: 1122.
	alem town: 'CABA'.
	alem zipCode: 1001.
	^alem! !

!ImportTest methodsFor: 'test objects' stamp: 'FC 11/16/2023 00:32:07'!
inputTextStream
	^('C,Pepe,Sanchez,D,22333444',String lfString ,'A,San Martin,3322,Olivos,1636,BsAs',String lfString,'A,Maipu,888,Florida,1122,Buenos Aires',String lfString,'C,Juan,Perez,C,23-25666777-9',String lfString,'A,Alem,1122,CABA,1001,CABA') readStream .! !

!ImportTest methodsFor: 'test objects' stamp: 'FC 11/15/2023 23:42:56'!
juan
	
	| juan |
	juan := Customer new.
	juan firstName: 'Juan'.
	juan lastName: 'Perez'.
	juan identificationType: 'C'.
	juan identificationNumber: '23-25666777-9'.
	^juan! !

!ImportTest methodsFor: 'test objects' stamp: 'FC 11/15/2023 23:57:02'!
maipu
	|maipu|
	maipu := Address new.
	maipu province: 'Buenos Aires'.
	maipu streetName: 'Maipu'.
	maipu streetNumber: 888.
	maipu town: 'Florida'.
	maipu zipCode: 1122.
	^maipu! !

!ImportTest methodsFor: 'test objects' stamp: 'FC 11/15/2023 23:42:45'!
pepe
	|pepe|
	pepe := Customer new.
	pepe firstName: 'Pepe'.
	pepe lastName: 'Sanchez'.
	pepe identificationType: 'D'.
	pepe identificationNumber: '22333444'.
	^pepe! !

!ImportTest methodsFor: 'test objects' stamp: 'FC 11/16/2023 00:09:59'!
sanMartin
	|sanMartin|
	sanMartin := Address new.
	sanMartin province: 'BsAs'.
	sanMartin streetName: 'San Martin'.
	sanMartin streetNumber: 3322.
	sanMartin town: 'Olivos'.
	sanMartin zipCode: 1636.
	^sanMartin! !


!ImportTest methodsFor: 'assertions' stamp: 'FC 11/16/2023 00:05:43'!
assertAddress: address isTheSameAs: anotherAddress

	self assert: address province equals: anotherAddress province .
	self assert: address streetName equals: anotherAddress streetName .
	self assert: address streetNumber equals: anotherAddress streetNumber .
	self assert: address town equals: anotherAddress town.
	self assert: address zipCode equals: anotherAddress zipCode ! !

!ImportTest methodsFor: 'assertions' stamp: 'FC 11/16/2023 00:07:26'!
assertAddressIsInDatabase: addressToFindInDatabase

	|addresses|
	addresses := self obtainAddressFromDatabase: addressToFindInDatabase.
	self assertResponse: addresses onlyContainsOneAddressAndThatAddressIs: addressToFindInDatabase.! !

!ImportTest methodsFor: 'assertions' stamp: 'SC 11/13/2023 21:56:18'!
assertCustomer: aCustomer isTheSameAs: anotherCustomer

	self assert: anotherCustomer identificationType equals: aCustomer identificationType .
	self assert: anotherCustomer identificationNumber equals: aCustomer identificationNumber .
	self assert: anotherCustomer firstName equals: aCustomer firstName .
	self assert: anotherCustomer lastName equals: aCustomer lastName! !

!ImportTest methodsFor: 'assertions' stamp: 'FC 11/15/2023 23:41:45'!
assertCustomerIsInDatabase: customerToFindInDatabase

	| customers |
	customers := self obtainCustomerFromDatabase: customerToFindInDatabase.
	self assertResponse: customers onlyContainsOneCustomerAndThatCustomerIs: customerToFindInDatabase! !

!ImportTest methodsFor: 'assertions' stamp: 'FC 11/16/2023 00:12:12'!
assertResponse: addresses onlyContainsOneAddressAndThatAddressIs: addressToFindInDatabase

	| address |

	self assert: addresses size equals: 1.
	address := addresses anyOne.
	self assertAddress: addressToFindInDatabase isTheSameAs: address! !

!ImportTest methodsFor: 'assertions' stamp: 'FC 11/15/2023 23:41:58'!
assertResponse: customers onlyContainsOneCustomerAndThatCustomerIs: customerToFindInDatabase

	|customer|
	self assert: customers size equals: 1.
	customer := customers anyOne.
	self assertCustomer: customerToFindInDatabase isTheSameAs: customer! !


!ImportTest methodsFor: 'database access' stamp: 'FC 11/16/2023 00:28:53'!
importCustomersWithStream: inputStream
	self setUp.
	(CustomerImporter withSession: session andInputStream: inputStream) import.
	self tearDown.! !

!ImportTest methodsFor: 'database access' stamp: 'FC 11/15/2023 23:58:15'!
obtainAddressFromDatabase: addressToFindInDatabase

	^ session
		select: [:anAddress | (anAddress province = addressToFindInDatabase province ) & (anAddress streetName = addressToFindInDatabase streetName ) & (anAddress streetNumber = addressToFindInDatabase streetNumber ) & (anAddress town = addressToFindInDatabase town) & (anAddress zipCode = addressToFindInDatabase zipCode )]
		ofType: Address! !

!ImportTest methodsFor: 'database access' stamp: 'SC 11/13/2023 21:57:05'!
obtainCustomerFromDatabase: customerToObtainFromDatabase

	^ session
		select: [:aCustomer | (aCustomer firstName = customerToObtainFromDatabase firstName) & (aCustomer lastName = customerToObtainFromDatabase lastName) & (aCustomer identificationType = customerToObtainFromDatabase identificationType) & (aCustomer identificationNumber = customerToObtainFromDatabase identificationNumber ) ]
		ofType: Customer! !


!ImportTest methodsFor: 'tests' stamp: 'FC 11/16/2023 00:32:07'!
test01ImportedCustomersAreCorrect

	| numberOfCustomers numberOfAddresses |
	self importCustomersWithStream: (self inputTextStream).
	numberOfCustomers := (session selectAllOfType: Customer) size.
	self assert: numberOfCustomers equals: 2.
	
	self assertCustomerIsInDatabase: self pepe .
	self assertCustomerIsInDatabase: self juan.
	
	numberOfAddresses := (session selectAllOfType: Address) size.
	self assert: numberOfAddresses equals: 3.
	
	self assertAddressIsInDatabase: self maipu.
	self assertAddressIsInDatabase: self sanMartin.
	self assertAddressIsInDatabase: self alem 
	
	
	
	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'FC 11/15/2023 23:43:00'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction.
	
	! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'SC 11/13/2023 20:34:47'!
tearDown

	session commit.
	session close! !


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
	instanceVariableNames: 'inputStream selfi session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'FC 11/16/2023 00:28:41'!
initializeWithSession: aSession andInputStream: anInputStream
	inputStream := anInputStream.
	session := aSession.! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'FC 11/16/2023 00:28:22'!
import

	"
	self importCustomers
	"
	| newCustomer line |

	line := inputStream nextLine.
	[ line notNil ] whileTrue: [
		(line beginsWith: 'C') ifTrue: [ | customerData |
			customerData := line findTokens: $,.
			newCustomer := Customer new.
			newCustomer firstName: customerData second.
			newCustomer lastName: customerData third.
			newCustomer identificationType: customerData fourth.
			newCustomer identificationNumber: customerData fifth.
			session persist: newCustomer ].

		(line beginsWith: 'A') ifTrue: [ | addressData newAddress |
			addressData := line findTokens: $,.
			newAddress := Address new.
			newCustomer addAddress: newAddress.
			newAddress streetName: addressData second.
			newAddress streetNumber: addressData third asNumber .
			newAddress town: addressData fourth.
			newAddress zipCode: addressData fifth asNumber .
			newAddress province: addressData sixth ].

		line := inputStream nextLine. ].

	inputStream close.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'FC 11/16/2023 00:29:08'!
withSession: aSession andInputStream: anInputStream
	^self new initializeWithSession: aSession andInputStream: anInputStream! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 00:19:29'!
beginTransaction

	! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 19:17:36'!
commit

	(tables at: Customer ifAbsent: [#()]) do: [ :aCustomer | self persistAddressesOf: aCustomer ]
	! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 5/22/2022 00:19:29'!
close

	! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 19:29:06'!
objectsOfType: aType

	^ tables at: aType ifAbsent: [ #() ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
persistAddressesOf: anObjectWithAddresses

	anObjectWithAddresses addresses do: [ :anAddress | self persist: anAddress ]
	! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 5/22/2022 00:19:29'!
persist: anObject

	| table |

	self delay.
	table := tables at: anObject class ifAbsentPut: [ Set new ].

	self defineIdOf: anObject.
	table add: anObject.

	(anObject isKindOf: Customer) ifTrue: [ self persistAddressesOf: anObject ].! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
select: aCondition ofType: aType

	self delay.
	^(self objectsOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
selectAllOfType: aType

	self delay.
	^(self objectsOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !
