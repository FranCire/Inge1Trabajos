!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'SC 10/9/2023 21:54:15'!
test01BalanceOfNewPortfolioIsZero
	|portfolio| 
	portfolio := Portfolio new.
	
	self assert: (portfolio balance) equals: 0.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:00:57'!
test02BalanceOfPortfolioWithOneAccountIsBalanceOfAccount
	|portfolio account| 
	portfolio := Portfolio new.
	account := ReceptiveAccount new.
	Deposit register: 100 on: account. 
	portfolio add: account.
	
	self assert: (portfolio balance) equals: 100.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:00:57'!
test03BalanceOfPortfolioWithTwoAccountIsSumOfBalanceOfAccounts
	|portfolio account1 account2 | 
	portfolio := Portfolio new.
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	Deposit register: 100 on: account1. 
	Deposit register: 150 on: account2.
	portfolio add: account1.
	portfolio add: account2.
	
	self assert: (portfolio balance) equals: 250.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:00:57'!
test04BalanceOfPortfolioWithMultipleAccountsIsSumOfBalanceOfAccounts
	|portfolio account1 account2 account3 account4| 
	portfolio := Portfolio new.
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	account4 := ReceptiveAccount new.
	Deposit register: 100 on: account1. 
	Deposit register: 150 on: account2.
	Withdraw register: 100 on: account3.
	Withdraw register: 50 on: account4.
	portfolio add: account1.
	portfolio add: account2.
	portfolio add: account3.
	portfolio add: account4.
	
	self assert: (portfolio balance) equals: 100.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test05BalanceOfPortfolioWithPortfolioIsBalanceOfInnerPortfolio
	|portfolio1 portfolio2 account1| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	account1 := ReceptiveAccount new.
	Deposit register: 100 on: account1. 
	portfolio2 add: account1.
	portfolio1 add: portfolio2.
	
	self assert: (portfolio1 balance) equals: 100.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test06BalanceOfPortfolioWithPortfolioAndAccountIsBalanceOfInnerPortfolio
	|portfolio1 portfolio2 account1 account2| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	Deposit register: 100 on: account1.
	Withdraw register: 50 on: account2. 
	portfolio2 add: account1.
	portfolio1 add: portfolio2.
	portfolio1 add: account2.
	
	self assert: (portfolio1 balance) equals: 50.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test07BalanceOfPortfolioWithMultipleSurfacePortfoliosIsSumOfBalanceOfPortfolios
	|portfolio1 portfolio2 portfolio3 portfolio4 account1 account2 account3| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.
	portfolio4 := Portfolio new.
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	Deposit register: 100 on: account1.
	Withdraw register: 50 on: account2. 
	Withdraw register: 10 on: account3.
	portfolio2 add: account1.
	portfolio3 add: account2.
	portfolio4 add: account3.
	portfolio1 add: portfolio2.
	portfolio1 add: portfolio3.
	portfolio1 add: portfolio4.
	
	self assert: (portfolio1 balance) equals: 40.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test08BalanceOfNestedPortfoliosWhereTheMiddleOneHasNoAccountsIsBalanceOfDeepestOne
	|portfolio1 portfolio2 portfolio3 account1 account2| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	Deposit register: 100 on: account1.
	Withdraw register: 50 on: account2. 
	portfolio3 add: account1.
	portfolio3 add: account2.
	portfolio1 add: portfolio2.
	portfolio2 add: portfolio3.
	
	self assert: (portfolio1 balance) equals: 50.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:00:57'!
