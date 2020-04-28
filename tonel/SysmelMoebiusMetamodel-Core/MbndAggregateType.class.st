Class {
	#name : #MbndAggregateType,
	#superclass : #MbndNativeType,
	#instVars : [
		'basicInitializeMethod',
		'initializeMethod',
		'finalizeMethod',
		'initializeFromCopyMethod',
		'initializeMovingFromMethod'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndAggregateType class >> typeName [
	^ #_AggregateType
]

{ #category : #converting }
MbndAggregateType >> asConstReceiverType [
	^ self const ref
]

{ #category : #converting }
MbndAggregateType >> asImmutableValueType [
	^ self const ref
]

{ #category : #converting }
MbndAggregateType >> asReceiverType [
	^ self ref
]

{ #category : #'initialize-destroy' }
MbndAggregateType >> basicInitializeMethod [
	(self areSyntheticMethodsInternal and: [ self hasTrivialInstanceBasicInitialization ]) ifTrue: [
		^ super basicInitializeMethod
	].

	basicInitializeMethod ifNil: [ self createBasicInitializeMethod ].
	^ basicInitializeMethod
]

{ #category : #'initialize-destroy' }
MbndAggregateType >> createBasicInitializeMethod [
	| asReceiverType |
	asReceiverType := self asReceiverType.
	self assert: self compilationEnvironment currentModule isNotNil.
	basicInitializeMethod := MbndAggregateBasicInitializeMethod new
		name: #basicInitialize;
		receiverType: asReceiverType;
		module: self compilationEnvironment currentModule;
		type: (self compilationTarget functionTypeWithArguments: {asReceiverType} returnType: self compilationTarget voidType);
		boundType: (self compilationTarget functionTypeWithArguments: #() returnType: self compilationTarget voidType).
	self
		addChild: basicInitializeMethod;
		addOverloadedMethod: basicInitializeMethod
]

{ #category : #'initialize-destroy' }
MbndAggregateType >> finalizeMethod [
	(self areSyntheticMethodsInternal and: [ self hasTrivialInstanceFinalization ]) ifTrue: [
		^ super finalizeMethod
	].
	
	^ finalizeMethod ifNil: [ finalizeMethod := self getOrCreateOptionallyGeneratedMethod: #finalize ofKind: MbndAggregateFinalizeMethod argumentTypes: #() returnType: self compilationTarget voidType]
]

{ #category : #accessing }
MbndAggregateType >> getFieldOffset: fieldName [
	^ self slotLayout getFieldOffset: fieldName
]

{ #category : #'initialize-destroy' }
MbndAggregateType >> getOrCreateOptionallyGeneratedMethod: selector ofKind: generatedMethodClass argumentTypes: argumentTypes returnType: returnType [
	| method parentVersion asReceiverType |
	self overloadedMethodDict at: selector ifPresent: [ :existent |
		self flag: 'TODO: Check the existent method argument types.'.
		^ existent
	].

	asReceiverType := self asReceiverType.
	self assert: self compilationEnvironment currentModule isNotNil.
	method := generatedMethodClass new
		module: self compilationEnvironment currentModule;
		name: selector;
		receiverType: asReceiverType;
		type: (self compilationTarget functionTypeWithArguments: {asReceiverType} , argumentTypes returnType: returnType);
		boundType: (self compilationTarget functionTypeWithArguments: argumentTypes returnType: returnType).

	self supertype isTrait not ifTrue: [
		parentVersion := self supertype lookupOverloadedSelector: selector withBoundType: method boundType.
		(parentVersion isNotNil and: [ parentVersion hasVirtualTableEntry ]) ifTrue: [
			method addFlag: #override
		].
	].

	self
		addChild: method;
		addOverloadedMethod: method.
	^ method
]

{ #category : #'initialize-destroy' }
MbndAggregateType >> initializeCopyingFromMethod [
	(self areSyntheticMethodsInternal and: [ self hasTrivialInstanceInitializationCopyingFrom ]) ifTrue: [
		^ super initializeCopyingFromMethod
	].

	^ initializeFromCopyMethod ifNil: [ initializeFromCopyMethod := self getOrCreateOptionallyGeneratedMethod: #initializeCopyingFrom: ofKind: MbndAggregateInitializeFromCopyMethod argumentTypes: {self asCopyConstructorParameter} returnType: self compilationTarget voidType ]
]

{ #category : #'initialize-destroy' }
MbndAggregateType >> initializeMethod [
	(self areSyntheticMethodsInternal and: [ self hasTrivialInstanceInitialization ]) ifTrue: [
		^ super initializeMethod
	].
	
	^ initializeMethod ifNil: [ initializeMethod := self getOrCreateOptionallyGeneratedMethod: #initialize ofKind: MbndAggregateInitializeMethod argumentTypes: #() returnType: (self isGCClassType 		ifTrue: [self asReceiverType]
		ifFalse: [self compilationTarget voidType]) ]
]

{ #category : #'initialize-destroy' }
MbndAggregateType >> initializeMovingFromMethod [
	(self areSyntheticMethodsInternal and: [ self hasTrivialInstanceInitializationMovingFrom ]) ifTrue: [
		^ super initializeMovingFromMethod
	].
	
	^ initializeMovingFromMethod ifNil: [ initializeMovingFromMethod := self getOrCreateOptionallyGeneratedMethod: #initializeMovingFrom: ofKind: MbndAggregateInitializeMovingFromMethod argumentTypes: {self asMovementConstructorParameter} returnType: self compilationTarget voidType ]
]

{ #category : #'testing methods' }
MbndAggregateType >> isAggregateType [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAggregateType >> unmangledStructureTypePrefix [
	self subclassResponsibility
]
