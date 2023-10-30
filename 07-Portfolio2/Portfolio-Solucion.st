!classDefinition: #PortfolioTest category: 'Portfolio-Solucion'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 5/27/2021 17:36:04'!
test02BalanceOfPortfolioWithAccountsIsSumOfAccountsBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:23:25'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:11'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:06'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 6/22/2020 07:31:19'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #PortfolioTreeTest category: 'Portfolio-Solucion'!
TestCase subclass: #PortfolioTreeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTreeTest methodsFor: 'tests' stamp: 'FC 10/26/2023 03:07:04'!
test01PortfolioTreeOfPortfolioIsPortfolioName
	|portfolio1 portfolioTree|
	portfolio1  := Portfolio named: 'Portfolio de Tino'.
	portfolioTree := OrderedCollection new.
	portfolioTree add:'Portfolio de Tino'.
	self assert: (PortfolioTreeReport of: portfolio1) equals: portfolioTree.	! !

!PortfolioTreeTest methodsFor: 'tests' stamp: 'FC 10/26/2023 03:07:04'!
test02PortfolioTreeOfPortfolioWithReceptiveAccounts
	|portfolio1 account1 account2 portfolioTree|
	account1 := ReceptiveAccount named: 'Cuenta de Anto'.
	account2 := ReceptiveAccount named: 'Cuenta de Fran'.
	portfolio1 := Portfolio named:'Portfolio de Tino' with: account1 with: account2.
	portfolioTree := OrderedCollection new.
	portfolioTree add:'Portfolio de Tino'.
	portfolioTree add:'   Cuenta de Anto'.
	portfolioTree add:'   Cuenta de Fran'.
	self assert: (PortfolioTreeReport of: portfolio1) equals: portfolioTree.	! !

!PortfolioTreeTest methodsFor: 'tests' stamp: 'FC 10/26/2023 03:07:04'!
test03PortfolioTreeOfPortfolioWithPortfolioAndAccount
	|johnsAccount angiesAccount childrenPortfolio myAccount familyPortfolio portfolioTree|
	johnsAccount := ReceptiveAccount named: 'Cuenta de Juan'.
	angiesAccount := ReceptiveAccount named: 'Cuenta de Angeles'.
	childrenPortfolio := Portfolio named: 'Portfolio de hijos' with:
	johnsAccount with: angiesAccount.
	myAccount := ReceptiveAccount named: 'Cuenta Mia'.
	familyPortfolio := Portfolio named: 'Portfolio de la familia' with:
	myAccount with: childrenPortfolio.
	
	portfolioTree := OrderedCollection new.
	portfolioTree add:'Portfolio de la familia'.
	portfolioTree add:'   Cuenta Mia'.
	portfolioTree add:'   Portfolio de hijos'.
	portfolioTree add:'      Cuenta de Juan'.
	portfolioTree add:'      Cuenta de Angeles'.
	self assert: portfolioTree equals: (PortfolioTreeReport of: familyPortfolio )
! !

!PortfolioTreeTest methodsFor: 'tests' stamp: 'FC 10/26/2023 03:07:04'!
test04PortfolioTreeOfPortfolioWithMultiplePortfolios
	|johnsAccount angiesAccount childrenPortfolio familyPortfolio portfolioTree cousinsPortfolio juancitosAccount pepitosAccount|
	johnsAccount := ReceptiveAccount named: 'Cuenta de Juan'.
	angiesAccount := ReceptiveAccount named: 'Cuenta de Angeles'.
	juancitosAccount := ReceptiveAccount named:'Cuenta de Juancito'.
	pepitosAccount := ReceptiveAccount named: 'Cuenta de Pepito'.
	Transfer from: johnsAccount to: juancitosAccount for: 50.
	Transfer from: angiesAccount to: juancitosAccount for:50.
	cousinsPortfolio := Portfolio named: 'Portfolio de primos' with: juancitosAccount with: pepitosAccount .
	childrenPortfolio := Portfolio named: 'Portfolio de hijos' with:
	johnsAccount with: angiesAccount.
	familyPortfolio := Portfolio named: 'Portfolio de la familia' with:
	cousinsPortfolio with: childrenPortfolio.
	
	portfolioTree := OrderedCollection new.
	portfolioTree add:'Portfolio de la familia'.
	portfolioTree add:'   Portfolio de primos'.
	portfolioTree add:'      Cuenta de Juancito'.
	portfolioTree add:'      Cuenta de Pepito'.
	portfolioTree add:'   Portfolio de hijos'.
	portfolioTree add:'      Cuenta de Juan'.
	portfolioTree add:'      Cuenta de Angeles'.
	self assert: portfolioTree equals: (PortfolioTreeReport of: familyPortfolio )
! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:54'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:02'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
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

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:54'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:21:24'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1 equals: account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #SpecialPortfolioReportTest category: 'Portfolio-Solucion'!
TestCase subclass: #SpecialPortfolioReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!SpecialPortfolioReportTest methodsFor: 'tests' stamp: 'FC 10/26/2023 02:33:28'!
test01SpecialReportOfNewPortfolioIsJustTheBalanceWithName
	|portfolio report|
	portfolio := Portfolio named: 'Portfolio de Tino'.
	report := OrderedCollection with: 'Portfolio de Tino' with: '   Balance = 0'.
	self assert: (SpecialPortfolioReport of: portfolio) equals: report.! !

!SpecialPortfolioReportTest methodsFor: 'tests' stamp: 'SC 10/26/2023 03:57:09'!
test02SpecialReportOfPortfolioWithAccounts
	|portfolio1 account1 account2 report|
	account1 := ReceptiveAccount named: 'Cuenta de Anto'.
	Deposit register: 100 on: account1.
	Withdraw register: 50 on: account1.
	account2 := ReceptiveAccount named: 'Cuenta de Fran'.
	Deposit register: 50 on: account2.
	Deposit register: 20 on: account2.
	portfolio1 := Portfolio named:'Portfolio de Tino' with: account1 with: account2.
	report := OrderedCollection new.
	report add:'Portfolio de Tino'.
	report add:'   Cuenta de Anto'.
	report add:'      Depósito por 100'.
	report add:'      Extracción por 50'.
	report add:'      Balance = 50'.
	report add:'   Cuenta de Fran'.
	report add:'      Depósito por 50'.
	report add:'      Depósito por 20'.
	report add:'      Balance = 70'.
	report add:'   Balance = 120'.
	self assert: (SpecialPortfolioReport of:portfolio1) equals: report.! !

!SpecialPortfolioReportTest methodsFor: 'tests' stamp: 'SC 10/26/2023 03:57:26'!
test03SpecialReportOfPortfolioWithPortfolioAndAccount
	"Salida por transferencia de 25."
	|johnsAccount angiesAccount childrenPortfolio myAccount familyPortfolio report|
	johnsAccount := ReceptiveAccount named: 'Cuenta de Juan'.
	angiesAccount := ReceptiveAccount named: 'Cuenta de Angeles'.
	childrenPortfolio := Portfolio named: 'Portfolio de hijos' with:
	johnsAccount with: angiesAccount.
	myAccount := ReceptiveAccount named: 'Cuenta Mia'.
	Deposit register:100 on: myAccount.
	Transfer from: myAccount to: johnsAccount for: 30.
	familyPortfolio := Portfolio named: 'Portfolio de la familia' with:
	myAccount with: childrenPortfolio.
	
	report := OrderedCollection new.
	report add:'Portfolio de la familia'.
	report add:'   Cuenta Mia'.
	report add:'      Depósito por 100'.
	report add:'      Salida por transferencia de 30'.
	report add:'      Balance = 70'.
	report add:'   Portfolio de hijos'.
	report add:'      Cuenta de Juan'.
	report add:'         Entrada por transferencia de 30'.
	report add:'         Balance = 30'.
	report add:'      Cuenta de Angeles'.
	report add:'         Balance = 0'.
	report add:'      Balance = 30'.
	report add:'   Balance = 100'.
	self assert: report equals: (SpecialPortfolioReport of: familyPortfolio )! !


!classDefinition: #TransactionBasedReportsTest category: 'Portfolio-Solucion'!
TestCase subclass: #TransactionBasedReportsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransactionBasedReportsTest methodsFor: 'tests' stamp: 'SC 10/26/2023 04:06:07'!
test01AccountSummaryOfNewAccountIsJustBalanceIsZero
	|account summary|
	account := ReceptiveAccount new.
	summary := OrderedCollection new.
	summary add: 'Balance = 0'.
	self assert: (AccountSummary of: account) equals: summary.! !

!TransactionBasedReportsTest methodsFor: 'tests' stamp: 'SC 10/26/2023 04:05:13'!
test02AccountSummaryOfAccountWithDepositWithdrawSenderAndReceiverLeg
	|account1 account2 summary|
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	Deposit register: 100 on: account1.
	Withdraw register: 50 on: account1.
	Transfer from: account1 to: account2 for: 25.
	Transfer from: account2 to: account1 for: 30. 
	summary := OrderedCollection new.
	summary add: 'Depósito por 100'.
	summary add: 'Extracción por 50'.
	summary add: 'Salida por transferencia de 25'.
	summary add: 'Entrada por transferencia de 30'.
	summary add: 'Balance = 55'.
	self assert: (AccountSummary of: account1) equals: summary.! !

!TransactionBasedReportsTest methodsFor: 'tests' stamp: 'FC 10/25/2023 02:29:01'!
test03TransferNetOfNewAccountWithoutTransactionsIsZero
	|account1 |
	account1 := ReceptiveAccount new.
	Deposit register:100 on: account1.
	Withdraw register:30 on: account1.
	self assert: (TransferNet of: account1) equals: 0.! !

