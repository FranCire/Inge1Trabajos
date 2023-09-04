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

!I class methodsFor: 'arithmeticOperations' stamp: 'FC 9/4/2023 00:06:43'!
* multiplier
	^multiplier
	! !

!I class methodsFor: 'arithmeticOperations' stamp: 'FC 9/4/2023 00:06:32'!
+ summand

	^summand next! !

!I class methodsFor: 'arithmeticOperations' stamp: 'FC 9/4/2023 00:26:24'!
- subtrahend

	^self error: self descripcionDeErrorDeNumerosNegativosNoSoportados ! !

!I class methodsFor: 'arithmeticOperations' stamp: 'FC 9/4/2023 00:22:22'!
/ divisor
	(divisor == I)
		ifTrue: [^I].
	
	^self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	! !

!I class methodsFor: 'arithmeticOperations' stamp: 'FC 9/4/2023 00:04:40'!
substractTo: minuend

	^minuend previous! !


!I class methodsFor: 'inequalities' stamp: 'FC 9/4/2023 00:06:02'!
<= numberToCompare
	^true! !


!I class methodsFor: 'errors' stamp: 'FC 9/4/2023 00:21:17'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un número mayor'! !

!I class methodsFor: 'errors' stamp: 'FC 9/4/2023 00:25:12'!
descripcionDeErrorDeNumerosNegativosNoSoportados
	^'No se soportan números negativos'! !


!I class methodsFor: 'consecutives' stamp: 'FC 9/4/2023 00:05:44'!
next
	next ifNotNil: [^next].
	next :=self cloneNamed: self name, 'I'.
	^next! !


!I class methodsFor: '--** private fileout/in **--' stamp: 'FC 9/4/2023 00:42:01'!
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
	instanceVariableNames: 'previous next'!

!II class methodsFor: 'arithmeticOperations' stamp: 'FC 9/3/2023 23:45:43'!
* multiplier
	^(self previous * multiplier) + multiplier! !

!II class methodsFor: 'arithmeticOperations' stamp: 'FC 9/3/2023 23:45:53'!
+ summand

	^self previous + summand next! !

!II class methodsFor: 'arithmeticOperations' stamp: 'FC 9/4/2023 00:05:08'!
- subtrahend

	^subtrahend substractTo: self.! !

!II class methodsFor: 'arithmeticOperations' stamp: 'FC 9/4/2023 00:31:29'!
/ divisor
	(self = divisor)
		ifTrue: [^I].
	(self <= divisor )
		ifTrue: [^self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor].
	^((self - divisor)/divisor) next
	
		! !

!II class methodsFor: 'arithmeticOperations' stamp: 'FC 9/3/2023 23:48:32'!
substractTo: minuend

	^minuend previous - self previous.! !


!II class methodsFor: 'inequalities' stamp: 'FC 9/4/2023 00:01:46'!
<= numberToCompare
	(numberToCompare = I)
		ifTrue: [^false].
	^(self previous <= numberToCompare previous)! !


!II class methodsFor: 'errors' stamp: 'FC 9/4/2023 00:20:43'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un número mayor'! !


!II class methodsFor: 'consecutives' stamp: 'FC 9/3/2023 23:43:16'!
next
	next ifNotNil: [^next].
	next := II createChildNamed: self name, 'I'.
	next previous: self.
	^next.! !

!II class methodsFor: 'consecutives' stamp: 'SC 8/24/2023 21:21:03'!
previous

	^previous.! !

!II class methodsFor: 'consecutives' stamp: 'FC 9/3/2023 23:53:22'!
previous: numberToSetAsPrevious

	previous:= numberToSetAsPrevious! !


!II class methodsFor: '--** private fileout/in **--' stamp: 'FC 9/4/2023 00:42:01'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	previous := I.
	next := III.! !


!classDefinition: #III category: 'Peano'!
II subclass: #III
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'III class' category: 'Peano'!
III class
	instanceVariableNames: ''!

!III class methodsFor: '--** private fileout/in **--' stamp: 'FC 9/4/2023 00:42:01'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	previous := II.
	next := IIII.! !


!classDefinition: #IIII category: 'Peano'!
II subclass: #IIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIII class' category: 'Peano'!
IIII class
	instanceVariableNames: ''!

!IIII class methodsFor: '--** private fileout/in **--' stamp: 'FC 9/4/2023 00:42:01'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	previous := III.
	next := IIIII.! !


!classDefinition: #IIIII category: 'Peano'!
II subclass: #IIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIII class' category: 'Peano'!
IIIII class
	instanceVariableNames: ''!

!IIIII class methodsFor: '--** private fileout/in **--' stamp: 'FC 9/4/2023 00:42:01'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	previous := IIII.
	next := IIIIII.! !


!classDefinition: #IIIIII category: 'Peano'!
II subclass: #IIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIIII class' category: 'Peano'!
IIIIII class
	instanceVariableNames: ''!

!IIIIII class methodsFor: '--** private fileout/in **--' stamp: 'FC 9/4/2023 00:42:01'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	previous := IIIII.
	next := IIIIIII.! !


!classDefinition: #IIIIIII category: 'Peano'!
II subclass: #IIIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIIIII class' category: 'Peano'!
IIIIIII class
	instanceVariableNames: ''!

!IIIIIII class methodsFor: '--** private fileout/in **--' stamp: 'FC 9/4/2023 00:42:01'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	previous := IIIIII.
	next := IIIIIIII.! !


!classDefinition: #IIIIIIII category: 'Peano'!
II subclass: #IIIIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIIIIII class' category: 'Peano'!
IIIIIIII class
	instanceVariableNames: ''!

!IIIIIIII class methodsFor: '--** private fileout/in **--' stamp: 'FC 9/4/2023 00:42:01'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	previous := IIIIIII.
	next := IIIIIIIII.! !


!classDefinition: #IIIIIIIII category: 'Peano'!
II subclass: #IIIIIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIIIIIII class' category: 'Peano'!
IIIIIIIII class
	instanceVariableNames: ''!

!IIIIIIIII class methodsFor: '--** private fileout/in **--' stamp: 'FC 9/4/2023 00:42:01'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	previous := IIIIIIII.
	next := nil.! !

I initializeAfterFileIn!
II initializeAfterFileIn!
III initializeAfterFileIn!
IIII initializeAfterFileIn!
IIIII initializeAfterFileIn!
IIIIII initializeAfterFileIn!
IIIIIII initializeAfterFileIn!
IIIIIIII initializeAfterFileIn!
IIIIIIIII initializeAfterFileIn!