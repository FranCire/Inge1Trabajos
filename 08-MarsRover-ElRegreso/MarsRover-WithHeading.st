!classDefinition: #LogTest category: 'MarsRover-WithHeading'!
TestCase subclass: #LogTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!LogTest methodsFor: 'tests' stamp: 'FC 10/30/2023 02:29:00'!
test01LogOfNewMarsRoverIsEmpty
	|marsRover log|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	log := Log of: marsRover withConfiguration: PositionLogConfiguration .
	self assert: log logged equals: OrderedCollection new.! !

!LogTest methodsFor: 'tests' stamp: 'FC 10/30/2023 02:29:05'!
test02LogOfPositionAfterMovesWithNoHeadChanges
	|marsRover log|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	log := Log of: marsRover withConfiguration: PositionLogConfiguration .
	marsRover process: 'fff'.
	
	self assert: log logged equals: (OrderedCollection with: 0@1 with: 0@2 with: 0@3).! !

!LogTest methodsFor: 'tests' stamp: 'FC 10/30/2023 02:29:13'!
test03LogOfHeadAfterHeadChangesWithNoMoves
	|marsRover log|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	log := Log of: marsRover withConfiguration: HeadLogConfiguration .
	marsRover process: 'rrl'.
	
	self assert: log logged equals: (OrderedCollection with: 'East' with: 'South' with: 'East').! !

!LogTest methodsFor: 'tests' stamp: 'FC 10/30/2023 02:29:19'!
test04LogOfPositionsAfterMovesWithHeadChanges
	|marsRover log|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	log := Log of: marsRover withConfiguration: PositionLogConfiguration .
	marsRover process: 'frfrf'.
	
	self assert: log logged equals: (OrderedCollection with: 0@1 with: 1@1 with: 1@0).! !

!LogTest methodsFor: 'tests' stamp: 'FC 10/30/2023 02:29:24'!
test05LogOfHeadAfterHeadChangesWithMoves
	|marsRover log|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	log := Log of: marsRover withConfiguration: HeadLogConfiguration .
	marsRover process: 'frfrfrfr'.
	
	self assert: log logged equals: (OrderedCollection with: 'East' with:'South' with: 'West' with: 'North').! !

!LogTest methodsFor: 'tests' stamp: 'FC 10/30/2023 02:29:33'!
test06LogOfPositionAndHeadAfterOnlyPositionChanges
	|marsRover log|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	log := Log of: marsRover withConfiguration: HeadAndPositionLogConfiguration .
	marsRover process: 'fbf'.
	
	self assert: log logged equals: (OrderedCollection with: 0@1 with:0@0 with: 0@1).! !

!LogTest methodsFor: 'tests' stamp: 'FC 10/30/2023 02:29:38'!
test07LogOfPositionAndHeadAfterOnlyHeadChanges
	|marsRover log|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	log := Log of: marsRover withConfiguration: HeadAndPositionLogConfiguration .
	marsRover process: 'lll'.
	
	self assert: log logged equals: (OrderedCollection with: 'West' with:'South' with: 'East').! !

!LogTest methodsFor: 'tests' stamp: 'FC 10/30/2023 02:29:43'!
test08LogOfPositionAndHeadAfterPositionAndHeadChanges
	|marsRover log|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	log := Log of: marsRover withConfiguration: HeadAndPositionLogConfiguration .
	marsRover process: 'blfrf'.
	
	self assert: log logged equals: (OrderedCollection with: 0@-1 with:'West' with: -1@-1 with: 'North' with: -1@0).! !


!classDefinition: #MarsRoverTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:21:23'!
test01DoesNotMoveWhenNoCommand

	self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: '' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:12'!
test02IsAtFailsForDifferentPosition

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@2 heading: self north)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:31'!
test03IsAtFailsForDifferentHeading

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@1 heading: self south)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:17'!
test04IncrementsYAfterMovingForwardWhenHeadingNorth

	self 
		assertIsAt: 1@3 
		heading: self north 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:11'!