!TransactionBasedReportsTest methodsFor: 'tests' stamp: 'FC 10/25/2023 02:29:12'!
test04TransferNetOfAccountWithReceivingAndSendingTransfersIsCorrectlyHandled
	|account1 account2|
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	Deposit register:100 on: account1.
	Withdraw register:30 on: account1.
	Transfer from: account1 to: account2 for: 30.
	Transfer from: account2 to: account1 for: 50.
	
	self assert: (TransferNet of: account1) equals: 20.! !

!TransactionBasedReportsTest methodsFor: 'tests' stamp: 'SC 10/26/2023 04:05:22'!
test05AccountSummaryOfNewPortfolioIsBalanceIsZero
	|portfolio1 summary|
	portfolio1 := Portfolio new.
	summary := OrderedCollection new.
	summary add: 'Balance = 0'.
	
	self assert: (AccountSummary of: portfolio1) equals: summary.! !

!TransactionBasedReportsTest methodsFor: 'tests' stamp: 'SC 10/26/2023 04:05:33'!
test06AccountSummaryOfPortfolioWithAccountsIsConcatenationOfSummaries
	|account1 account2 summary portfolio1|
	portfolio1 := Portfolio new.
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	Deposit register: 100 on: account1.
	Withdraw register: 50 on: account1.
	Transfer from: account1 to: account2 for: 25.
	Transfer from: account2 to: account1 for: 30. 
	portfolio1 add: 	account1.
	portfolio1 add: account2.
	summary := OrderedCollection new.
	summary add: 'Depósito por 100'.
	summary add: 'Extracción por 50'.
	summary add: 'Salida por transferencia de 25'.
	summary add: 'Entrada por transferencia de 30'.
	summary add: 'Entrada por transferencia de 25'.
	summary add: 'Salida por transferencia de 30'.
	summary add: 'Balance = 50'.
	self assert: summary equals: (AccountSummary of:portfolio1).! !

!TransactionBasedReportsTest methodsFor: 'tests' stamp: 'SC 10/26/2023 04:05:42'!
test07AccountSummaryOfPortfolioWithPortfolioAndAccounts
	|account1 account2 summary portfolio1 portfolio2|
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	Deposit register: 100 on: account1.
	Withdraw register: 50 on: account1.
	Transfer from: account1 to: account2 for: 25.
	Transfer from: account2 to: account1 for: 30. 
	portfolio1 add: 	account1.
	portfolio2 add: account2.
	portfolio1 add: portfolio2.
	summary := OrderedCollection new.
	summary add: 'Depósito por 100'.
	summary add: 'Extracción por 50'.
	summary add: 'Salida por transferencia de 25'.
	summary add: 'Entrada por transferencia de 30'.
	summary add: 'Entrada por transferencia de 25'.
	summary add: 'Salida por transferencia de 30'.
	summary add: 'Balance = 50'.
	self assert: summary equals: (AccountSummary of: portfolio1).! !

!TransactionBasedReportsTest methodsFor: 'tests' stamp: 'FC 10/25/2023 02:29:24'!
test08TransferNetOfPortfolioWithNoTransfersIsZero
	|account1 account2 portfolio1|
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	portfolio1 := Portfolio new.
	Deposit register: 100 on: account1.
	Withdraw register:50 on: account2.
	portfolio1 add:account1.
	portfolio1 add:account2.
	self assert: (TransferNet of: portfolio1) equals: 0.! !

!TransactionBasedReportsTest methodsFor: 'tests' stamp: 'FC 10/25/2023 02:29:39'!
test09TransferNetOfPortfolioWithAccountsIsSumOfTransferNetOfAccounts
	|account1 account2 account3 portfolio1|
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	portfolio1 := Portfolio new.
	Deposit register: 100 on: account1.
	Withdraw register:50 on: account2.
	Transfer from: account1 to: account3 for: 100.
	Transfer from: account3 to: account2 for: 50.
	Transfer from: account1 to: account2 for: 39.
	
	portfolio1 add:account1.
	portfolio1 add:account2.
	self assert: (TransferNet of: portfolio1) equals: -50.! !

!TransactionBasedReportsTest methodsFor: 'tests' stamp: 'FC 10/25/2023 02:29:56'!
test10TransferNetOfPortfolioWithPortfolioAndAccounts
	|account1 account2 account3 account4 portfolio1 portfolio2|
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	account4 := ReceptiveAccount new.
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	Deposit register: 100 on: account1.
	Withdraw register:50 on: account2.
	Transfer from: account1 to: account3 for: 100.
	Transfer from: account3 to: account2 for: 50.
	Transfer from: account1 to: account2 for: 39.
	Transfer from: account4 to: account3 for: 100.
	
	portfolio1 add:account1.
	portfolio1 add:account2.
	portfolio2 add: account3.
	portfolio1 add: account3.
	self assert: (TransferNet of: portfolio1) equals: 100.! !


