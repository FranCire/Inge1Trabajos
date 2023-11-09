!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self assert: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSellByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 18:09'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:50'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: cashier checkOut = (testObjectsFactory itemSellByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:04'!
test04CheckoutRegistersASale

	| cart cashier salesBook total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	total := cashier checkOut.
					
	self assert: salesBook size = 1.
	self assert: salesBook first total = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:00'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:59'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkOut ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 19:03'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'HernanWilkinson 6/17/2013 19:02'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #TusLibrosInterfaceTest category: 'TusLibros'!
TestCase subclass: #TusLibrosInterfaceTest
	instanceVariableNames: 'interface invalidClient validClient validClientPassword storeTestObjectsFactory nextYear previousYear flexibleClock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:45:54'!
setUp
	storeTestObjectsFactory := StoreTestObjectsFactory new.
	nextYear := Month month: DateAndTime now monthIndex year: DateAndTime now yearNumber + 1.
	previousYear := Month month: DateAndTime now monthIndex year: DateAndTime now yearNumber - 1.
	flexibleClock := FlexibleClock now.

	interface := TusLibrosInterface with: ValidClientIDAndPasswordValidatorStud new andIDGenerator: CartIDGeneratorStud new andCatalogue: (storeTestObjectsFactory defaultCatalog) andMerchantProcessor: (MerchantProcessor new) andInternalClock: flexibleClock.
	invalidClient := -1.
	validClient := 1.
	validClientPassword := 'pepe'.
	
	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'SC 11/6/2023 21:29:45'!
test01createedCartIsListed
	| cartID |
	cartID := interface createCartByUser:validClient withPassword: validClientPassword.
	self shouldnt: [interface listCart: cartID] raise: Error.! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:45:54'!
test02shouldCreateCartWithInvalidUserRaiseAnError
	| cartID invalidInterface|
	invalidInterface := TusLibrosInterface with: InvalidClientIDAndPasswordValidatorStud new andIDGenerator: CartIDGeneratorStud new andCatalogue: (storeTestObjectsFactory defaultCatalog) andMerchantProcessor: (MerchantProcessor new) andInternalClock: flexibleClock.
	self should: [ cartID := invalidInterface createCartByUser:invalidClient withPassword: validClientPassword.]
	raise: Error
	withExceptionDo: [ :anError |
		self assert: anError messageText = TusLibrosInterface invalidUserOrPasswordErrorMessage.
		self should: [invalidInterface listCart: cartID] 
		raise: Error withExceptionDo: [:anotherError | 
			self assert: anotherError messageText = TusLibrosInterface invalidCartIDErrorMessage]]! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 00:56:00'!
test03CanAddBookInCatalogueToExistingCart
	| cartID |
	cartID := interface createCartByUser:validClient withPassword: validClientPassword.
	interface add: 1 ofBook: storeTestObjectsFactory itemSellByTheStore toCart: cartID.
	self assert: (interface listCart: cartID) size equals: 1.
	self assert: ((interface listCart: cartID) includes: storeTestObjectsFactory itemSellByTheStore ).

	
! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 01:02:25'!
test04CannotAddBookNotInCatalogueToExistingCart
	| cartID |
	cartID := interface createCartByUser:validClient withPassword: validClientPassword.
	self should: [interface add: 1 ofBook: storeTestObjectsFactory itemNotSellByTheStore toCart: cartID] raise:Error withExceptionDo: [:error |
		self assert: error messageText equals: (Cart itemNotInCatalogueErrorDescription).
		self assert: (interface listCart: cartID) isEmpty].
	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:45:54'!
test05CannotAddBookToNonExistentCart
	self should: [interface add: 1 ofBook: storeTestObjectsFactory itemNotSellByTheStore toCart: 1] raise:Error withExceptionDo: [:error |
		self assert: error messageText equals: (TusLibrosInterface invalidCartIDErrorMessage).].
	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:45:54'!
test06CannotListNonExistentCart
	self should: [interface listCart:1 ] raise:Error withExceptionDo: [:error |
		self assert: error messageText equals: (TusLibrosInterface invalidCartIDErrorMessage).].
	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 01:12:06'!
test07ListOfNewCartIsEmpty
	|cartId|
	cartId := interface createCartByUser: validClient withPassword: validClientPassword.
	self assert: (interface listCart: cartId) isEmpty .
	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 01:14:23'!
test08ListWhenJustOneCartIsItemsOfThatCart
	|cartId|
	cartId := interface createCartByUser: validClient withPassword: validClientPassword.
	interface add: 3 ofBook: storeTestObjectsFactory itemSellByTheStore toCart:cartId.
	self assert: (interface listCart: cartId) size equals: 3.
	self assert: ((interface listCart: cartId) occurrencesOf: (storeTestObjectsFactory itemSellByTheStore)) equals: 3.
	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 01:17:26'!
test09ListWhenMultipleCartsInInterface
	|cartId anotherCartId |
	cartId := interface createCartByUser: validClient withPassword: validClientPassword.
	anotherCartId := interface createCartByUser: validClient withPassword: validClientPassword.
	interface add: 3 ofBook: storeTestObjectsFactory itemSellByTheStore toCart:cartId.
	interface add: 2 ofBook: storeTestObjectsFactory itemSellByTheStore toCart:anotherCartId.

	self assert: (interface listCart: cartId) size equals: 3.
	self assert: ((interface listCart: cartId) occurrencesOf: (storeTestObjectsFactory itemSellByTheStore)) equals: 3.
	self assert: (interface listCart: anotherCartId) size equals: 2.
	self assert: ((interface listCart: anotherCartId) occurrencesOf: (storeTestObjectsFactory itemSellByTheStore)) equals: 2.


	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'SC 11/9/2023 02:00:39'!
test10ExistingCartWithItemsCanCheckOut
	|cartId |
	cartId := interface createCartByUser: validClient withPassword: validClientPassword.
	interface add: 1 ofBook: storeTestObjectsFactory itemSellByTheStore toCart:cartId.

	self assert: (interface checkoutCart: cartId withCreditCardWithNumber: 1234 expiringOn: nextYear whoseOwnerIs: 'pepe') equals: storeTestObjectsFactory itemSellByTheStorePrice .




	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:45:54'!
test11NonExistingCartCannotCheckOut

	self should: [interface checkoutCart: 3 withCreditCardWithNumber: 1234 expiringOn: nextYear whoseOwnerIs: 'pepe'] raise:Error withExceptionDo: [:error |
		self assert: error messageText equals: (TusLibrosInterface invalidCartIDErrorMessage).].


	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:45:54'!
test12ExistingCartWithNoItemsCannotCheckOut
	|cartId |
	cartId := interface createCartByUser: validClient withPassword: validClientPassword.
	
	self should: [interface checkoutCart: cartId withCreditCardWithNumber: 1234 expiringOn: nextYear whoseOwnerIs: 'pepe'] raise:Error withExceptionDo: [:error |
		self assert: error messageText equals: (TusLibrosInterface cannotCheckOutEmptyCartErrorDescrpition).].


	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'SC 11/9/2023 02:04:27'!
test13CannotCheckOutWithExpiredCreditCard
	|cartId |
	cartId := interface createCartByUser: validClient withPassword: validClientPassword.
	interface add: 1 ofBook: storeTestObjectsFactory itemSellByTheStore toCart:cartId.
	
	self should: [interface checkoutCart: cartId withCreditCardWithNumber: 1234 expiringOn: previousYear whoseOwnerIs: 'pepe'] raise:Error withExceptionDo: [:error |
		self assert: error messageText equals: (Cashier canNotChargeAnExpiredCreditCardErrorMessage ).].


	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:45:54'!
test14CannotListPurchasesOfInvalidUsernameAndPassword
	| invalidInterface |
	invalidInterface := TusLibrosInterface with: InvalidClientIDAndPasswordValidatorStud new andIDGenerator: CartIDGeneratorStud new andCatalogue: (storeTestObjectsFactory defaultCatalog) andMerchantProcessor: (MerchantProcessor new) andInternalClock: flexibleClock.
	self should: [invalidInterface listPurchasesOf: 1 withPassword: 'pepe'.] raise: Error withExceptionDo: [:error |
		self assert: error messageText equals: TusLibrosInterface invalidUserOrPasswordErrorMessage].

	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 02:20:28'!
test15PurchasesOfClientWhoDidntBuyAnythingAreEmpty
	
	self assert: (interface listPurchasesOf: 1 withPassword: 'pepe') isEmpty.

	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 02:25:25'!
test16PurchasesOfClientWhoPurchasedOnce
	| cartId |
	cartId := interface createCartByUser: validClient withPassword: validClientPassword.
	interface add: 2 ofBook: storeTestObjectsFactory itemSellByTheStore toCart:cartId.
	interface checkoutCart: cartId withCreditCardWithNumber: 1234 expiringOn: nextYear whoseOwnerIs: 'pepe'.
	self assert: (interface listPurchasesOf: validClient withPassword: validClientPassword) size equals: 2.
	self assert: ((interface listPurchasesOf: validClient withPassword: validClientPassword) occurrencesOf: storeTestObjectsFactory itemSellByTheStore) equals: 2.! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 02:50:04'!
test17PurchasesOfClientWhoPurchasedMoreThanOnce
	| cartId anotherCartId|
	cartId := interface createCartByUser: validClient withPassword: validClientPassword.
	anotherCartId := interface createCartByUser: validClient withPassword: validClientPassword.
	interface add: 2 ofBook: storeTestObjectsFactory itemSellByTheStore toCart:cartId.
	interface checkoutCart: cartId withCreditCardWithNumber: 1234 expiringOn: nextYear whoseOwnerIs: 'pepe'.
	interface add: 7 ofBook: storeTestObjectsFactory itemSellByTheStore toCart: anotherCartId.
	interface checkoutCart: anotherCartId withCreditCardWithNumber: 1234 expiringOn: nextYear whoseOwnerIs: 'pepe'.

	self assert: (interface listPurchasesOf: validClient withPassword: validClientPassword) size equals: 9.
	self assert: ((interface listPurchasesOf: validClient withPassword: validClientPassword) occurrencesOf: storeTestObjectsFactory itemSellByTheStore) equals: 9.! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:45:54'!
test18CannotAddBooksToExpiredCart
	| cartId |
	cartId := interface createCartByUser: validClient withPassword: validClientPassword.
	flexibleClock timeLeapBy: 31 minutes.
	self should: [interface add: 1 ofBook:storeTestObjectsFactory itemSellByTheStore toCart: cartId] raise: Error withExceptionDo: [:error | self assert: error messageText equals: TusLibrosInterface cartInactivityErrorDescription.
		flexibleClock timeLeapBy: -2 minutes.
		self assert: (interface listCart:cartId) isEmpty.

		self shouldnt:[interface add: 1 ofBook:storeTestObjectsFactory itemSellByTheStore toCart: cartId] raise: Error].

	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:45:54'!
test19CannotCheckoutExpiredCart
	| cartId |
	cartId := interface createCartByUser: validClient withPassword: validClientPassword.
	interface add: 2 ofBook: storeTestObjectsFactory itemSellByTheStore toCart:cartId.

	flexibleClock timeLeapBy: 31 minutes.
	self should: [interface checkoutCart: cartId withCreditCardWithNumber: 1234 expiringOn: nextYear whoseOwnerIs: 'pepe'] raise: Error withExceptionDo: [:error | self assert: error messageText equals: TusLibrosInterface cartInactivityErrorDescription.
		flexibleClock timeLeapBy: -2 minutes.
		self assert: (interface listPurchasesOf: validClient withPassword: validClientPassword) isEmpty.
		self shouldnt:[interface checkoutCart: cartId withCreditCardWithNumber: 1234 expiringOn: nextYear whoseOwnerIs: 'pepe'] raise: Error].

	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:45:54'!
test20CannotListExpiredCart
	| cartId |
	cartId := interface createCartByUser: validClient withPassword: validClientPassword.
	interface add: 2 ofBook: storeTestObjectsFactory itemSellByTheStore toCart:cartId.

	flexibleClock timeLeapBy: 31 minutes.
	self should: [interface listCart: cartId] raise: Error withExceptionDo: [:error | self assert: error messageText equals: TusLibrosInterface cartInactivityErrorDescription.
		flexibleClock timeLeapBy: -2 minutes.
		self shouldnt:[interface listCart: cartId ] raise: Error].

	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:45:54'!
test21ExpiryTimeIsRefreshedWhenUsed
	| cartId |
	cartId := interface createCartByUser: validClient withPassword: validClientPassword.
	flexibleClock timeLeapBy: 20 minutes.
	interface add: 1 ofBook: storeTestObjectsFactory itemSellByTheStore toCart: cartId.
	flexibleClock timeLeapBy: 31 minutes.
	self should: [	interface add: 1 ofBook: storeTestObjectsFactory itemSellByTheStore toCart: cartId.] raise:Error withExceptionDo: [:error | 
		self assert: error messageText equals: TusLibrosInterface cartInactivityErrorDescription.
		flexibleClock timeLeapBy: -2 minutes.
		self shouldnt:[interface listCart: cartId ] raise: Error
	]


! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:06'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 17:48'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'FC 11/9/2023 00:53:05'!
items
	^items! !

!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 19:09'!
total

	^ items sum: [ :anItem | catalog at: anItem ]! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !

!Cart class methodsFor: 'instance creation' stamp: 'FC 11/9/2023 01:01:34'!
itemNotInCatalogueErrorDescription
	^'Item is not in catalog'! !


!classDefinition: #CartIDGeneratorStud category: 'TusLibros'!
Object subclass: #CartIDGeneratorStud
	instanceVariableNames: 'count'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartIDGeneratorStud methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 00:23:43'!
generateIDForCart: cartToGenerateIDFor
	count := count + 1.
	^count! !

!CartIDGeneratorStud methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 00:23:56'!
initialize
	count := 1.! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:07'!
createSale

	^ Sale of: total
! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
debitTotal

	merchantProcessor debit: total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
registerSale

	salesBook add: self createSale! !


!Cashier methodsFor: 'checkout' stamp: 'HernanWilkinson 6/17/2013 19:06'!
checkOut

	self calculateTotal.
	self debitTotal.
	self registerSale.

	^ total! !


!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:53'!
initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self error: self cartCanNotBeEmptyErrorMessage ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:23'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [ self error: self canNotChargeAnExpiredCreditCardErrorMessage ]! !


!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:51'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 19:02'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !


!classDefinition: #ClientIDAndPasswordValidatorStud category: 'TusLibros'!
Object subclass: #ClientIDAndPasswordValidatorStud
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!ClientIDAndPasswordValidatorStud methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 00:01:49'!
validate: username and: password

	self subclassResponsibility! !


!classDefinition: #InvalidClientIDAndPasswordValidatorStud category: 'TusLibros'!
ClientIDAndPasswordValidatorStud subclass: #InvalidClientIDAndPasswordValidatorStud
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InvalidClientIDAndPasswordValidatorStud methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:45:54'!
validate: username and: password
	self error: TusLibrosInterface invalidUserOrPasswordErrorMessage ! !


!classDefinition: #ValidClientIDAndPasswordValidatorStud category: 'TusLibros'!
ClientIDAndPasswordValidatorStud subclass: #ValidClientIDAndPasswordValidatorStud
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!ValidClientIDAndPasswordValidatorStud methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 00:02:23'!
validate: username and: password
	! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate 
	
	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:38'!
initializeExpiringOn: aMonth 
	
	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #FlexibleClock category: 'TusLibros'!
Object subclass: #FlexibleClock
	instanceVariableNames: 'clockTime'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!FlexibleClock methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 03:51:16'!
initializeIn: timeToInitializeTo
	clockTime := timeToInitializeTo.! !

!FlexibleClock methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 03:50:56'!
now
	^clockTime! !

!FlexibleClock methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 03:50:41'!
timeLeapBy: amountOfTimeToLeap
	clockTime := clockTime + amountOfTimeToLeap.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FlexibleClock class' category: 'TusLibros'!
FlexibleClock class
	instanceVariableNames: ''!

!FlexibleClock class methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 03:51:48'!
in: aTime
	^self new initializeIn: aTime.! !

!FlexibleClock class methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 03:52:17'!
now
	^self in: DateAndTime now.! !


!classDefinition: #MerchantProcessor category: 'TusLibros'!
Object subclass: #MerchantProcessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessor methodsFor: 'as yet unclassified' stamp: 'SC 11/9/2023 01:46:10'!
debit: anAmountToDebit from: aCreditCard
! !


!classDefinition: #Sale category: 'TusLibros'!
Object subclass: #Sale
	instanceVariableNames: 'total itemsSold'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 18:48'!
total
	
	^ total! !


!Sale methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:47'!
initializeTotal: aTotal

	total := aTotal ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:47'!
of: aTotal

	"should assert total is not negative or 0!!"
	^self new initializeTotal: aTotal ! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStorePrice
	
	^10! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
defaultCatalog
	
	^ Dictionary new
		at: self itemSellByTheStore put: self itemSellByTheStorePrice;
		yourself ! !


!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:37'!
expiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber - 1)! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:36'!
notExpiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber + 1)! !