test06DecrementsYAfterMovingBackwardsWhenHeadingNorth

	self 
		assertIsAt: 1@1 
		heading: self north 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:59'!
test07PointToEashAfterRotatingRightWhenHeadingNorth

	self 
		assertIsAt: 1@2 
		heading: self east 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:51'!
test08PointsToWestAfterRotatingLeftWhenPointingNorth

	self 
		assertIsAt: 1@2 
		heading: self west 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:45'!
test09DoesNotProcessInvalidCommand

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: self north.
	
	self 
		should: [ marsRover process: 'x' ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: marsRover invalidCommandErrorDescription.
			self assert: (marsRover isAt: 1@2 heading: self north) ]! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:39'!
test10CanProcessMoreThanOneCommand

	self 
		assertIsAt: 1@4 
		heading: self north 
		afterProcessing: 'ff' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:31'!
test11IncrementsXAfterMovingForwareWhenHeadingEast

	self 
		assertIsAt: 2@2 
		heading: self east 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:19'!
test12DecrementsXAfterMovingBackwardWhenHeadingEast

	self 
		assertIsAt: 0@2 
		heading: self east 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:14'!
test13PointsToSouthAfterRotatingRightWhenHeadingEast

		self 
		assertIsAt: 1@2 
		heading: self south 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:05'!
test14PointsToNorthAfterRotatingLeftWhenPointingEast

		self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:00'!
test15ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingSouth

	self 
		assertIsAt: 1@1 
		heading: self west 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self south 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:52'!
test16ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingWest

	self 
		assertIsAt: 0@2 
		heading: self north 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self west 
! !


!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:31'!
east

	^ MarsRoverHeadingEast ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:38'!
north

	^ MarsRoverHeadingNorth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:45'!
south

	^ MarsRoverHeadingSouth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:54'!
west

	^ MarsRoverHeadingWest ! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'HAW 10/7/2021 20:20:47'!
assertIsAt: newPosition heading: newHeadingType afterProcessing: commands whenStartingAt: startPosition heading: startHeadingType

	| marsRover |
	
	marsRover := MarsRover at: startPosition heading: startHeadingType. 
	
	marsRover process: commands.
	
	self assert: (marsRover isAt: newPosition heading: newHeadingType)! !


!classDefinition: #WindowTest category: 'MarsRover-WithHeading'!
TestCase subclass: #WindowTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!WindowTest methodsFor: 'testing' stamp: 'FC 10/30/2023 02:41:36'!
test01PositionWindowOfNewMarsRoverIsEmpty
	|marsRover window|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	window := Window of: marsRover withConfiguration: PositionWindowConfiguration .
	self assert: window position equals: ''.
! !

!WindowTest methodsFor: 'testing' stamp: 'FC 10/30/2023 02:41:44'!
test02PositionWindowOfMarsRoverAfterMovementsWithNoHeadChanges
	|marsRover window|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	window := Window of: marsRover withConfiguration:  PositionWindowConfiguration .
	marsRover process: 'f'.
	self assert: window position equals: 0@1.
	marsRover process:'f'.
	self assert: window position equals: 0@2.
	marsRover process: 'b'.
	self assert: window position equals: 0@1.
	marsRover process:'b'.
	self assert: window position equals: 0@0.
	
! !

!WindowTest methodsFor: 'testing' stamp: 'FC 10/30/2023 02:41:51'!
test03PositionWindowOfMarsRoverAfterMovementsWithHeadChanges
	|marsRover window|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	window := Window of: marsRover withConfiguration: PositionWindowConfiguration .
	marsRover process: 'f'.
	self assert: window position equals: 0@1.
	marsRover process:'f'.
	self assert: window position equals: 0@2.
	marsRover process:'r'.
	self assert: window position equals: 0@2.
	marsRover process: 'b'.
	self assert: window position equals: -1@2.
	marsRover process:'b'.
	self assert: window position equals: -2@2.
	
! !