test09CannotAddSameAccountTwiceToPortfolio
	|portfolio1 account| 
	portfolio1 := Portfolio new.
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	
	portfolio1 add: account.
	self should:
		[portfolio1 add: account] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test10CannotAddAccountThatIsAlreadyInInnerPortfolio
	|portfolio1 portfolio2 account| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	
	account := ReceptiveAccount new.


	Deposit register: 100 on: account.

	
	portfolio2 add: account.
	portfolio1 add: portfolio2.
	self should:
		[portfolio1 add: account] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test11CannotAddAccountThatIsAlreadyInDoublyInnerPortfolio
	|portfolio1 portfolio2 portfolio3 account| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.
	
	account := ReceptiveAccount new.


	Deposit register: 100 on: account.

	
	portfolio3 add: account.
	portfolio2 add: portfolio3.
	portfolio1 add: portfolio2.
	self should:
		[portfolio1 add: account] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test12CannotAddAccountThatIsAlreadyInOneParentPortfolio
	|portfolio1 portfolio2 account| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	
	account := ReceptiveAccount new.


	Deposit register: 100 on: account.

	
	portfolio2 add: account.
	portfolio2 add: portfolio1.
	self should:
		[portfolio1 add: account] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test13CannotAddAccountThatIsAlreadyInOneOfManyParentPortfolio
	|portfolio1 portfolio2 portfolio3 account| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.
	
	account := ReceptiveAccount new.


	Deposit register: 100 on: account.

	
	portfolio2 add: account.
	portfolio2 add: portfolio1.
	portfolio3 add: portfolio1.

	self should:
		[portfolio1 add: account] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test14CannotAddAccountThatIsAlreadyInDoublyParentPortfolio
	|portfolio1 portfolio2 portfolio3 account| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.
	
	account := ReceptiveAccount new.


	Deposit register: 100 on: account.

	
	portfolio3 add: account.
	portfolio3 add: portfolio2.
	portfolio2 add: portfolio1.

	self should:
		[portfolio1 add: account] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test15CannotAddPortfolioToItself
	|portfolio1| 
	portfolio1 := Portfolio new.

	self should:
		[portfolio1 add: portfolio1] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test16CannotAddPortfolioThatIsAlreadyThere
	|portfolio1 portfolio2| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	
	portfolio1 add: portfolio2.

	self should:
		[portfolio1 add: portfolio2] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test17CannotAddPortfolioThatAnInnerPortfolioHas
	|portfolio1 portfolio2 portfolio3| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.
	
	portfolio2 add: portfolio3.
	portfolio1 add: portfolio2.
	

	self should:
		[portfolio1 add: portfolio3] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test18CannotAddPortfolioThatAnUpperPortfolioHas
	|portfolio1 portfolio2 portfolio3| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.
	
	portfolio2 add: portfolio3.
	portfolio2 add: portfolio1.
	

	self should:
		[portfolio1 add: portfolio3] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test19CannotAddPortfolioThatADoublyUpperPortfolioHas
	|portfolio1 portfolio2 portfolio3 portfolio4| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.
	portfolio4 := Portfolio new.
	
	portfolio4 add: portfolio2.
	portfolio4 add: portfolio3.
	portfolio2 add: portfolio1.
	

	self should:
		[portfolio1 add: portfolio3] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test20CannotAddParentPortfolio
	|portfolio1 portfolio2| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	
	portfolio2 add: portfolio1.

	self should:
		[portfolio1 add: portfolio2] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test21CannotAddPortfolioThatHasRepeatedAccount
	|portfolio1 portfolio2 account| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	account := ReceptiveAccount new.
	portfolio1 add: account.
	portfolio2 add: account.
	
	self should:
		[portfolio1 add: portfolio2 ] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test22CannotAddPortfolioThatHasPortfolioWithRepeatedAccount
	|portfolio1 portfolio2 portfolio3 account| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.
	account := ReceptiveAccount new.
	portfolio1 add: account.
	portfolio3 add: account.
	portfolio2 add: portfolio3.
	
	self should:
		[portfolio1 add: portfolio2 ] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test23CannotAddPortfolioThatHasAccountThatIsInInnerPortfolio
	|portfolio1 portfolio2 portfolio3 account| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.
	account := ReceptiveAccount new.
	portfolio1 add: account.
	portfolio3 add: account.
	portfolio2 add: portfolio1.
	
	self should:
		[portfolio2 add: portfolio3 ] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test24CannotAddPortfolioThatHasAccountThatIsInUpperPortfolio
	|portfolio1 portfolio2 portfolio3 account| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.
	account := ReceptiveAccount new.
	portfolio2 add: account.
	portfolio3 add: account.
	portfolio2 add: portfolio1.
	
	self should:
		[portfolio1 add: portfolio3 ] raise:Error withExceptionDo: [:error |
			self assert: Portfolio cannotAddErrorDescription equals: error messageText.]
	
	
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 03:29:57'!
test25NewPortfolioHasNoTransactionRegistered
	|portfolio1 transaction| 
	portfolio1 := Portfolio new.
	transaction := Deposit for: 100.
	self deny: (portfolio1 hasRegistered: transaction)! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:00:57'!