!StoreTestObjectsFactory methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:37'!
initialize

	today := DateAndTime now! !


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !


!classDefinition: #TusLibrosInterface category: 'TusLibros'!
Object subclass: #TusLibrosInterface
	instanceVariableNames: 'carts clientIDAndPasswordValidator idGenerator catalogue purchasesOf ownersOfCarts merchantProcessor lastUseOfCart internalClock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!
!TusLibrosInterface commentStamp: 'SC 11/6/2023 21:34:22' prior: 0!
createCartByUser: aClientID withPassword: aPassword
	
	Dictionary add:a
	^1!


!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:14:05'!
add: quantity ofBook: bookISBN toCart: cartID
	self assertCartIDExists: cartID.
	self assertTimeSinceLastCartUseIsValid: cartID.
	self refreshLastUseOfCart: cartID.
	(carts at: cartID) add: quantity of: bookISBN.! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:45:54'!
assertCartIDExists: aCartID

	^ (carts includesKey: aCartID) ifFalse: [self error: TusLibrosInterface invalidCartIDErrorMessage ]! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:43:50'!
assertCartIsNotEmpty: aCartID

	^ (carts at: aCartID) isEmpty ifTrue:[self error: self class cannotCheckOutEmptyCartErrorDescrpition ]! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:46:30'!