!WindowTest methodsFor: 'testing' stamp: 'FC 10/30/2023 02:42:07'!
test04HeadWindowOfNewMarsRoverIsEmpty
	|marsRover window|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	window := Window of: marsRover withConfiguration: HeadWindowConfiguration .
	self assert: window heading equals: ''.
	
! !

!WindowTest methodsFor: 'testing' stamp: 'FC 10/30/2023 02:42:15'!
test05HeadWindowOfMarsRoverAfterHeadChangesWithNoMovement
	|marsRover window|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	window := Window of: marsRover withConfiguration: HeadWindowConfiguration.
	marsRover process:'r'.
	self assert: window heading equals: 'Apuntando al Este'.
	marsRover process:'r'.
	self assert: window heading equals: 'Apuntando al Sur'.
	marsRover process: 'r'.
	self assert: window heading equals: 'Apuntando al Oeste'.
	
! !

!WindowTest methodsFor: 'testing' stamp: 'FC 10/30/2023 02:42:21'!
test06HeadWindowOfMarsRoverAfterHeadChangesWithMovement
	|marsRover window|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	window := Window of: marsRover withConfiguration: HeadWindowConfiguration.
	marsRover process:'r'.
	self assert: window heading equals: 'Apuntando al Este'.
	marsRover process:'f'.
	self assert: window heading equals: 'Apuntando al Este'.
	marsRover process:'r'.
	self assert: window heading equals: 'Apuntando al Sur'.
	marsRover process: 'f'.
	self assert: window heading equals: 'Apuntando al Sur'.

	marsRover process: 'r'.
	self assert: window heading equals: 'Apuntando al Oeste'.
	
! !

!WindowTest methodsFor: 'testing' stamp: 'SC 10/30/2023 03:26:16'!
test07PositionAndHeadWindowOfMarsRoverAfterHeadAndPositionChanges
	|marsRover window|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	window := Window of: marsRover withConfiguration: HeadAndPositionWindowConfiguration.
	marsRover process:'r'.
	self assert: window position equals:''.
	self assert: window heading equals: 'Apuntando al Este'.
	marsRover process:'f'.
	self assert: window position equals: 1@0.
	self assert: window heading equals: 'Apuntando al Este'.
	marsRover process:'r'.
	self assert: window position equals: 1@0.
	self assert: window heading equals: 'Apuntando al Sur'.
	marsRover process: 'f'.
	self assert: window position equals: 1@-1.
	self assert: window heading equals: 'Apuntando al Sur'.
	marsRover process: 'r'.
	self assert: window position equals: 1@-1.
	self assert: window heading equals: 'Apuntando al Oeste'.
	
! !

!WindowTest methodsFor: 'testing' stamp: 'SC 10/30/2023 03:15:47'!
test08ShouldFailWindowPositionWithHeadWindowConfiguration
	|marsRover window|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	window := Window of: marsRover withConfiguration: HeadWindowConfiguration.
		self 
		should: [^window position]
		raise: Error
		withExceptionDo: [:anError |
			self assert: WindowConfiguration positionNotAvailableErrorMessage equals: anError messageText ]
	
! !

!WindowTest methodsFor: 'testing' stamp: 'SC 10/30/2023 03:15:31'!
test09ShouldFailWindowHeadingWithPositionWindowConfiguration
	|marsRover window|
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	window := Window of: marsRover withConfiguration: PositionWindowConfiguration.
		self 
		should: [^window heading]
		raise: Error
		withExceptionDo: [:anError |
			self assert: WindowConfiguration headingNotAvailableErrorMessage equals: anError messageText ]
	
! !


!classDefinition: #Log category: 'MarsRover-WithHeading'!
Object subclass: #Log
	instanceVariableNames: 'logged configuration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!Log methodsFor: 'observers' stamp: 'FC 10/30/2023 01:38:27'!
registerHeadChange: newHeadingOfMarsRover
	newHeadingOfMarsRover accept: self.! !

