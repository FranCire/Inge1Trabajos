!classDefinition: #OOStackTest category: 'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:29:55'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:01'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:09'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'NR 9/16/2021 17:40:17'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'firstSomething'.
	secondPushedObject := 'secondSomething'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:20'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:24'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:31'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #SentenceFinderByPrefixTest category: 'Stack-Exercise'!
TestCase subclass: #SentenceFinderByPrefixTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'FC 9/18/2023 06:12:48'!
test01NoSentenceToFindForPrefixInAnEmptyStack
	|sentenceStack sentenceFinder|
	sentenceStack := OOStack new.
	sentenceFinder := SentenceFinderByPrefix with: sentenceStack.

	self assert: ((sentenceFinder findAllSentencesInStackWithPrefix:'Wint') isEmpty).
	self failIfStack: sentenceStack isDifferentFromStack: sentenceFinder stackOfSentences.! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'SC 9/18/2023 03:55:00'!
test02LookForSentencesWithEmptyPrefix
	|sentenceStack sentenceFinder|
	sentenceStack := self createTestStack.
	
	sentenceFinder := SentenceFinderByPrefix with: sentenceStack.
	
	
	self 
		should: [sentenceFinder findAllSentencesInStackWithPrefix: '']
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: SentenceFinderByPrefix emptyPrefixError].
	self failIfStack: sentenceStack isDifferentFromStack: self createTestStack.
	

		! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'SC 9/18/2023 03:58:50'!
test03LookForSentencesWithPrefixWithSpaces
	|sentenceStack sentenceFinder|
	sentenceStack := self createTestStack.

	sentenceFinder := SentenceFinderByPrefix with: sentenceStack.
	
	self 
		should: [sentenceFinder findAllSentencesInStackWithPrefix: 'winter is coming']
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: SentenceFinderByPrefix prefixContainsEmptySpaceError].

	self failIfStack: sentenceStack isDifferentFromStack: self createTestStack.! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'SC 9/18/2023 03:55:41'!
test04LookForSentencesWithPrefixIsCaseSensitive
	|sentenceStack sentenceFinder correctSentencesWithPrefixWin correctSentencesWithPrefixwin|
	sentenceStack := self createTestStack.
	
	correctSentencesWithPrefixWin := SortedCollection new.
	correctSentencesWithPrefixWin add: 'Winter is here'.
	
	correctSentencesWithPrefixwin := SortedCollection new.
	correctSentencesWithPrefixwin add: 'winter is coming'.
	correctSentencesWithPrefixwin add: 'winning is everything'.

	sentenceFinder := SentenceFinderByPrefix with: sentenceStack.
	self assert: (sentenceFinder findAllSentencesInStackWithPrefix: 'Win') equals: correctSentencesWithPrefixWin.
	self assert: (sentenceFinder findAllSentencesInStackWithPrefix: 'win') equals: correctSentencesWithPrefixwin.
	self failIfStack: sentenceStack isDifferentFromStack: self createTestStack.

	
	

		! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'SC 9/18/2023 04:02:57'!
test05NoSentenceStartsWithPrefix
	|sentenceStack sentenceFinder|
	sentenceStack := self createTestStack.

	sentenceFinder := SentenceFinderByPrefix with: sentenceStack.
	self assert: ((sentenceFinder findAllSentencesInStackWithPrefix:'Summer') isEmpty).
	self failIfStack: sentenceStack isDifferentFromStack: self createTestStack.

	
	

		! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'SC 9/18/2023 04:22:40'!
test06FindsTheSentenceWithPrefixInTheOneElementStack
	|sentenceStack sentenceFinder sentencesFound|
	sentenceStack := OOStack new push: 'winning is everything'.

	sentenceFinder := SentenceFinderByPrefix with: sentenceStack.
	sentencesFound := sentenceFinder findAllSentencesInStackWithPrefix:'w'.
	self assert: 1 equals: sentencesFound size.
	self assert: sentencesFound first equals: sentenceStack top.
	self failIfStack: sentenceStack isDifferentFromStack: (OOStack new push: 'winning is everything').

	
	

		! !