assertTimeSinceLastCartUseIsValid: cartID

	^ ((lastUseOfCart at: cartID) + self maximumInactivityTimeForCart <= self now) ifTrue: [self error: self class cartInactivityErrorDescription ]! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:43:32'!
assertValidClientID: aClientID andPassword: aPassword

	^ clientIDAndPasswordValidator validate: aClientID and: aPassword! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 05:08:23'!
checkoutCart: aCartID withCreditCardWithNumber: aCreditCardNumber expiringOn: anExpiringMonthOfYear whoseOwnerIs: anOwnerName
	| creditCard total cartOwner |
	
	^self withCart: aCartID do: [
		self assertCartIsNotEmpty: aCartID.
		cartOwner := (ownersOfCarts at: aCartID).
		creditCard := CreditCard expiringOn: anExpiringMonthOfYear.
		
		total := (Cashier toCheckout: (carts at:aCartID) charging: creditCard throught: merchantProcessor on: internalClock now registeringOn: OrderedCollection new) checkOut.
		
		(purchasesOf at: cartOwner) addAll: (self listCart: aCartID).
		
		^total
	].
	! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:39:53'!
createCartByUser: aClientID withPassword: aPassword
	| cartForUser idForCart |
	^self withClientID: aClientID andPassword: aPassword  do: [
		self assertValidClientID: aClientID andPassword: aPassword.
		self createPurchaseLogIfFirstAccess: aClientID.
		
		cartForUser := Cart acceptingItemsOf: catalogue.
		idForCart := idGenerator generateIDForCart: cartForUser.
		self registerCart: cartForUser andOwnerID: aClientID andCreationTimeForCartID: idForCart.
		
		^idForCart
	]! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 05:08:23'!
