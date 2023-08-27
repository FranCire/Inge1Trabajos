!classDefinition: #I category: 'Peano'!
DenotativeObject subclass: #I
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'I class' category: 'Peano'!
I class
	instanceVariableNames: 'next'!

!I class methodsFor: 'as yet unclassified' stamp: 'FC 8/27/2023 19:40:19'!
* aNaturalNumber
	^aNaturalNumber
	! !

!I class methodsFor: 'as yet unclassified' stamp: 'SC 8/24/2023 21:03:05'!
+ aNaturalNumber

	^aNaturalNumber next! !

!I class methodsFor: 'as yet unclassified' stamp: 'FC 8/27/2023 20:03:32'!
/ aNaturalNumber
	(aNaturalNumber == I)
		ifTrue: [^I].
		
	! !

!I class methodsFor: 'as yet unclassified' stamp: 'FC 8/27/2023 19:59:35'!
<= aNaturalNumber
	^true! !

!I class methodsFor: 'as yet unclassified' stamp: 'SC 8/24/2023 20:59:11'!
next
	next ifNotNil: [^next].
	next:=self cloneNamed: self name, 'I'.
	^next! !

!I class methodsFor: 'as yet unclassified' stamp: 'SC 8/24/2023 21:57:00'!
restateA: aNaturalNumber

	^aNaturalNumber previous! !

!I class methodsFor: 'as yet unclassified' stamp: 'FC 8/27/2023 20:18:43'!
restateAMi: aNaturalNumber eIncrementaResultadoDeDivision: resultadoDeDivision
	(self <= aNaturalNumber)
		ifTrue: [^resultadoDeDivision].
	! !


!I class methodsFor: '--** private fileout/in **--' stamp: 'FC 8/27/2023 20:34:21'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := II.! !


!classDefinition: #II category: 'Peano'!
DenotativeObject subclass: #II
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'II class' category: 'Peano'!
II class
	instanceVariableNames: 'next previous'!

!II class methodsFor: 'as yet unclassified' stamp: 'FC 8/27/2023 19:39:46'!
* aNaturalNumber
	^(self previous * aNaturalNumber) + aNaturalNumber! !

!II class methodsFor: 'as yet unclassified' stamp: 'SC 8/24/2023 21:09:00'!
+ aNaturalNumber

	^self previous + aNaturalNumber next! !

!II class methodsFor: 'as yet unclassified' stamp: 'SC 8/24/2023 21:53:54'!
- aNaturalNumber

	^aNaturalNumber restateA: self.! !

!II class methodsFor: 'as yet unclassified' stamp: 'FC 8/27/2023 20:30:03'!
/ aNaturalNumber
	
	^((self next) restateAMi: aNaturalNumber eIncrementaResultadoDeDivision: I) previous! !

!II class methodsFor: 'as yet unclassified' stamp: 'FC 8/27/2023 20:00:27'!
<= aNaturalNumber
	(aNaturalNumber == I)
		ifTrue: [^false].
	^(self previous <= aNaturalNumber previous)! !

!II class methodsFor: 'as yet unclassified' stamp: 'SC 8/24/2023 21:18:01'!
next
	next ifNotNil: [^next].
	next:=self cloneNamed: self name, 'I'.
	next previous: self.
	^next.! !

!II class methodsFor: 'as yet unclassified' stamp: 'SC 8/24/2023 21:21:03'!
previous

	^previous.! !

!II class methodsFor: 'as yet unclassified' stamp: 'SC 8/24/2023 21:25:53'!
previous: aNaturalNumber

	previous:= aNaturalNumber! !

!II class methodsFor: 'as yet unclassified' stamp: 'SC 8/24/2023 21:55:44'!
restateA: aNaturalNumber

	^aNaturalNumber previous - self previous.! !

!II class methodsFor: 'as yet unclassified' stamp: 'FC 8/27/2023 20:23:21'!
restateAMi: aNaturalNumber eIncrementaResultadoDeDivision: resultadoDeDivision
	(self <= aNaturalNumber)
		ifTrue: [^resultadoDeDivision].
	^(self-aNaturalNumber) restateAMi: aNaturalNumber eIncrementaResultadoDeDivision: resultadoDeDivision next! !


!II class methodsFor: '--** private fileout/in **--' stamp: 'FC 8/27/2023 20:34:21'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := nil.
	previous := I.! !

I initializeAfterFileIn!
II initializeAfterFileIn!