!classDefinition: #TransferTest category: 'Portfolio-Solucion'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferTest methodsFor: 'tests' stamp: 'SC 10/19/2023 21:30:15'!
test01TransferChangesBalance
	|account1 account2 transferencia|
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	transferencia := Transfer from:account1 to:account2 for: 100.
	self assert: account1 balance equals: -100.
	self assert: account2 balance equals:100.
	! !

!TransferTest methodsFor: 'tests' stamp: 'FC 10/24/2023 18:27:32'!
test02TransferSenderAndReceiverAreRegistered
	|account1 account2 transferencia|
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	transferencia := Transfer from:account1 to:account2 for: 100.
	self assert: (account1 hasRegistered: transferencia senderLeg).
	self assert: (account2 hasRegistered: transferencia receiverLeg).
	! !

!TransferTest methodsFor: 'tests' stamp: 'FC 10/24/2023 18:27:36'!
test03CannotTransferToSelf
	|account1 transferencia|
	account1 := ReceptiveAccount new.

	self should: [transferencia := Transfer from:account1 to:account1 for: 100.] raise: Error withExceptionDo: 
		[:error | self assert: (Transfer cannotHaveTransferBetweenSameAccountsErrorDescription ) equals: error messageText].
	
	! !

!TransferTest methodsFor: 'tests' stamp: 'FC 10/24/2023 18:27:41'!
test04SenderLegAndReceiverLegKnowsTransfer
	|account1 account2 transferencia|
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	
	transferencia := Transfer from: account1 to: account2 for:100.
	
	self assert: (transferencia senderLeg) transfer equals: transferencia.
	self assert: (transferencia receiverLeg) transfer equals: transferencia.

	
	! !

!TransferTest methodsFor: 'tests' stamp: 'FC 10/24/2023 18:33:34'!
test05SenderLegAndReceiverLegKnowEachOther
	|account1 account2 transferencia|
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	
	transferencia := Transfer from: account1 to: account2 for:100.
	
	self assert: (transferencia senderLeg) receiverLeg equals: transferencia receiverLeg.
	self assert: (transferencia receiverLeg) senderLeg equals: transferencia senderLeg.

	
	! !

!TransferTest methodsFor: 'tests' stamp: 'FC 10/26/2023 00:22:26'!
test06TransferAmountHasToBePositve
	|account1 account2 transferencia|
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	self should: [	transferencia := Transfer from: account1 to: account2 for: -1] raise: Error withExceptionDo: [:error | self assert: (Transfer cannotTransferNonPositiveMoneyErrorDescription) equals: error messageText].
	
	

	
	! !


!classDefinition: #Account category: 'Portfolio-Solucion'!
Object subclass: #Account
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!Account methodsFor: 'balance' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !


!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !


!Account methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !


!Account methodsFor: 'reports' stamp: 'FC 10/26/2023 03:31:00'!
addInformationToReport: reportToAddInformationTo

	self subclassResponsibility! !


!Account methodsFor: 'accessing' stamp: 'FC 10/26/2023 00:52:32'!
nameOfAccount
	^name! !


!Account methodsFor: 'initialization' stamp: 'FC 10/26/2023 00:29:11'!
initializeWithName: nameOfAccount
	name := nameOfAccount ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Account class' category: 'Portfolio-Solucion'!
Account class
	instanceVariableNames: ''!

!Account class methodsFor: 'instance creation' stamp: 'FC 10/26/2023 00:35:16'!
named: nameOfAccount
	^self new initializeWithName: nameOfAccount.! !


!classDefinition: #Portfolio category: 'Portfolio-Solucion'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:20'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:05:04'!
accountsIsEmpty
	
	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !

!Portfolio methodsFor: 'accounts management' stamp: 'FC 10/25/2023 00:57:43'!
transferNet
	^accounts sum: [:account | account transferNet].! !


!Portfolio methodsFor: 'initialization' stamp: 'HAW 5/25/2019 12:03:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !


!Portfolio methodsFor: 'reports' stamp: 'FC 10/26/2023 03:36:04'!
addAccountsInformationToReport: reportToAddInformationTo
	accounts do: [:account | reportToAddInformationTo addInformationOfAccount: account].! !

!Portfolio methodsFor: 'reports' stamp: 'FC 10/26/2023 03:31:30'!
addInformationToReport: reportToAddInformationTo

	reportToAddInformationTo addPortfolioInformation: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'instance creation' stamp: 'FC 10/26/2023 00:51:44'!
named: nameOfAccount with: anAccount with: anotherAccount

	^(((self new) initializeWithName: nameOfAccount )
		add: anAccount;
		add: anotherAccount;
		yourself)! !

!Portfolio class methodsFor: 'instance creation' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'instance creation' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!Portfolio class methodsFor: 'error handling' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:35'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:24:46'!
balance

	^transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/21/2019 18:55:56'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !


!ReceptiveAccount methodsFor: 'reports' stamp: 'FC 10/26/2023 03:31:45'!
addInformationToReport: reportToAddInformationTo

	reportToAddInformationTo addReceptiveAccountInformation: self.! !

