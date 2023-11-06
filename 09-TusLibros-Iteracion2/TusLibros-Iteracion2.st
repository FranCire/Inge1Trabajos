!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:08'!
test01NewCartsAreCreatedEmpty

	self assert: self createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [ cart add: self itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HAW 11/2/2023 17:12:35'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: self itemSellByTheStore withOcurrences: 0  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HAW 11/2/2023 17:12:46'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add:  self itemNotSellByTheStore withOcurrences: 2  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test06CartRemembersAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self assert: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := self createCart.
	
	self deny: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HAW 11/2/2023 17:12:59'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore withOcurrences: 2.
	self assert: (cart occurrencesOf: self itemSellByTheStore) = 2! !


!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:48'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:43'!
defaultCatalog
	
	^ Array with: self itemSellByTheStore! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:44'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:43'!
itemSellByTheStore
	
	^ 'validBook'! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'priceCatalogue notExpiredCreditCard expiredCreditCard itemCatalogue cart cashier stolenCardCashier notEnoughMoneyCashier validPaymentCashier stolenCardMerchantProcessor notEnoughMoneyMerchantProcessor validPaymentMerchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'testing' stamp: 'FC 11/6/2023 01:02:07'!
test01CannotCheckOutEmptyCart
	self should: [validPaymentCashier checkOut: cart with: notExpiredCreditCard ] raise: Error withExceptionDo: [:error | 
		self assert: (Cashier cannotCheckOutEmptyCartErrorDescription) equals: error messageText.
		self assert: validPaymentCashier purchases isEmpty.].
	
	! !

!CashierTest methodsFor: 'testing' stamp: 'FC 11/6/2023 01:03:51'!
test02PriceOfCartWithOneItemIsPriceOfItem

	cart add:1.
	self assert: (validPaymentCashier priceOf: cart) equals: 100.
	
	! !

!CashierTest methodsFor: 'testing' stamp: 'FC 11/6/2023 01:03:54'!
test03PriceOfCartWithMultipleDifferentItemsIsSumOfPrices
	cart add:1.
	cart add:2.
	cart add:3.
	self assert: (validPaymentCashier priceOf: cart) equals: 300.
	
	! !

!CashierTest methodsFor: 'testing' stamp: 'FC 11/6/2023 01:09:54'!
test04PriceOfCartWithMultipleRepeatedItemsIsSumOfPrices
	cart add:1.
	cart add:1.
	cart add:2.
	self assert: (validPaymentCashier priceOf: cart) equals: 300.
	
	! !

!CashierTest methodsFor: 'testing' stamp: 'FC 11/6/2023 01:09:57'!
test05CannotCheckOutWithExpiredCreditCard
	cart add:1.
	self should: [validPaymentCashier checkOut: cart with: expiredCreditCard ] raise: Error withExceptionDo: [:error | 
		self assert: (Cashier cannotCheckOutWithExpiredCreditCardErrorDescription) equals: error messageText.
		self assert: validPaymentCashier purchases isEmpty].
	
	! !

!CashierTest methodsFor: 'testing' stamp: 'FC 11/6/2023 01:04:11'!
test06CanCheckOutWithNotExpiredCreditCard

	cart add:1.
	validPaymentCashier checkOut: cart with: notExpiredCreditCard .
	self assert: validPaymentCashier purchases size equals: 1.
	self assert: validPaymentCashier purchases first equals: (validPaymentCashier priceOf: cart).
	
	! !

!CashierTest methodsFor: 'testing' stamp: 'FC 11/6/2023 01:04:40'!
test07CannotPayWithStolenCreditCard
	cart add:1.
	cart add:1.
	cart add:2.
	self should: [stolenCardCashier checkOut: cart with: notExpiredCreditCard ] raise: Error withExceptionDo: [:error | 
		self assert: Cashier cannotCheckOutWithStolenCreditCardErrorDescription equals: error messageText.
		self assert: stolenCardCashier purchases isEmpty].
	! !

!CashierTest methodsFor: 'testing' stamp: 'FC 11/6/2023 01:09:30'!
test08CannotPayWithCreditCardWithoutEnoughMoney
	cart add:1.
	cart add:1.
	cart add:2.
	self should: [notEnoughMoneyCashier checkOut: cart with: notExpiredCreditCard ] raise: Error withExceptionDo: [:error | 
		self assert: Cashier cannotCheckOutWithoutEnoughMoneyOnCreditCardErrorDescription equals: error messageText.
		self assert: notEnoughMoneyCashier purchases isEmpty].
	! !

!CashierTest methodsFor: 'testing' stamp: 'FC 11/6/2023 01:05:02'!
test09CorrectAmountIsDebitedFromCreditCardWithNoIssues
	| debited |
	cart add:1.
	cart add:1.
	cart add:2.
	debited := validPaymentCashier checkOut: cart with: 	notExpiredCreditCard.
	self assert: validPaymentMerchantProcessor debitedCreditCard equals: notExpiredCreditCard.
	self assert: debited equals: validPaymentMerchantProcessor amountDebited.
	! !


!CashierTest methodsFor: 'setup' stamp: 'FC 11/6/2023 01:09:30'!
setUp
	priceCatalogue := (Dictionary newFromPairs:( OrderedCollection with: 1 with: 100 with: 2 with:100 with:3 with:100)).
	cart := Cart acceptingItemsOf: (Set with: 1 with: 2 with: 3).
	notExpiredCreditCard := CreditCard with: 4021 whichExpiresOn:(FixedGregorianDate today monthOfYear) next andOwnedBy: 'Tino'.
	expiredCreditCard := CreditCard with: 4021  whichExpiresOn:(FixedGregorianDate today monthOfYear) previous andOwnedBy: 'Tino'.
	stolenCardMerchantProcessor := StolenCreditCardMerchantProcessorSimulator new.
	notEnoughMoneyMerchantProcessor := NotEnoughMoneyCreditCardMerchantProcessorSimulator new.
	validPaymentMerchantProcessor := ValidPaymentCreditCardMerchantProcessorSimulator new.
	stolenCardCashier := Cashier with: priceCatalogue and: stolenCardMerchantProcessor.
	notEnoughMoneyCashier := Cashier with: priceCatalogue and: notEnoughMoneyMerchantProcessor.
	validPaymentCashier := Cashier with: priceCatalogue and: validPaymentMerchantProcessor.
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


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidItem: anItem

	(catalog includes: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 17:48'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'SC 11/2/2023 19:36:43'!
items
	^items copy! !

!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'HAW 11/2/2023 17:13:30'!
add: anItem

	^ self add: anItem withOcurrences: 1 ! !

!Cart methodsFor: 'adding' stamp: 'HAW 11/2/2023 17:13:19'!
add: anItem withOcurrences: aQuantity

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	items add: anItem withOccurrences: aQuantity .
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cataloguePrices numberOfPurchases merchantProcessor amountDebited purchases'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'accessing' stamp: 'FC 11/6/2023 01:01:07'!
purchases
	^purchases! !


!Cashier methodsFor: 'testing' stamp: 'SC 11/2/2023 18:55:30'!
assertCartToCheckOutIsNotEmpty: cartToCheckOut

	^ (cartToCheckOut isEmpty) ifTrue: [self cannotCheckOutEmptyCartError]! !

!Cashier methodsFor: 'testing' stamp: 'SC 11/2/2023 21:37:04'!
assertCreditCardIsNotExpired: creditCardToCheckIfExpired

	^ (creditCardToCheckIfExpired isExpired) ifTrue: [self cannotCheckOutWithExpiredCreditCardError.]! !


!Cashier methodsFor: 'error handling' stamp: 'SC 11/2/2023 18:55:30'!
cannotCheckOutEmptyCartError

	^ self error: self class cannotCheckOutEmptyCartErrorDescription! !

!Cashier methodsFor: 'error handling' stamp: 'SC 11/2/2023 19:20:21'!
cannotCheckOutWithExpiredCreditCardError

	^ self error: self class cannotCheckOutWithExpiredCreditCardErrorDescription! !


!Cashier methodsFor: 'initialization' stamp: 'FC 11/6/2023 01:05:42'!
initializeWith: cataloguePricesToInitiliazeWith and: merchantProcessorToInitializeWith
	cataloguePrices := cataloguePricesToInitiliazeWith.
	merchantProcessor := merchantProcessorToInitializeWith.
	purchases := OrderedCollection new.! !


!Cashier methodsFor: 'checkout' stamp: 'FC 11/6/2023 00:20:58'!
checkOut: cartToCheckOut with: creditCard
	self assertCartToCheckOutIsNotEmpty: cartToCheckOut.
	self assertCreditCardIsNotExpired: creditCard.
	^self debit: (self priceOf: cartToCheckOut) from: creditCard.
! !

!Cashier methodsFor: 'checkout' stamp: 'FC 11/6/2023 01:01:29'!
debit: amountToDebit from: creditCard
	amountDebited := merchantProcessor debit: amountToDebit from: creditCard.
	purchases add: amountDebited.  
	^amountDebited  
	                                                      ! !

!Cashier methodsFor: 'checkout' stamp: 'SC 11/2/2023 19:57:45'!
priceOf: cartToGetValueOf
	^(cartToGetValueOf items) sum: [:item | cataloguePrices at: item].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'as yet unclassified' stamp: 'SC 11/2/2023 18:47:11'!
cannotCheckOutEmptyCartErrorDescription
	^'No se puede hacer checkout de un carrito vacío'.! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'SC 11/2/2023 19:16:26'!
cannotCheckOutWithExpiredCreditCardErrorDescription
	^'No se puede hacer checkout con una tarjeta expirada'.! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'FC 11/6/2023 00:12:02'!
cannotCheckOutWithStolenCreditCardErrorDescription
	^'No se puede hacer checkout con una tarjeta robada'.! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'FC 11/6/2023 00:28:12'!
cannotCheckOutWithoutEnoughMoneyOnCreditCardErrorDescription
	^'No se puede hacer checkout con una tarjeta sin suficiente dinero'.! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'SC 11/2/2023 19:43:59'!
with: cataloguePrices
	^self new initializeWith: cataloguePrices! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'FC 11/6/2023 00:42:29'!
with: cataloguePrices and: merchantProcessor
	^self new initializeWith: cataloguePrices and: merchantProcessor ! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'creditCardNumber expiryDate creditCardOwnerName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'initialization' stamp: 'SC 11/2/2023 21:34:43'!
initializeWith: creditCardNumberToInitializeWith whichExpiresOn: expiryDateOfCreditCard andOwnedBy: creditCardOwnerNameToInitializeWith
	creditCardNumber := creditCardNumberToInitializeWith.
	expiryDate := expiryDateOfCreditCard.
	creditCardOwnerName := creditCardNumberToInitializeWith 
	! !


!CreditCard methodsFor: 'expiration' stamp: 'SC 11/2/2023 21:36:03'!
isExpired
	^self isExpiredBy: FixedGregorianDate today monthOfYear ! !

!CreditCard methodsFor: 'expiration' stamp: 'SC 11/2/2023 21:35:44'!
isExpiredBy: aMonthOfYear
	^ (expiryDate) < (aMonthOfYear)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'as yet unclassified' stamp: 'SC 11/2/2023 21:32:09'!
with: creditCardNumber whichExpiresOn: expiryDateOfCreditCard andOwnedBy: creditCardOwnerName
	^self new initializeWith: creditCardNumber whichExpiresOn: expiryDateOfCreditCard andOwnedBy: creditCardOwnerName.! !


!classDefinition: #MerchantProcessorSimulator category: 'TusLibros'!
Object subclass: #MerchantProcessorSimulator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorSimulator methodsFor: 'debit' stamp: 'FC 11/6/2023 00:26:25'!
debit: amountToDebit from: creditCardToDebitFrom

	self subclassResponsibility! !


!classDefinition: #NotEnoughMoneyCreditCardMerchantProcessorSimulator category: 'TusLibros'!
MerchantProcessorSimulator subclass: #NotEnoughMoneyCreditCardMerchantProcessorSimulator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!NotEnoughMoneyCreditCardMerchantProcessorSimulator methodsFor: 'debit' stamp: 'FC 11/6/2023 00:28:41'!
debit: amountToDebit from: creditCardToDebitFrom
	self error: Cashier cannotCheckOutWithoutEnoughMoneyOnCreditCardErrorDescription! !


!classDefinition: #StolenCreditCardMerchantProcessorSimulator category: 'TusLibros'!
MerchantProcessorSimulator subclass: #StolenCreditCardMerchantProcessorSimulator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StolenCreditCardMerchantProcessorSimulator methodsFor: 'debit' stamp: 'FC 11/6/2023 00:29:04'!
debit: amountToDebit from: creditCardToDebitFrom
	self error: Cashier cannotCheckOutWithStolenCreditCardErrorDescription ! !


!classDefinition: #ValidPaymentCreditCardMerchantProcessorSimulator category: 'TusLibros'!
MerchantProcessorSimulator subclass: #ValidPaymentCreditCardMerchantProcessorSimulator
	instanceVariableNames: 'amountDebited debitedCreditCard'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!ValidPaymentCreditCardMerchantProcessorSimulator methodsFor: 'debit' stamp: 'FC 11/6/2023 00:50:04'!
amountDebited
	^amountDebited ! !

!ValidPaymentCreditCardMerchantProcessorSimulator methodsFor: 'debit' stamp: 'FC 11/6/2023 00:49:53'!
debit: amountToDebit from: creditCardToDebitFrom
	amountDebited := amountToDebit.
	debitedCreditCard := creditCardToDebitFrom.
	^amountToDebit ! !

!ValidPaymentCreditCardMerchantProcessorSimulator methodsFor: 'debit' stamp: 'FC 11/6/2023 00:50:10'!
debitedCreditCard
	^debitedCreditCard ! !