!Log methodsFor: 'observers' stamp: 'FC 10/29/2023 23:41:53'!
registerPositionChange: newPositionOfMarsRover
	logged add: newPositionOfMarsRover! !


!Log methodsFor: 'visit' stamp: 'FC 10/30/2023 01:36:20'!
visitEastHeadingMarsRover: marsRoverToVisit.
	logged add:'East'.! !

!Log methodsFor: 'visit' stamp: 'FC 10/30/2023 01:36:36'!
visitNorthHeadingMarsRover: marsRoverToVisit.
	logged add:'North'.! !

!Log methodsFor: 'visit' stamp: 'FC 10/30/2023 01:36:28'!
visitSouthHeadingMarsRover: marsRoverToVisit.
	logged add:'South'.! !

!Log methodsFor: 'visit' stamp: 'FC 10/30/2023 01:36:43'!
visitWestHeadingMarsRover: marsRoverToVisit.
	logged add:'West'.! !


!Log methodsFor: 'accessing' stamp: 'FC 10/29/2023 23:35:03'!
logged
	^logged ! !


!Log methodsFor: 'initialization' stamp: 'FC 10/29/2023 23:36:52'!
initialize
	logged := OrderedCollection new.! !

!Log methodsFor: 'initialization' stamp: 'FC 10/30/2023 02:36:01'!
initializeForMarsRover: marsRoverToLog withConfiguration: configurationOfLog
	configuration := configurationOfLog new.
	configuration sendObservationRequestsForCollaboratorsOfMarsRover: marsRoverToLog forLog: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Log class' category: 'MarsRover-WithHeading'!
Log class
	instanceVariableNames: ''!

!Log class methodsFor: 'instance creation' stamp: 'FC 10/30/2023 02:34:54'!
of: marsRoverToLog withConfiguration: configurationOfLog
	^self new initializeForMarsRover: marsRoverToLog withConfiguration: configurationOfLog.
	! !


!classDefinition: #LogConfiguration category: 'MarsRover-WithHeading'!
Object subclass: #LogConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!LogConfiguration methodsFor: 'request' stamp: 'FC 10/30/2023 02:23:33'!
sendObservationRequestsForCollaboratorsOfMarsRover: marsRoverToObserveCollaboratorFrom forLog: logToReceiveObservations

	self subclassResponsibility! !


!classDefinition: #HeadAndPositionLogConfiguration category: 'MarsRover-WithHeading'!
LogConfiguration subclass: #HeadAndPositionLogConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!HeadAndPositionLogConfiguration methodsFor: 'request' stamp: 'FC 10/30/2023 02:24:24'!
sendObservationRequestsForCollaboratorsOfMarsRover: marsRoverToObserveCollaboratorFrom forLog: logToReceiveObservations
	
	marsRoverToObserveCollaboratorFrom addPositionObserverRequest: [:newPositionOfMarsRover | logToReceiveObservations registerPositionChange: newPositionOfMarsRover].
	marsRoverToObserveCollaboratorFrom addHeadObserverRequest: [:newHeadingOfMarsRover | logToReceiveObservations registerHeadChange: newHeadingOfMarsRover].! !


!classDefinition: #HeadLogConfiguration category: 'MarsRover-WithHeading'!
LogConfiguration subclass: #HeadLogConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!HeadLogConfiguration methodsFor: 'request' stamp: 'FC 10/30/2023 02:24:04'!
sendObservationRequestsForCollaboratorsOfMarsRover: marsRoverToObserveCollaboratorFrom forLog: logToReceiveObservations

	marsRoverToObserveCollaboratorFrom addHeadObserverRequest: [:newHeadingOfMarsRover | logToReceiveObservations registerHeadChange: newHeadingOfMarsRover].! !