!ReceptiveAccount methodsFor: 'reports' stamp: 'FC 10/26/2023 03:39:10'!
addTransactionsInformationToTransactionBasedReport: transactionBasedReportToAddInformationTo
	transactions do: [:transaction | transaction addInformationToTransactionBasedReport: transactionBasedReportToAddInformationTo].! !


!classDefinition: #AccountTransaction category: 'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'reports' stamp: 'FC 10/25/2023 23:46:19'!
addInformationToTransactionBasedReport: transactionBasedReport

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Solucion'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/21/2019 18:54:27'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !


!Deposit methodsFor: 'reports' stamp: 'FC 10/25/2023 23:46:38'!
addInformationToTransactionBasedReport: transactionBasedReport
	transactionBasedReport addDepositInformation: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #TransferLeg category: 'Portfolio-Solucion'!
AccountTransaction subclass: #TransferLeg
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferLeg methodsFor: 'reports' stamp: 'FC 10/25/2023 23:46:24'!
addInformationToTransactionBasedReport: transactionBasedReport

	self subclassResponsibility! !


!TransferLeg methodsFor: 'balance' stamp: 'FC 10/24/2023 17:42:16'!
affectBalance: balance
	self subclassResponsibility ! !


!TransferLeg methodsFor: 'accessing' stamp: 'FC 10/24/2023 17:41:55'!
transfer
	^transfer! !


!TransferLeg methodsFor: 'value' stamp: 'FC 10/24/2023 18:51:25'!
value
	^transfer value! !


!TransferLeg methodsFor: 'initialization' stamp: 'SC 10/23/2023 21:47:24'!
initializeIn: transferLegIsIn
	transfer := transferLegIsIn.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferLeg class' category: 'Portfolio-Solucion'!
TransferLeg class
	instanceVariableNames: ''!

!TransferLeg class methodsFor: 'instance creation' stamp: 'FC 10/24/2023 17:43:52'!
in: transfer
	^self new initializeIn: transfer.! !


!classDefinition: #ReceiverLeg category: 'Portfolio-Solucion'!
TransferLeg subclass: #ReceiverLeg
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceiverLeg methodsFor: 'accessing' stamp: 'FC 10/24/2023 18:31:04'!
senderLeg
	^transfer senderLeg! !


!ReceiverLeg methodsFor: 'balance' stamp: 'FC 10/24/2023 17:43:21'!
affectBalance: balance
	^balance + self transfer value.! !


!ReceiverLeg methodsFor: 'reports' stamp: 'FC 10/25/2023 23:47:04'!
addInformationToTransactionBasedReport: transactionBasedReport
	transactionBasedReport addReceiverLegInformation: self.! !


!classDefinition: #SenderLeg category: 'Portfolio-Solucion'!
TransferLeg subclass: #SenderLeg
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!SenderLeg methodsFor: 'balance' stamp: 'FC 10/24/2023 17:43:37'!
affectBalance: balance
	^balance - self transfer value.! !


!SenderLeg methodsFor: 'accessing' stamp: 'FC 10/24/2023 18:31:38'!
receiverLeg
	^transfer receiverLeg ! !


!SenderLeg methodsFor: 'reports' stamp: 'FC 10/25/2023 23:47:15'!
addInformationToTransactionBasedReport: transactionBasedReport
	transactionBasedReport addSenderLegInformation: self.! !


!classDefinition: #Withdraw category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'reports' stamp: 'FC 10/25/2023 23:47:29'!
addInformationToTransactionBasedReport: transactionBasedReport
	transactionBasedReport addWithdrawInformation: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Report category: 'Portfolio-Solucion'!
Object subclass: #Report
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Report methodsFor: 'information' stamp: 'FC 10/26/2023 03:40:01'!
addInformationOfAccount: accountToAddInformationOf
	accountToAddInformationOf addInformationToReport: self.! !

!Report methodsFor: 'information' stamp: 'FC 10/26/2023 03:40:33'!
addPortfolioInformation: portfolioToAddInformationOf

	self subclassResponsibility! !

!Report methodsFor: 'information' stamp: 'FC 10/26/2023 03:40:42'!
addReceptiveAccountInformation: receptiveAccountToAddInformationOf

	self subclassResponsibility! !


!classDefinition: #AccountBasedReport category: 'Portfolio-Solucion'!
Report subclass: #AccountBasedReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountBasedReport methodsFor: 'information' stamp: 'FC 10/26/2023 03:10:29'!
addPortfolioInformation: portfolioToAddInformationOf

	self subclassResponsibility! !

!AccountBasedReport methodsFor: 'information' stamp: 'FC 10/26/2023 03:10:25'!
addReceptiveAccountInformation: portfolioToAddInformationOf

	self subclassResponsibility! !