test26PortfolioWithOneAccountHasTransactionRegistered
	|portfolio1 transaction account| 
	portfolio1 := Portfolio new.
	transaction := Deposit for: 100.
	account := ReceptiveAccount new.
	account register: transaction.
	portfolio1 add: account.
	self assert: (portfolio1 hasRegistered: transaction).! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:00:57'!
test27PortfolioWithMoreThanOneAccountHasTransactionRegistered
	|portfolio1 transaction account1 account2 account3| 
	portfolio1 := Portfolio new.
	transaction := Deposit for: 100.
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	account3 register: transaction.
	portfolio1 add: account1.
	portfolio1 add: account2.
	portfolio1 add: account3.

	self assert: (portfolio1 hasRegistered: transaction).! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test28PortfolioWithTransactionInsideAnotherPortfolioIsRegistered
	|portfolio1 portfolio2 transaction account1| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	transaction := Deposit for: 100.
	account1 := ReceptiveAccount new.
	account1 register: transaction.
	portfolio2 add: account1.
	portfolio1 add: portfolio2.
	

	self assert: (portfolio1 hasRegistered: transaction).! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test29PortfolioWithTransactionTwoPortfoliosDeepIsRegistered
	|portfolio1 portfolio2 portfolio3 transaction account1| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.
	transaction := Deposit for: 100.
	account1 := ReceptiveAccount new.
	account1 register: transaction.
	portfolio3 add: account1.
	portfolio2 add: portfolio3.
	portfolio1 add: portfolio2.
	

	self assert: (portfolio1 hasRegistered: transaction).! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 03:32:30'!
test30TransactionsOfNewPortfolioAreEmpty
	|portfolio1 | 
	portfolio1 := Portfolio new.
	
	

	self assert: ((portfolio1 transactions) isEmpty ).! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:00:57'!
test31TransactionsOfPortfolioWithJustAccountsAreTransactionsOfAccounts
	|portfolio1 transaction1 transaction2 transaction3 account1 account2 account3| 
	portfolio1 := Portfolio new.
	transaction1 := Deposit for: 100.
	transaction2 := Deposit for: 100.
	transaction3 := Deposit for: 100.

	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	account1 register: transaction1.
	account2 register: transaction2.
	account3 register: transaction3.
	portfolio1 add: account1.
	portfolio1 add: account2.
	portfolio1 add: account3.
	
	self assert: (portfolio1 transactions) size equals: 3.
	self assert: (portfolio1 transactions) includes: transaction1 .
	self assert: (portfolio1 transactions) includes: transaction2.
	self assert: (portfolio1 transactions) includes: transaction3 .! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 05:01:31'!