!classDefinition: #PositionLogConfiguration category: 'MarsRover-WithHeading'!
LogConfiguration subclass: #PositionLogConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!PositionLogConfiguration methodsFor: 'request' stamp: 'FC 10/30/2023 02:24:36'!
sendObservationRequestsForCollaboratorsOfMarsRover: marsRoverToObserveCollaboratorFrom forLog: logToReceiveObservations

	marsRoverToObserveCollaboratorFrom addPositionObserverRequest: [:newPositionOfMarsRover | logToReceiveObservations registerPositionChange: newPositionOfMarsRover].! !


!classDefinition: #MarsRover category: 'MarsRover-WithHeading'!
Object subclass: #MarsRover
	instanceVariableNames: 'position head loggers positionLoggers headLoggers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:48:45'!
invalidCommandErrorDescription
	
	^'Invalid command'! !

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:50:26'!
signalInvalidCommand
	
	self error: self invalidCommandErrorDescription ! !


!MarsRover methodsFor: 'initialization' stamp: 'FC 10/30/2023 02:16:08'!
initializeAt: aPosition heading: aHeadingType

	position := ObservedCollaborator with: aPosition.
	head := ObservedCollaborator with: (aHeadingType for: self).! !


!MarsRover methodsFor: 'heading' stamp: 'FC 10/30/2023 01:55:40'!
headEast
	
	head setTo:(MarsRoverHeadingEast for: self).
! !

!MarsRover methodsFor: 'heading' stamp: 'FC 10/30/2023 01:55:51'!
headNorth
	
	head setTo: (MarsRoverHeadingNorth for: self).
! !

!MarsRover methodsFor: 'heading' stamp: 'FC 10/30/2023 01:56:04'!
headSouth
	
	head setTo: (MarsRoverHeadingSouth for: self).
! !

!MarsRover methodsFor: 'heading' stamp: 'FC 10/30/2023 01:56:12'!
headWest
	
	head setTo: (MarsRoverHeadingWest for: self).
! !

!MarsRover methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	head rotateLeft! !

!MarsRover methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	head rotateRight! !


!MarsRover methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:16:32'!
isAt: aPosition heading: aHeadingType

	^position = aPosition and: [ head isHeading: aHeadingType ]! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:51'!
isBackwardCommand: aCommand

	^aCommand = $b! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:19'!
isForwardCommand: aCommand

	^aCommand = $f ! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:51'!
isRotateLeftCommand: aCommand

	^aCommand = $l! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:21'!
isRotateRightCommand: aCommand

	^aCommand = $r! !


!MarsRover methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	head moveBackward! !

!MarsRover methodsFor: 'moving' stamp: 'FC 10/30/2023 01:56:49'!
moveEast
	
	position setTo: (position + (1@0)).
! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	head moveForward! !

!MarsRover methodsFor: 'moving' stamp: 'FC 10/30/2023 01:57:03'!
moveNorth
	
	position setTo: (position + (0@1)).
! !

!MarsRover methodsFor: 'moving' stamp: 'FC 10/30/2023 01:57:11'!
moveSouth
	
	position setTo: (position + (0@-1)).
! !

!MarsRover methodsFor: 'moving' stamp: 'FC 10/30/2023 01:57:19'!
moveWest
	
	position setTo: (position + (-1@0)).
! !


!MarsRover methodsFor: 'command processing' stamp: 'FC 10/29/2023 23:46:05'!
process: aSequenceOfCommands

	aSequenceOfCommands do: [:aCommand | 
		self processCommand: aCommand.
	]
! !

!MarsRover methodsFor: 'command processing' stamp: 'HAW 8/22/2019 12:08:50'!
processCommand: aCommand

	(self isForwardCommand: aCommand) ifTrue: [ ^ self moveForward ].
	(self isBackwardCommand: aCommand) ifTrue: [ ^ self moveBackward ].
	(self isRotateRightCommand: aCommand) ifTrue: [ ^ self rotateRight ].
	(self isRotateLeftCommand: aCommand) ifTrue: [ ^ self rotateLeft ].

	self signalInvalidCommand.! !


!MarsRover methodsFor: 'observers' stamp: 'FC 10/30/2023 01:58:44'!
addHeadObserverRequest: observerRequestForHeadToAdd
	head addObserverRequest: observerRequestForHeadToAdd ! !