!classDefinition: #PortfolioTreeReport category: 'Portfolio-Solucion'!
AccountBasedReport subclass: #PortfolioTreeReport
	instanceVariableNames: 'portfolio portfolioTree portfolioTreeDepth'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTreeReport methodsFor: 'information' stamp: 'FC 10/26/2023 03:35:13'!
addPortfolioInformation: portfolioToAddInformationOf
	self addLineWithCorrectIndentation: portfolioToAddInformationOf nameOfAccount .
	self increasePortfolioDepth.
	portfolioToAddInformationOf addAccountsInformationToReport: self.
	self decreasePortfolioDepth.! !

!PortfolioTreeReport methodsFor: 'information' stamp: 'FC 10/26/2023 03:13:11'!
addReceptiveAccountInformation: receptiveAccountToAddInformationOf
	self addLineWithCorrectIndentation: receptiveAccountToAddInformationOf nameOfAccount .! !


!PortfolioTreeReport methodsFor: 'indentation' stamp: 'FC 10/26/2023 02:59:58'!
addLineWithCorrectIndentation: accountName

	^ portfolioTree add: self indentation, accountName! !

!PortfolioTreeReport methodsFor: 'indentation' stamp: 'FC 10/26/2023 01:23:28'!
indentation
	|indentation|
	indentation := String new.
	portfolioTreeDepth timesRepeat: [indentation := indentation,'   '].
	^indentation ! !


!PortfolioTreeReport methodsFor: 'tree' stamp: 'FC 10/26/2023 01:26:56'!
decreasePortfolioDepth

	^ portfolioTreeDepth := portfolioTreeDepth - 1! !

!PortfolioTreeReport methodsFor: 'tree' stamp: 'FC 10/26/2023 01:26:36'!
increasePortfolioDepth

	^ portfolioTreeDepth := portfolioTreeDepth + 1! !

!PortfolioTreeReport methodsFor: 'tree' stamp: 'FC 10/26/2023 03:21:09'!
portfolioTree
	self addInformationOfAccount: portfolio.
	^portfolioTree ! !


!PortfolioTreeReport methodsFor: 'initialization' stamp: 'FC 10/26/2023 01:29:59'!
initializeWith: portfolioToInitializeWith
	portfolio := portfolioToInitializeWith.
	portfolioTree := OrderedCollection new.
	portfolioTreeDepth := 0.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PortfolioTreeReport class' category: 'Portfolio-Solucion'!
PortfolioTreeReport class
	instanceVariableNames: ''!

!PortfolioTreeReport class methodsFor: 'instance creation' stamp: 'FC 10/26/2023 01:04:55'!
of: portfolioToGetPortfolioTreeOf
	^(self new initializeWith: portfolioToGetPortfolioTreeOf) portfolioTree ! !


!classDefinition: #SpecialPortfolioReport category: 'Portfolio-Solucion'!
AccountBasedReport subclass: #SpecialPortfolioReport
	instanceVariableNames: 'specialReport portfolioTreeDepth portfolio'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!SpecialPortfolioReport methodsFor: 'indentation' stamp: 'FC 10/26/2023 02:59:58'!
addAccountSummaryWithCorrectIndentationOfAccount: accountToGetSummaryOf

	^ (AccountSummary of: accountToGetSummaryOf) do: [:summaryLine | self addLineWithCorrectIndentation: summaryLine]! !

!SpecialPortfolioReport methodsFor: 'indentation' stamp: 'FC 10/26/2023 02:59:58'!
addLineWithCorrectIndentation: accountName

	^ specialReport add: self indentation, accountName! !

!SpecialPortfolioReport methodsFor: 'indentation' stamp: 'FC 10/26/2023 02:44:48'!
indentation
	|indentation|
	indentation := String new.
	portfolioTreeDepth timesRepeat: [indentation := indentation,'   '].
	^indentation ! !


!SpecialPortfolioReport methodsFor: 'initialization' stamp: 'FC 10/26/2023 02:45:08'!
initializeWith: portfolioToInitializeWith
	portfolio := portfolioToInitializeWith.
	specialReport := OrderedCollection new.
	portfolioTreeDepth := 0.! !


!SpecialPortfolioReport methodsFor: 'tree' stamp: 'FC 10/26/2023 02:44:31'!
decreasePortfolioDepth

	^ portfolioTreeDepth := portfolioTreeDepth - 1! !

!SpecialPortfolioReport methodsFor: 'tree' stamp: 'FC 10/26/2023 02:44:25'!
increasePortfolioDepth

	^ portfolioTreeDepth := portfolioTreeDepth + 1! !

!SpecialPortfolioReport methodsFor: 'tree' stamp: 'FC 10/26/2023 03:23:33'!
specialReport
	self addInformationOfAccount: portfolio.
	^specialReport
! !


