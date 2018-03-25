Class {
	#name : #SYMLTopLevelScope,
	#superclass : #SYMLAbstractScope,
	#instVars : [
		'module',
		'symbols',
		'implicitContextMetaMethods',
		'fallbackToReceiver',
		'genericMetaMethods'
	],
	#category : #Sysmel-Metamodel-Semantic
}

{ #category : #accessing }
SYMLTopLevelScope >> compilationTarget [
	^ module compilationTarget
]

{ #category : #accessing }
SYMLTopLevelScope >> fillWithBuiltInTypes [
	module compilationTarget builtInTypes do: [ :type |
		symbols at: type name put: type
	]
]

{ #category : #accessing }
SYMLTopLevelScope >> fillWithMetaBuilders [
	| builder |
	SYMLDefaultMetaBuilder allSubclassesDo: [ :sc |
		builder := sc new compilationTarget: module compilationTarget.
		symbols at: builder name put: builder
	]
]

{ #category : #accessing }
SYMLTopLevelScope >> fillWithMetaMethods [
	| metaMethod |
	SYMLImplicitContextMetaMethod allSubclassesDo: [ :sc |
		metaMethod := sc new compilationTarget: module compilationTarget.
		implicitContextMetaMethods at: metaMethod selector put: metaMethod
	]
]

{ #category : #accessing }
SYMLTopLevelScope >> fillWithObjects [
	symbols at: #Compiler put: module
]

{ #category : #accessing }
SYMLTopLevelScope >> findProgramEntityDefinitionScopeFrom: startingPoint [
	^ self
]

{ #category : #accessing }
SYMLTopLevelScope >> initialize [
	super initialize.
	symbols := Dictionary new.
	implicitContextMetaMethods := Dictionary new.
	genericMetaMethods := Dictionary new.
]

{ #category : #'meta methods' }
SYMLTopLevelScope >> lookMetaMethod: identifier hasReceiver: hasReceiver ifPresent: aBlock [
	hasReceiver ifTrue: [
		^ genericMetaMethods at: identifier ifPresent: aBlock
	] ifFalse: [
		^ implicitContextMetaMethods at: identifier ifPresent: aBlock
	]
	
]

{ #category : #'meta methods' }
SYMLTopLevelScope >> lookMetaMethod: identifier hasReceiver: hasReceiver ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock [
	hasReceiver ifTrue: [
		^ genericMetaMethods at: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock
	] ifFalse: [
		^ implicitContextMetaMethods at: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock
	]

	
]

{ #category : #symbols }
SYMLTopLevelScope >> lookSymbol: identifier ifPresent: aBlock [
	^ symbols at: identifier ifPresent: aBlock
]

{ #category : #symbols }
SYMLTopLevelScope >> lookSymbol: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock [
	^ symbols at: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock
]

{ #category : #accessing }
SYMLTopLevelScope >> metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	messageNode receiver ifNil: [
		^ implicitContextMetaMethods at: messageNode selector ifAbsent: [ nil ]
	] ifNotNil: [ 
		genericMetaMethods at: messageNode selector ifPresent: [ :metaMethod |
			(metaMethod canAnalyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition) ifTrue: [ 
				^ metaMethod
			]
		].
	].
	
	"Lets try to use the receiver meta method"
	^ fallbackToReceiver
]

{ #category : #accessing }
SYMLTopLevelScope >> module [
	^ module
]

{ #category : #accessing }
SYMLTopLevelScope >> module: anObject [
	module := anObject.
	self
		fillWithBuiltInTypes;
		fillWithMetaBuilders;
		fillWithMetaMethods;
		fillWithObjects.
		
	fallbackToReceiver := SYMLFallbackToReceiverMetaMethod new compilationTarget: module compilationTarget
]