createPurchaseLogIfFirstAccess: aClientID

	(purchasesOf includesKey: aClientID) ifFalse: [purchasesOf add: (aClientID -> OrderedCollection new).]! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 05:08:23'!
initialize
	purchasesOf := Dictionary new.
	ownersOfCarts := Dictionary new.
	carts := Dictionary new.
	lastUseOfCart := Dictionary new.! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:43:32'!
initializeWith: clientIDAndPasswordValidatorToInitializeWith andIDGenerator: idGeneratorToInitializeWith andCatalogue: catalogueToInitializeWith andMerchantProcessor: merchantProcessorToInitializeWith andInternalClock: internalClockToInitializeWith
	clientIDAndPasswordValidator := clientIDAndPasswordValidatorToInitializeWith.
	idGenerator := idGeneratorToInitializeWith.
	catalogue := catalogueToInitializeWith.
	merchantProcessor := merchantProcessorToInitializeWith.
	internalClock := internalClockToInitializeWith.
! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:39:46'!
listCart: aCartID
	^self withCart: aCartID do: [^(carts at: aCartID) items.]

	! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 05:08:23'!
listPurchasesOf: aClientID withPassword: password
	^self withClientID: aClientID andPassword: password do: 
		[^purchasesOf at: aClientID ifAbsent: [^OrderedCollection new]].
	

	! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:46:30'!