!MarsRover methodsFor: 'observers' stamp: 'FC 10/30/2023 01:58:27'!
addPositionObserverRequest: observerRequestForPositionToAdd
	position addObserverRequest: observerRequestForPositionToAdd ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover-WithHeading'!
MarsRover class
	instanceVariableNames: 'headings'!

!MarsRover class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:10:30'!
at: aPosition heading: aHeadingType
	
	^self new initializeAt: aPosition heading: aHeadingType! !


!classDefinition: #MarsRoverHeading category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverHeading
	instanceVariableNames: 'marsRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:15:38'!
isHeading: aHeadingType

	^self isKindOf: aHeadingType ! !


!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'initialization' stamp: 'HAW 10/7/2021 20:11:59'!
initializeFor: aMarsRover 
	
	marsRover := aMarsRover.! !


!MarsRoverHeading methodsFor: 'accepting' stamp: 'FC 10/30/2023 01:34:20'!
accept: marsRoverHeadingVisitor

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeading class' category: 'MarsRover-WithHeading'!
MarsRoverHeading class
	instanceVariableNames: ''!

!MarsRoverHeading class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:11:35'!
for: aMarsRover 
	
	^self new initializeFor: aMarsRover ! !


!classDefinition: #MarsRoverHeadingEast category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingEast
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveWest! !

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveEast! !


!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headNorth! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headSouth! !


!MarsRoverHeadingEast methodsFor: 'accepting' stamp: 'FC 10/30/2023 01:34:51'!
accept: marsRoverHeadingVisitor
	marsRoverHeadingVisitor visitEastHeadingMarsRover: self.! !


!classDefinition: #MarsRoverHeadingNorth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingNorth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveSouth! !

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveNorth! !


!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headWest! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headEast! !


!MarsRoverHeadingNorth methodsFor: 'accepting' stamp: 'FC 10/30/2023 01:35:03'!
accept: marsRoverHeadingVisitor
	marsRoverHeadingVisitor visitNorthHeadingMarsRover: self.! !


!classDefinition: #MarsRoverHeadingSouth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingSouth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveNorth! !

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveSouth! !


!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headEast! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headWest! !


!MarsRoverHeadingSouth methodsFor: 'accepting' stamp: 'FC 10/30/2023 01:35:15'!
accept: marsRoverHeadingVisitor
	marsRoverHeadingVisitor visitSouthHeadingMarsRover: self.! !


!classDefinition: #MarsRoverHeadingWest category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingWest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	^marsRover moveEast! !

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveWest! !


!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headSouth! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headNorth! !


!MarsRoverHeadingWest methodsFor: 'accepting' stamp: 'FC 10/30/2023 01:35:27'!
accept: marsRoverHeadingVisitor
	marsRoverHeadingVisitor visitWestHeadingMarsRover: self.! !


!classDefinition: #ObservedCollaborator category: 'MarsRover-WithHeading'!
Object subclass: #ObservedCollaborator
	instanceVariableNames: 'collaborator observersRequests'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!ObservedCollaborator methodsFor: 'observers' stamp: 'FC 10/30/2023 01:48:10'!
addObserverRequest: newObserverRequest
	observersRequests add: newObserverRequest .! !

!ObservedCollaborator methodsFor: 'observers' stamp: 'FC 10/30/2023 01:50:50'!
fulfillObserverRequests
	observersRequests do: [:observerRequest | observerRequest value: collaborator].! !


!ObservedCollaborator methodsFor: 'initialization' stamp: 'FC 10/30/2023 02:07:34'!
initializeWith: initialCollaboratorValue
	observersRequests := OrderedCollection new.
	collaborator := initialCollaboratorValue ! !

!ObservedCollaborator methodsFor: 'initialization' stamp: 'FC 10/30/2023 01:50:54'!
setTo: newObservedCollaboratorValue
	collaborator := newObservedCollaboratorValue.
	self fulfillObserverRequests ! !


