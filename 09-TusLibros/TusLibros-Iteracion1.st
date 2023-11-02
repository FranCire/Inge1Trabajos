!classDefinition: #CartTests category: 'TusLibros'!
TestCase subclass: #CartTests
	instanceVariableNames: 'cart editorialCatalogue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTests methodsFor: 'tests' stamp: 'SC 10/30/2023 20:34:15'!
test01CartStartsEmpty
	self assert: cart isEmpty.! !

!CartTests methodsFor: 'tests' stamp: 'SC 10/30/2023 20:33:49'!
test02CartIsNotEmptyWhenProductIsAdded
	self deny: (cart addProduct: 1922) isEmpty! !

!CartTests methodsFor: 'tests' stamp: 'SC 10/30/2023 20:32:18'!
test03CartOnlyContainsElementThatIsAdded

	cart addProduct: 1922.
	self assert: cart size equals: 1.
	self assert: (cart amountOfProduct: 1922) equals: 1.! !

!CartTests methodsFor: 'tests' stamp: 'SC 10/30/2023 20:32:18'!
test04CartCanAddMultipleDifferentElements

	cart addProduct: 1922.
	cart addProduct: 1923.
	cart addProduct: 1924.
	self assert: cart size equals: 3.
	self assert: (cart amountOfProduct: 1922) equals: 1.
	self assert: (cart amountOfProduct: 1923) equals: 1.
	self assert: (cart amountOfProduct: 1924) equals: 1.! !

!CartTests methodsFor: 'tests' stamp: 'SC 10/30/2023 20:32:18'!
test05CartCanAddMultipleUnitsOfSameProductAtATime

	cart add:3 ofProduct: 1922.
	self assert: cart size equals: 3.
	self assert: (cart amountOfProduct: 1922) equals: 3.! !

!CartTests methodsFor: 'tests' stamp: 'SC 10/30/2023 20:32:18'!
test06AddingSingleProductsAndMultipleProductsAtATime
	cart add:3 ofProduct: 1922.
	cart addProduct: 1922.
	cart addProduct: 1922.
	self assert: cart size equals:5.
	self assert: (cart amountOfProduct: 1922) equals: 5.! !

!CartTests methodsFor: 'tests' stamp: 'SC 10/30/2023 20:46:27'!
test07CannotAddNonPositiveIntegerUnitsOfProduct
	self should: [cart add: 0 ofProduct: 1922] raise: Error withExceptionDo: [:error | 
		self assert: Cart cannotAddNonPositiveOrNonIntegerUnitsOfProductErrorDescription equals: error messageText.
		self assert: cart size equals: 0.
	].! !

!CartTests methodsFor: 'tests' stamp: 'SC 10/30/2023 20:46:44'!
test08CannotAddNonIntegerUnitsOfProduct
	self should: [cart add: 1.3 ofProduct: 1922] raise: Error withExceptionDo: [:error | 
		self assert: Cart cannotAddNonPositiveOrNonIntegerUnitsOfProductErrorDescription equals: error messageText.
		self assert: cart size equals: 0.
	].! !

!CartTests methodsFor: 'tests' stamp: 'SC 10/30/2023 20:46:18'!
test09CannotAddISBNNotInEditorialCatalogue
	self should: [cart addProduct: 247248] raise: Error withExceptionDo: [:error | 
		self assert: Cart cannotAddProductOutsideEditorialCatalogueErrorDescription equals: error messageText.
		self assert: cart size equals: 0.
	].! !


!CartTests methodsFor: 'setUp' stamp: 'SC 10/30/2023 20:32:35'!
setUp
	editorialCatalogue := Set with: 1922 with: 1923 with: 1924.
	cart := Cart withEditorialCatalogue: editorialCatalogue.! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'products editorialCatalogue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'evaluating' stamp: 'SC 10/30/2023 19:42:34'!
isEmpty
	^products isEmpty! !


!Cart methodsFor: 'initialization' stamp: 'SC 10/30/2023 19:47:08'!
initialize
	products := Bag new.! !

!Cart methodsFor: 'initialization' stamp: 'SC 10/30/2023 20:26:42'!
initializeWithEditorialCatalogue: editorialCatalogueForCart
	editorialCatalogue := editorialCatalogueForCart! !


!Cart methodsFor: 'error handling' stamp: 'SC 10/30/2023 20:28:18'!
assertBookToAddToCartIsInEditorialCatalogue: ISBNofBookToAdd

	^ (editorialCatalogue includes: ISBNofBookToAdd) ifFalse: [self cannotAddProductOutsideEditorialCatalogueError]! !

!Cart methodsFor: 'error handling' stamp: 'SC 10/30/2023 20:45:56'!
assertNumberOfUnitsToAddIsPositiveInteger: numberOfUnitsToAdd

	^ (numberOfUnitsToAdd > 0 and:numberOfUnitsToAdd isInteger ) ifFalse: [self cannotAddNonPositiveOrNonIntegerUnitsOfProductError]! !

!Cart methodsFor: 'error handling' stamp: 'SC 10/30/2023 20:42:21'!
cannotAddNonPositiveOrNonIntegerUnitsOfProductError

	^ self error: self class cannotAddNonPositiveOrNonIntegerUnitsOfProductErrorDescription! !

!Cart methodsFor: 'error handling' stamp: 'SC 10/30/2023 20:28:18'!
cannotAddProductOutsideEditorialCatalogueError

	^ self error: self class cannotAddProductOutsideEditorialCatalogueErrorDescription! !


!Cart methodsFor: 'adding' stamp: 'SC 10/30/2023 20:44:28'!
add: numberOfUnitsToAdd ofProduct: ISBNofBookToAdd
	self assertNumberOfUnitsToAddIsPositiveInteger: numberOfUnitsToAdd.
	self assertBookToAddToCartIsInEditorialCatalogue: ISBNofBookToAdd.
	products add: ISBNofBookToAdd withOccurrences: numberOfUnitsToAdd.! !

!Cart methodsFor: 'adding' stamp: 'SC 10/30/2023 20:10:01'!
addProduct: ISBNofBookToAdd
	self add: 1 ofProduct: ISBNofBookToAdd ! !


!Cart methodsFor: 'accessing' stamp: 'SC 10/30/2023 19:46:49'!
amountOfProduct: ISBNofBookToCheckForAmount
	^products occurrencesOf: ISBNofBookToCheckForAmount.! !

!Cart methodsFor: 'accessing' stamp: 'SC 10/30/2023 19:45:18'!
size
	^products size! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'error handling' stamp: 'SC 10/30/2023 20:42:41'!
cannotAddNonPositiveOrNonIntegerUnitsOfProductErrorDescription
	^'Cannot add non-positive or non-integer units of product to cart'! !

!Cart class methodsFor: 'error handling' stamp: 'SC 10/30/2023 20:36:39'!
cannotAddProductOutsideEditorialCatalogueErrorDescription
	^'Cannot add product outside editorial catalogue to cart'.! !


!Cart class methodsFor: 'instance creation' stamp: 'SC 10/30/2023 20:33:02'!
withEditorialCatalogue: editorialCatalogueForCart
	^self new initializeWithEditorialCatalogue: editorialCatalogueForCart ! !