maximumInactivityTimeForCart

	^ 30 minutes! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 03:26:03'!
now
	^internalClock now.
	

	! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:16:19'!
refreshLastUseOfCart: cartID

	^ lastUseOfCart at: cartID put: self now! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:32:28'!
registerCart: cartForUser andOwnerID: aClientID andCreationTimeForCartID: idForCart

	carts add: (idForCart -> cartForUser).
	ownersOfCarts add: (idForCart -> aClientID ).
	lastUseOfCart add: (idForCart -> self now).! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:37:58'!
withCart: cartID do: aClosure
	| result |
	self assertCartIDExists: cartID.
	self assertTimeSinceLastCartUseIsValid: cartID.
	result := aClosure value.
	self refreshLastUseOfCart: cartID.
	^result
! !

!TusLibrosInterface methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 04:37:13'!
withClientID: aClientID andPassword: password do: aClosure
	self assertValidClientID: aClientID andPassword: password.
	^aClosure value.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosInterface class' category: 'TusLibros'!
TusLibrosInterface class
	instanceVariableNames: ''!

!TusLibrosInterface class methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 01:03:37'!
cannotAddBookToNonExistentCartErrorDescription
	^'Cannot add book to non-existent cart'! !

!TusLibrosInterface class methodsFor: 'as yet unclassified' stamp: 'SC 11/9/2023 01:55:59'!
cannotCheckOutEmptyCartErrorDescrpition
	^'Cannot checkout an empty cart'! !