!ObservedCollaborator methodsFor: 'error handling' stamp: 'FC 10/30/2023 01:52:04'!
doesNotUnderstand: message
	^message sendTo: collaborator
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ObservedCollaborator class' category: 'MarsRover-WithHeading'!
ObservedCollaborator class
	instanceVariableNames: ''!

!ObservedCollaborator class methodsFor: 'instance creation' stamp: 'FC 10/30/2023 02:07:00'!
with: collaboratorInitialValue
	^self new initializeWith: collaboratorInitialValue ! !


!classDefinition: #Window category: 'MarsRover-WithHeading'!
Object subclass: #Window
	instanceVariableNames: 'position heading configuration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!Window methodsFor: 'accessing' stamp: 'SC 10/30/2023 03:01:16'!
heading
	^configuration isHeadAvailable: self.! !

!Window methodsFor: 'accessing' stamp: 'SC 10/30/2023 03:04:50'!
headingIfAvailable
	^heading.! !

!Window methodsFor: 'accessing' stamp: 'SC 10/30/2023 02:56:12'!
position
	^configuration isPositionAvailable: self.! !

!Window methodsFor: 'accessing' stamp: 'SC 10/30/2023 02:59:44'!
positionIfAvailable
	^position! !


!Window methodsFor: 'initialization' stamp: 'FC 10/30/2023 01:26:44'!
initialize
	position := ''.
	heading := ''.! !

!Window methodsFor: 'initialization' stamp: 'FC 10/30/2023 02:44:12'!
initializeForMarsRover: marsRover withConfiguration: configurationForWindow
	configuration := configurationForWindow new.
	configuration sendObservationRequestsForCollaboratorsOfMarsRover: marsRover forWindow: self.! !


!Window methodsFor: 'observers' stamp: 'FC 10/30/2023 01:38:37'!
registerHeadChange: newHeadingOfMarsRover
	newHeadingOfMarsRover accept: self.! !

!Window methodsFor: 'observers' stamp: 'FC 10/30/2023 01:16:49'!
registerPositionChange: newPositionOfMarsRover
	position := newPositionOfMarsRover ! !


!Window methodsFor: 'visitor' stamp: 'FC 10/30/2023 01:37:44'!
visitEastHeadingMarsRover: marsRoverToVisit.
	heading := 'Apuntando al Este'.! !

!Window methodsFor: 'visitor' stamp: 'FC 10/30/2023 01:37:51'!
visitNorthHeadingMarsRover: marsRoverToVisit.
	heading := 'Apuntando al Norte'.! !

!Window methodsFor: 'visitor' stamp: 'FC 10/30/2023 01:38:06'!
visitSouthHeadingMarsRover: marsRoverToVisit.
	heading := 'Apuntando al Sur'.! !

!Window methodsFor: 'visitor' stamp: 'FC 10/30/2023 01:37:37'!
visitWestHeadingMarsRover: marsRoverToVisit.
	heading := 'Apuntando al Oeste'.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Window class' category: 'MarsRover-WithHeading'!
Window class
	instanceVariableNames: ''!

!Window class methodsFor: 'instance creation' stamp: 'FC 10/30/2023 02:44:37'!
of: marsRover withConfiguration: configurationForWindow
	^self new initializeForMarsRover: marsRover withConfiguration: configurationForWindow.! !


!classDefinition: #WindowConfiguration category: 'MarsRover-WithHeading'!
Object subclass: #WindowConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!WindowConfiguration methodsFor: 'accessing' stamp: 'SC 10/30/2023 03:02:02'!
isHeadAvailable: aWindow

	self subclassResponsibility! !

!WindowConfiguration methodsFor: 'accessing' stamp: 'SC 10/30/2023 03:00:40'!
isPositionAvailable: aWindow

	self subclassResponsibility! !