!SentenceFinderByPrefixTest methodsFor: 'failing' stamp: 'SC 9/18/2023 04:27:49'!
failIfStack: firstStackInComparison hasDifferentOrderThan: secondStackInComparison
	|firstStackCollection secondStackCollection|
	
	firstStackCollection := OrderedCollection new.
	secondStackCollection := OrderedCollection new.
	
	firstStackInComparison size timesRepeat: 
		[self assert: firstStackInComparison pop equals: secondStackInComparison pop].
		
	

		! !

!SentenceFinderByPrefixTest methodsFor: 'failing' stamp: 'SC 9/18/2023 04:26:18'!
failIfStack: firstStackInComparison hasDifferentSizeComparedTo: secondStackInComparison

	self assert: firstStackInComparison size equals: secondStackInComparison size.
	
	

		! !

!SentenceFinderByPrefixTest methodsFor: 'failing' stamp: 'SC 9/18/2023 04:28:41'!
failIfStack: firstStackInComparison isDifferentFromStack: secondStackInComparison

	self failIfStack: firstStackInComparison hasDifferentSizeComparedTo: secondStackInComparison.
	self failIfStack: firstStackInComparison hasDifferentOrderThan: secondStackInComparison.
		
	

		! !


!SentenceFinderByPrefixTest methodsFor: 'initializing for tests' stamp: 'SC 9/18/2023 03:54:01'!
createTestStack
	|testStack|
	testStack := OOStack new.
	testStack push: 'winter is coming'.
	testStack push: 'winning is everything'.
	testStack push: 'The winds of everything'.
	testStack push: 'Winter is here'.
	^testStack.
! !


!classDefinition: #OOStack category: 'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'topStackElement size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'initialization' stamp: 'FC 9/18/2023 04:07:02'!
initialize
	size := 0.
	topStackElement := OOStackBaseElement new! !


!OOStack methodsFor: 'modifying operations' stamp: 'FC 9/18/2023 04:32:34'!
pop
	|valueOfPoppedStackElement|
	valueOfPoppedStackElement := topStackElement value.
	topStackElement  := topStackElement previousStackElement.
	size := size - 1.
	^valueOfPoppedStackElement 
	! !

!OOStack methodsFor: 'modifying operations' stamp: 'FC 9/18/2023 04:31:48'!
push: valueToAddToStack
	|newStackElement|
	newStackElement := OOStackNonBaseElement withPreviousStackElement: topStackElement andValueOfStackElement: valueToAddToStack.
	topStackElement := newStackElement.
	size := size + 1
	! !


!OOStack methodsFor: 'properties' stamp: 'FC 9/18/2023 04:20:01'!
isEmpty
	^topStackElement isBaseElement! !


!OOStack methodsFor: 'accessing' stamp: 'FC 9/18/2023 04:08:19'!
size
	^size! !

!OOStack methodsFor: 'accessing' stamp: 'FC 9/18/2023 04:10:32'!
top
	^topStackElement value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: 'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'NR 9/14/2023 08:12:21'!
stackEmptyErrorDescription
	
	^ 'stack is empty!!!!!!'! !


!classDefinition: #OOStackElement category: 'Stack-Exercise'!
Object subclass: #OOStackElement
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackElement methodsFor: 'accessing' stamp: 'FC 9/18/2023 04:35:02'!
previousStackElement
	self subclassResponsibility ! !

!OOStackElement methodsFor: 'accessing' stamp: 'FC 9/18/2023 04:35:10'!
value
	self subclassResponsibility ! !


!OOStackElement methodsFor: 'properties' stamp: 'FC 9/18/2023 04:34:48'!
isBaseElement
	self subclassResponsibility ! !


!classDefinition: #OOStackBaseElement category: 'Stack-Exercise'!
OOStackElement subclass: #OOStackBaseElement
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackBaseElement methodsFor: 'properties' stamp: 'FC 9/18/2023 04:20:16'!
isBaseElement
	^true! !


!OOStackBaseElement methodsFor: 'accessing' stamp: 'FC 9/18/2023 04:16:43'!
previousStackElement
	^self error: OOStack stackEmptyErrorDescription ! !