!TusLibrosInterface class methodsFor: 'as yet unclassified' stamp: 'SC 11/9/2023 02:01:48'!
cannotCheckOutWithExpiredCreditCardErrorDescription
	^'Cannot check out with expired credit card'! !

!TusLibrosInterface class methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 03:27:31'!
cartInactivityErrorDescription
	^'More than 30 minutes have transpired since the cart was last used, making it invalid.'! !

!TusLibrosInterface class methodsFor: 'as yet unclassified' stamp: 'SC 11/6/2023 21:17:37'!
invalidCartIDErrorMessage
	^'CartID is not valid'! !

!TusLibrosInterface class methodsFor: 'as yet unclassified' stamp: 'SC 11/6/2023 21:17:41'!
invalidUserOrPasswordErrorMessage
	^'User or password is not correct'! !

!TusLibrosInterface class methodsFor: 'as yet unclassified' stamp: 'FC 11/9/2023 03:25:28'!
with: usernameAndPasswordValidator andIDGenerator: idGenerator andCatalogue: aCatalogue andMerchantProcessor: aMerchantProcessor andInternalClock: internalClock
	^self new initializeWith: usernameAndPasswordValidator andIDGenerator: idGenerator andCatalogue: aCatalogue andMerchantProcessor: aMerchantProcessor andInternalClock: internalClock.! !