!WindowConfiguration methodsFor: 'request' stamp: 'FC 10/30/2023 02:37:45'!
sendObservationRequestsForCollaboratorsOfMarsRover: marsRoverToObserveCollaboratorFrom forWindow: windowToReceiveObservations

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WindowConfiguration class' category: 'MarsRover-WithHeading'!
WindowConfiguration class
	instanceVariableNames: ''!

!WindowConfiguration class methodsFor: 'error message' stamp: 'SC 10/30/2023 03:11:55'!
headingNotAvailableErrorMessage
	^'Heading is not available'.! !

!WindowConfiguration class methodsFor: 'error message' stamp: 'SC 10/30/2023 03:11:44'!
positionNotAvailableErrorMessage
	^'Position is not available'.! !


!classDefinition: #HeadAndPositionWindowConfiguration category: 'MarsRover-WithHeading'!
WindowConfiguration subclass: #HeadAndPositionWindowConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!HeadAndPositionWindowConfiguration methodsFor: 'accessing' stamp: 'SC 10/30/2023 03:02:14'!
isHeadAvailable: aWindow

	^aWindow headingIfAvailable.! !

!HeadAndPositionWindowConfiguration methodsFor: 'accessing' stamp: 'SC 10/30/2023 03:00:12'!
isPositionAvailable: aWindow
	^aWindow positionIfAvailable.! !


!HeadAndPositionWindowConfiguration methodsFor: 'request' stamp: 'FC 10/30/2023 02:38:34'!
sendObservationRequestsForCollaboratorsOfMarsRover: marsRoverToObserveCollaboratorFrom forWindow: windowToReceiveObservations
	marsRoverToObserveCollaboratorFrom addPositionObserverRequest: [:newPositionOfMarsRover | windowToReceiveObservations registerPositionChange: newPositionOfMarsRover].
	marsRoverToObserveCollaboratorFrom addHeadObserverRequest: [:newHeadingOfMarsRover | windowToReceiveObservations registerHeadChange: newHeadingOfMarsRover].! !


!classDefinition: #HeadWindowConfiguration category: 'MarsRover-WithHeading'!
WindowConfiguration subclass: #HeadWindowConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!HeadWindowConfiguration methodsFor: 'accessing' stamp: 'SC 10/30/2023 03:02:27'!
isHeadAvailable: aWindow

	^aWindow headingIfAvailable.! !

!HeadWindowConfiguration methodsFor: 'accessing' stamp: 'SC 10/30/2023 03:13:00'!
isPositionAvailable: aWindow
	self error: super class positionNotAvailableErrorMessage! !


!HeadWindowConfiguration methodsFor: 'request' stamp: 'FC 10/30/2023 02:38:55'!
sendObservationRequestsForCollaboratorsOfMarsRover: marsRoverToObserveCollaboratorFrom forWindow: windowToReceiveObservations
	marsRoverToObserveCollaboratorFrom addHeadObserverRequest: [:newHeadingOfMarsRover | windowToReceiveObservations registerHeadChange: newHeadingOfMarsRover].! !


!classDefinition: #PositionWindowConfiguration category: 'MarsRover-WithHeading'!
WindowConfiguration subclass: #PositionWindowConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!PositionWindowConfiguration methodsFor: 'accessing' stamp: 'SC 10/30/2023 03:13:16'!
isHeadAvailable: aWindow

	self error: super class headingNotAvailableErrorMessage! !

!PositionWindowConfiguration methodsFor: 'accessing' stamp: 'SC 10/30/2023 03:00:17'!
isPositionAvailable: aWindow
	^aWindow positionIfAvailable.! !


!PositionWindowConfiguration methodsFor: 'request' stamp: 'FC 10/30/2023 02:38:42'!
sendObservationRequestsForCollaboratorsOfMarsRover: marsRoverToObserveCollaboratorFrom forWindow: windowToReceiveObservations
	marsRoverToObserveCollaboratorFrom addPositionObserverRequest: [:newPositionOfMarsRover | windowToReceiveObservations registerPositionChange: newPositionOfMarsRover].! !