test32TransactionsOfPortfolioWithPortfolioAndAccountsInside
	|portfolio1 portfolio2 transaction1 transaction2 transaction3 account1 account2 account3| 
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	transaction1 := Deposit for: 100.
	transaction2 := Deposit for: 100.
	transaction3 := Deposit for: 100.

	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	account1 register: transaction1.
	account2 register: transaction2.
	account3 register: transaction3.
	portfolio1 add: account1.
	portfolio2 add: account2.
	portfolio2 add: account3.
	portfolio1 add: portfolio2.
	
	self assert: (portfolio1 transactions) size equals: 3.
	self assert: (portfolio1 transactions) includes: transaction1 .
	self assert: (portfolio1 transactions) includes: transaction2.
	self assert: (portfolio1 transactions) includes: transaction3 .! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 5/17/2021 17:29:53'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #Account category: 'Portfolio-Ejercicio'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Account methodsFor: 'testing' stamp: 'FC 10/19/2023 04:26:23'!
assertDoesNotHaveAccountInInnerAccounts: accountToCheck

	self subclassResponsibility! !

!Account methodsFor: 'testing' stamp: 'FC 10/19/2023 05:30:20'!
assertInnerTreeDoesNotHaveAccount: accountToFind

	self subclassResponsibility! !

!Account methodsFor: 'testing' stamp: 'FC 10/19/2023 05:30:27'!
assertInnerTreeDoesNotHaveIntersectionWithInnerTreeOfAccount: accountWithInnerTree

	self subclassResponsibility! !

!Account methodsFor: 'testing' stamp: 'FC 10/19/2023 04:30:50'!
failIfSameAccount: accountToCompare

	^ (accountToCompare = self) ifTrue: [self cannotAddError.]! !

!Account methodsFor: 'testing' stamp: 'FC 10/19/2023 04:00:59'!
hasRegistered: transactionToCheckForRegister

	self subclassResponsibility! !


!Account methodsFor: 'balance' stamp: 'FC 10/19/2023 05:34:53'!
addToBalanceOfAccount: balanceOfAccount
	^balanceOfAccount + self balance.! !

!Account methodsFor: 'balance' stamp: 'FC 10/19/2023 04:00:52'!
balance

	self subclassResponsibility! !


!Account methodsFor: 'errors' stamp: 'FC 10/19/2023 04:29:43'!
cannotAddError

	^ self error: self class cannotAddErrorDescription! !


!Account methodsFor: 'adding' stamp: 'FC 10/19/2023 05:30:05'!
addParentPortfolio: parentPortfolioToAdd

	self subclassResponsibility! !


!Account methodsFor: 'transactions' stamp: 'FC 10/19/2023 05:52:15'!
addTransactionsTo: transactionsToAddTo

	self subclassResponsibility! !

!Account methodsFor: 'transactions' stamp: 'FC 10/19/2023 04:01:08'!
transactions

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Account class' category: 'Portfolio-Ejercicio'!
Account class
	instanceVariableNames: ''!

!Account class methodsFor: 'as yet unclassified' stamp: 'FC 10/19/2023 04:28:35'!
cannotAddErrorDescription
	^'No se puede agregar eso'! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
Account subclass: #Portfolio
	instanceVariableNames: 'parentPortfolios accounts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'initialization' stamp: 'FC 10/19/2023 05:35:59'!
initialize
	parentPortfolios := OrderedCollection new.
	accounts := OrderedCollection new.! !


!Portfolio methodsFor: 'transactions' stamp: 'FC 10/19/2023 05:48:25'!
addTransactionsTo: transactionsToAddTo
	accounts do: [:account | account addTransactionsTo: transactionsToAddTo].
	
	 
	
	! !

!Portfolio methodsFor: 'transactions' stamp: 'FC 10/19/2023 05:51:52'!
transactions
	|transactions|
	transactions := OrderedCollection new.
	self addTransactionsTo: transactions.
	^transactions 
	
	! !