!SpecialPortfolioReport methodsFor: 'information' stamp: 'FC 10/26/2023 03:35:24'!
addPortfolioInformation: portfolioToAddInformationOf
	self addLineWithCorrectIndentation: portfolioToAddInformationOf nameOfAccount .
	self increasePortfolioDepth.
	portfolioToAddInformationOf addAccountsInformationToReport: self.
	self addLineWithCorrectIndentation: 'Balance = ',(portfolioToAddInformationOf balance) asString.
	self decreasePortfolioDepth.! !

!SpecialPortfolioReport methodsFor: 'information' stamp: 'FC 10/26/2023 03:34:14'!
addReceptiveAccountInformation: receptiveAccountToAddInformationOf
	self addLineWithCorrectIndentation: receptiveAccountToAddInformationOf nameOfAccount .
	self increasePortfolioDepth.
	self addAccountSummaryWithCorrectIndentationOfAccount: receptiveAccountToAddInformationOf .
	self decreasePortfolioDepth.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SpecialPortfolioReport class' category: 'Portfolio-Solucion'!
SpecialPortfolioReport class
	instanceVariableNames: ''!

!SpecialPortfolioReport class methodsFor: 'instance creation' stamp: 'FC 10/26/2023 02:46:38'!
of: portfolioToGetSpecialReportOf
	^(self new initializeWith: portfolioToGetSpecialReportOf) specialReport.! !


!classDefinition: #TransactionBasedReport category: 'Portfolio-Solucion'!
Report subclass: #TransactionBasedReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransactionBasedReport methodsFor: 'information' stamp: 'FC 10/25/2023 23:48:09'!
addDepositInformation: depositToAddInformationOf

	self subclassResponsibility! !

!TransactionBasedReport methodsFor: 'information' stamp: 'FC 10/26/2023 01:59:00'!
addPortfolioInformation: portfolioToAddInformationOf

	self subclassResponsibility! !

!TransactionBasedReport methodsFor: 'information' stamp: 'FC 10/25/2023 23:48:14'!
addReceiverLegInformation: receiverLegToAddInformationOf

	self subclassResponsibility! !

!TransactionBasedReport methodsFor: 'information' stamp: 'FC 10/26/2023 01:59:58'!
addReceptiveAccountInformation: receptiveAccountToAddInformationOf

	self subclassResponsibility! !

!TransactionBasedReport methodsFor: 'information' stamp: 'FC 10/25/2023 23:48:19'!
addSenderLegInformation: senderLegToAddInformationOf

	self subclassResponsibility! !

!TransactionBasedReport methodsFor: 'information' stamp: 'FC 10/25/2023 23:48:23'!
addWithdrawInformation: withdrawToAddInformationOf

	self subclassResponsibility! !


!classDefinition: #AccountSummary category: 'Portfolio-Solucion'!
TransactionBasedReport subclass: #AccountSummary
	instanceVariableNames: 'account summary'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountSummary methodsFor: 'initialization' stamp: 'FC 10/25/2023 01:56:04'!
initializeWith: accountToSummarize
	account := accountToSummarize.
	summary := OrderedCollection new.! !


!AccountSummary methodsFor: 'information' stamp: 'SC 10/26/2023 04:04:29'!
addDepositInformation: depositToAddInformationOf

	summary add: 'Depósito por ', (depositToAddInformationOf value) asString! !

!AccountSummary methodsFor: 'information' stamp: 'FC 10/26/2023 03:36:45'!
addPortfolioInformation: portfolioToAddInformationOf

	portfolioToAddInformationOf addAccountsInformationToReport: self.! !

!AccountSummary methodsFor: 'information' stamp: 'SC 10/26/2023 04:04:34'!
addReceiverLegInformation: receiverLegToAddInformationOf
	summary add: 'Entrada por transferencia de ', (receiverLegToAddInformationOf value) asString! !

!AccountSummary methodsFor: 'information' stamp: 'FC 10/26/2023 03:39:10'!
addReceptiveAccountInformation: receptiveAccountToAddInformationOf

	receptiveAccountToAddInformationOf addTransactionsInformationToTransactionBasedReport: self.! !

!AccountSummary methodsFor: 'information' stamp: 'SC 10/26/2023 04:04:39'!
addSenderLegInformation: senderLegToAddInformationOf
	summary add: 'Salida por transferencia de ', (senderLegToAddInformationOf value) asString! !

!AccountSummary methodsFor: 'information' stamp: 'SC 10/26/2023 04:04:42'!
addWithdrawInformation: withdrawToAddInformationOf
	summary add: 'Extracción por ', (withdrawToAddInformationOf value) asString! !


!AccountSummary methodsFor: 'evaluating' stamp: 'SC 10/26/2023 04:04:24'!
accountSummary
	self addInformationOfAccount: account.
	summary add: 'Balance = ',(account balance) asString.
	^summary! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountSummary class' category: 'Portfolio-Solucion'!
AccountSummary class
	instanceVariableNames: ''!

!AccountSummary class methodsFor: 'instance creation' stamp: 'FC 10/25/2023 01:32:50'!
of: account
	^(self new initializeWith: account) accountSummary! !


!classDefinition: #TransferNet category: 'Portfolio-Solucion'!
TransactionBasedReport subclass: #TransferNet
	instanceVariableNames: 'account transferNetAccumulator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNet methodsFor: 'initialization' stamp: 'FC 10/25/2023 02:28:32'!
initializeWith: accountToCalculateTransferNet
	account := accountToCalculateTransferNet.
	transferNetAccumulator := 0.! !


!TransferNet methodsFor: 'evaluating' stamp: 'FC 10/25/2023 23:55:58'!
transferNet
	self addInformationOfAccount: account.
	^transferNetAccumulator ! !


!TransferNet methodsFor: 'information' stamp: 'FC 10/25/2023 23:55:11'!
addDepositInformation: depositToAddInformationOf
! !

!TransferNet methodsFor: 'information' stamp: 'FC 10/26/2023 03:36:59'!
addPortfolioInformation: portfolioToAddInformationOf

	portfolioToAddInformationOf addAccountsInformationToReport: self.! !

!TransferNet methodsFor: 'information' stamp: 'FC 10/25/2023 23:55:28'!
addReceiverLegInformation: receiverLegToAddInformationOf

	transferNetAccumulator := transferNetAccumulator + receiverLegToAddInformationOf value! !

!TransferNet methodsFor: 'information' stamp: 'FC 10/26/2023 03:39:10'!
addReceptiveAccountInformation: receptiveAccountToAddInformationOf

	receptiveAccountToAddInformationOf addTransactionsInformationToTransactionBasedReport: self.! !

!TransferNet methodsFor: 'information' stamp: 'FC 10/25/2023 23:55:41'!
addSenderLegInformation: senderLegToAddInformationOf

	transferNetAccumulator := transferNetAccumulator - senderLegToAddInformationOf value! !

!TransferNet methodsFor: 'information' stamp: 'FC 10/25/2023 23:54:48'!
addWithdrawInformation: withdrawToAddInformationOf
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferNet class' category: 'Portfolio-Solucion'!
TransferNet class
	instanceVariableNames: ''!

!TransferNet class methodsFor: 'instance creation' stamp: 'FC 10/25/2023 02:27:46'!
of: accountToCalculateTransferNet
	^(self new initializeWith: accountToCalculateTransferNet) transferNet! !


!classDefinition: #Transfer category: 'Portfolio-Solucion'!
Object subclass: #Transfer
	instanceVariableNames: 'senderLeg receiverLeg value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Transfer methodsFor: 'accessing' stamp: 'SC 10/19/2023 21:47:05'!
receiverLeg
	^receiverLeg ! !

!Transfer methodsFor: 'accessing' stamp: 'SC 10/19/2023 21:46:54'!
senderLeg
	^senderLeg ! !


!Transfer methodsFor: 'initialization' stamp: 'FC 10/24/2023 17:47:55'!
initializeWith: senderAccountToInitializeWith and: receiverAccountToInitializeWith withValue: valueToInitializeWith.
	senderLeg := SenderLeg in: self.
	senderAccountToInitializeWith register: senderLeg.
	receiverLeg := ReceiverLeg in: self.
	receiverAccountToInitializeWith register: receiverLeg.
	value := valueToInitializeWith.! !


!Transfer methodsFor: 'value' stamp: 'FC 10/24/2023 17:42:34'!
value
	^value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'Portfolio-Solucion'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'error handling' stamp: 'SC 10/19/2023 22:01:47'!
cannotHaveTransferBetweenSameAccountsErrorDescription
	^'No podes hacer una transferencia entre las mismas cuentas'
	! !

!Transfer class methodsFor: 'error handling' stamp: 'FC 10/24/2023 17:51:41'!
cannotTransferNonPositiveMoneyErrorDescription
	^'Las transferencias deben ser de valor positivo'
! !


!Transfer class methodsFor: 'creation assertions' stamp: 'FC 10/24/2023 17:44:23'!
assertSenderAccount: senderAccount isNotTheSameAsReceiverAccount: receiverAccount

	^ (senderAccount = receiverAccount) ifTrue: [self error: self cannotHaveTransferBetweenSameAccountsErrorDescription]! !

!Transfer class methodsFor: 'creation assertions' stamp: 'FC 10/24/2023 17:52:45'!
assertTransferAmountIsPositive: amountTransfered

	^ (amountTransfered <= 0) ifTrue: [self error: self cannotTransferNonPositiveMoneyErrorDescription]! !


!Transfer class methodsFor: 'instance creation' stamp: 'FC 10/24/2023 17:52:45'!
from: senderAccount to: receiverAccount for: amountTransfered
	self assertSenderAccount: senderAccount isNotTheSameAsReceiverAccount: receiverAccount.
	self assertTransferAmountIsPositive: amountTransfered.
	^self new initializeWith: senderAccount and: receiverAccount withValue: amountTransfered .
! !
