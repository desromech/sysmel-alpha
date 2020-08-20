Class {
	#name : #MbndAggregateType,
	#superclass : #MbndNativeType,
	#instVars : [
		'basicInitializeMethod',
		'initializeMethod',
		'finalizeMethod',
		'initializeFromCopyMethod',
		'initializeMovingFromMethod',
		'copyAssignmentMethod',
		'moveAssignmentMethod'
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

{ #category : #testing }
MbndAggregateType >> canHaveDynamicMethodWrapper [
	^ self isGarbageCollectedType
]

{ #category : #'initialize-destroy' }
MbndAggregateType >> copyAssignmentMethod [
	(self areSyntheticMethodsInternal and: [ self hasTrivialInstanceCopyAssignment ]) ifTrue: [
		^ super copyAssignmentMethod
	].

	^ copyAssignmentMethod ifNil: [ copyAssignmentMethod := self getOrCreateOptionallyGeneratedMethod: #assignValue: ofKind: MbndAggregateCopyAssignmentMethod argumentTypes: {self asCopyConstructorParameter} returnType: self asAssignmentResultType ]
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

{ #category : #serialization }
MbndAggregateType >> encodeLazyFieldsForMessagePackWith: graphEncoder [
	^ (super encodeLazyFieldsForMessagePackWith: graphEncoder) , {
		#basicInitializeMethod. basicInitializeMethod encodeGraphForMessagePackWith: graphEncoder.
		#initializeMethod. initializeMethod encodeGraphForMessagePackWith: graphEncoder.
		#finalizeMethod. finalizeMethod encodeGraphForMessagePackWith: graphEncoder.
		#initializeFromCopyMethod. initializeFromCopyMethod encodeGraphForMessagePackWith: graphEncoder.
		#initializeMovingFromMethod. initializeMovingFromMethod encodeGraphForMessagePackWith: graphEncoder.
	}
]

{ #category : #'semantic analysis' }
MbndAggregateType >> ensureGeneratedMethodsExist [
	self hasTrivialInstanceBasicInitialization ifFalse: [ self basicInitializeMethod ].
	self hasTrivialInstanceInitialization ifFalse: [ self initializeMethod ].
	self hasTrivialInstanceInitializationCopyingFrom ifFalse: [ self initializeCopyingFromMethod ].
	self hasTrivialInstanceInitializationMovingFrom ifFalse: [ self initializeMovingFromMethod ].
	self hasTrivialInstanceFinalization ifFalse: [ self finalizeMethod ].
	self hasTrivialCopyAssignment ifFalse: [ self copyAssignmentMethod ].
	self hasTrivialMoveAssignment ifFalse: [ self moveAssignmentMethod ].

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
		(existent findOverloadWithExactArgumentTypes: argumentTypes) ifNotNil: [ :matchingOverload |
			^ matchingOverload
		].
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

{ #category : #serialization }
MbndAggregateType >> materializeWithGraphDecoder: graphDecoder withLazyFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withLazyFields: encodedFields.

	basicInitializeMethod := encodedFields at: #basicInitializeMethod.
	initializeMethod := encodedFields at: #initializeMethod.
	finalizeMethod := encodedFields at: #finalizeMethod.
	initializeFromCopyMethod := encodedFields at: #initializeFromCopyMethod.
	initializeMovingFromMethod := encodedFields at: #initializeMovingFromMethod.
]

{ #category : #'initialize-destroy' }
MbndAggregateType >> moveAssignmentMethod [
	(self areSyntheticMethodsInternal and: [ self hasTrivialInstanceCopyAssignment ]) ifTrue: [
		^ super moveAssignmentMethod
	].

	^ moveAssignmentMethod ifNil: [ moveAssignmentMethod := self getOrCreateOptionallyGeneratedMethod: #assignValue: ofKind: MbndAggregateMoveAssignmentMethod argumentTypes: {self tempRef} returnType: self asAssignmentResultType ]
]

{ #category : #'as yet unclassified' }
MbndAggregateType >> unmangledStructureTypePrefix [
	self subclassResponsibility
]