!OOStackBaseElement methodsFor: 'accessing' stamp: 'FC 9/18/2023 04:16:51'!
value
	^self error: OOStack stackEmptyErrorDescription ! !


!classDefinition: #OOStackNonBaseElement category: 'Stack-Exercise'!
OOStackElement subclass: #OOStackNonBaseElement
	instanceVariableNames: 'previousStackElement valueOfStackElement'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackNonBaseElement methodsFor: 'initialization' stamp: 'FC 9/18/2023 03:57:58'!
initializeWithPreviousStackElement: previousStackElementToAssign andValueOfStackElement: valueOfStackElementToAssign
	previousStackElement := previousStackElementToAssign.
	valueOfStackElement := valueOfStackElementToAssign ! !


!OOStackNonBaseElement methodsFor: 'accessing' stamp: 'FC 9/18/2023 04:16:06'!
previousStackElement
	^previousStackElement ! !

!OOStackNonBaseElement methodsFor: 'accessing' stamp: 'FC 9/18/2023 04:09:30'!
value
	^valueOfStackElement ! !


!OOStackNonBaseElement methodsFor: 'properties' stamp: 'FC 9/18/2023 04:20:28'!
isBaseElement
	^false! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStackNonBaseElement class' category: 'Stack-Exercise'!
OOStackNonBaseElement class
	instanceVariableNames: ''!

!OOStackNonBaseElement class methodsFor: 'as yet unclassified' stamp: 'FC 9/18/2023 03:59:11'!
withPreviousStackElement: previousStackElementToAssign andValueOfStackElement: valueOfStackElementToAssign
	^self new initializeWithPreviousStackElement: previousStackElementToAssign andValueOfStackElement: valueOfStackElementToAssign ! !


!classDefinition: #SentenceFinderByPrefix category: 'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: 'stackOfSentences'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefix methodsFor: 'error handling' stamp: 'FC 9/18/2023 06:20:13'!
checkIfValidPrefix: prefixToCheck
	prefixToCheck isEmpty ifTrue: 
		[^self error: SentenceFinderByPrefix emptyPrefixError].
	
	(prefixToCheck includes:$ ) ifTrue:
		[^self error: SentenceFinderByPrefix prefixContainsEmptySpaceError].! !


!SentenceFinderByPrefix methodsFor: 'prefix operations' stamp: 'SC 9/18/2023 04:19:42'!
findAllSentencesInStackWithPrefix: prefixToLookFor
	|sentencesWithMatchingPrefix sentencesInStack|
	
	
	self checkIfValidPrefix: prefixToLookFor.
	
	sentencesWithMatchingPrefix := SortedCollection new.
	sentencesInStack := OOStack new.
	
	stackOfSentences size timesRepeat: [
		(stackOfSentences top beginsWith: prefixToLookFor) ifTrue:
			[sentencesWithMatchingPrefix add: stackOfSentences top].
		sentencesInStack push: (stackOfSentences pop).
	].

	sentencesInStack size timesRepeat: [
		stackOfSentences push: sentencesInStack pop.
	].

	^sentencesWithMatchingPrefix
		
				
	
	
! !


!SentenceFinderByPrefix methodsFor: 'initialization' stamp: 'FC 9/18/2023 04:56:20'!
initializeWithStackOfSentences: stackOfSentencesToUse
	stackOfSentences := stackOfSentencesToUse ! !


!SentenceFinderByPrefix methodsFor: 'accessing' stamp: 'FC 9/18/2023 06:05:21'!
stackOfSentences
	^stackOfSentences! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: 'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'as yet unclassified' stamp: 'FC 9/18/2023 04:59:40'!
emptyPrefixError
	^'No se puede buscar un prefijo vacío'.! !

!SentenceFinderByPrefix class methodsFor: 'as yet unclassified' stamp: 'FC 9/18/2023 05:10:01'!
prefixContainsEmptySpaceError
	^'No se puede buscar un prefijo que contenga espacios'.! !

!SentenceFinderByPrefix class methodsFor: 'as yet unclassified' stamp: 'FC 9/18/2023 06:17:33'!
with: stackOfSentences
	^self new initializeWithStackOfSentences: stackOfSentences ! !