!Portfolio methodsFor: 'testing' stamp: 'FC 10/19/2023 05:20:23'!
assertEntireTreeDoesNotHaveIntersectionWithInnerTreeOfAccount: accountWithInnerTree
	(self isRootOfPortfolioTree) ifTrue: [self assertInnerTreeDoesNotHaveIntersectionWithInnerTreeOfAccount: accountWithInnerTree].
	parentPortfolios do: [:parentPortfolio | parentPortfolio assertEntireTreeDoesNotHaveIntersectionWithInnerTreeOfAccount: accountWithInnerTree].
	
	! !

!Portfolio methodsFor: 'testing' stamp: 'FC 10/19/2023 05:16:08'!
assertInnerTreeDoesNotHaveAccount: accountToFind
	self failIfSameAccount: accountToFind.
	accounts do: [:account | account assertInnerTreeDoesNotHaveAccount: accountToFind].
	
	! !

!Portfolio methodsFor: 'testing' stamp: 'FC 10/19/2023 05:18:50'!
assertInnerTreeDoesNotHaveIntersectionWithInnerTreeOfAccount: accountWithInnerTree
	accountWithInnerTree assertInnerTreeDoesNotHaveAccount: self.
	accounts do: [:account | account assertInnerTreeDoesNotHaveIntersectionWithInnerTreeOfAccount: accountWithInnerTree].
	
	! !

!Portfolio methodsFor: 'testing' stamp: 'FC 10/19/2023 05:27:57'!
hasRegistered: transactionToCheckForRegister
	^accounts anySatisfy: [:account | account hasRegistered: transactionToCheckForRegister ].! !

!Portfolio methodsFor: 'testing' stamp: 'FC 10/18/2023 19:27:46'!
isRootOfPortfolioTree
	^parentPortfolios isEmpty	
	
	! !


!Portfolio methodsFor: 'adding' stamp: 'FC 10/19/2023 05:23:09'!
add: accountToAdd
	self assertEntireTreeDoesNotHaveIntersectionWithInnerTreeOfAccount: accountToAdd.
	accounts add: accountToAdd.
	accountToAdd addParentPortfolio: self.! !

!Portfolio methodsFor: 'adding' stamp: 'FC 10/19/2023 05:01:55'!
addParentPortfolio: parentPortfolioToAdd
	
	parentPortfolios add: parentPortfolioToAdd ! !


!Portfolio methodsFor: 'balance' stamp: 'FC 10/19/2023 05:33:59'!
balance
	^accounts inject: 0 into: [:accountsBalanceAcc :account | account addToBalanceOfAccount: accountsBalanceAcc].
	
	! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'FC 10/19/2023 05:48:12'!
addTransactionsTo: transactionsToAddTo
	transactionsToAddTo addAll: self transactions.
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'FC 10/19/2023 05:32:38'!
balance
	
	
	^transactions inject:0 into:[ :balanceAcc :aTransaction | aTransaction addToBalanceOfAccount: balanceAcc].
	! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'FC 10/19/2023 04:31:02'!
assertDoesNotHaveAccountInInnerAccounts: accountToCheck
	self failIfSameAccount: accountToCheck.! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'FC 10/19/2023 05:22:17'!
assertInnerTreeDoesNotHaveAccount: accountToFind
	self failIfSameAccount: accountToFind.! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'FC 10/19/2023 05:21:32'!
assertInnerTreeDoesNotHaveIntersectionWithInnerTreeOfAccount: accountWithInnerTree
	accountWithInnerTree assertInnerTreeDoesNotHaveAccount: self.! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !


!ReceptiveAccount methodsFor: 'adding' stamp: 'FC 10/19/2023 05:23:25'!
addParentPortfolio: parentPortfolioToAdd
	
! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'SC 10/9/2023 21:35:28'!
addToBalanceOfAccount: accountBalance

	self subclassResponsibility! !

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'SC 10/9/2023 21:35:28'!
addToBalanceOfAccount: accountBalance
	^accountBalance + value! !

!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'SC 10/9/2023 21:35:28'!
addToBalanceOfAccount: accountBalance
	^accountBalance - value! !

!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !
