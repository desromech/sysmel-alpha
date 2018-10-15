Class {
	#name : #SYMLFunctionLocalVariable,
	#superclass : #SYMLFunctionVariable,
	#instVars : [
		'referenceType',
		'currentValue',
		'isAnonymousGlobal'
	],
	#category : #'Sysmel-Metamodel-Variable'
}

{ #category : #definition }
SYMLFunctionLocalVariable >> assignValue: initialValue [
	<compileTime>
	<lazy>
	<rewrite>
	
	| initialValueNode initialValueType initialValueCoercionRule |
	initialValueNode := initialValue node semanticAnalysisInEnvironment: initialValue environment.
	initialValueType := initialValueNode evaluateTypeInEnvironment: initialValue environment.
	type ifNil: [
		self isRef ifTrue: [ 
			self type: initialValueType.
		] ifFalse: [
			self type: initialValueType valueType.
		]
	].

	self isReadOnly ifTrue: [ 
		initialValueCoercionRule := initialValueType node: initialValueNode coercedImplicitlyInto: type at: definitionPosition.
		
		^ SYMLAPSGLocalInitialization new
			position: definitionPosition;
			local: self;
			initialization: initialValueNode;
			coercionRule: initialValueCoercionRule;
			yourself.
	].

	^ SYMLAPSGLocalInitialization new
		position: definitionPosition;
		local: self;
		initialization: ((SYMLAPSGMessageSend new
			position: initialValueNode position;
			selector: #assignValue:;
			receiver: (self asIdentifierWithBindingAt: initialValueNode position);
			arguments: { initialValueNode };
			yourself) semanticAnalysisInEnvironment: initialValue environment);
		yourself.
		
]

{ #category : #definition }
SYMLFunctionLocalVariable >> convertNodeForSequenceElement: aNode inEnvironment: anEnvironment [
	^ SYMLAPSGLocalInitialization new
		position: definitionPosition;
		local: self;
		yourself.
		
]

{ #category : #'as yet unclassified' }
SYMLFunctionLocalVariable >> createDefinititionInActivationEnvironment: anEnvironment [
	| storage |
	storage := SYMLActivationVariableStore new
		type: type;
		value: type defaultValue;
		variable: self;
		yourself.
	anEnvironment addSymbol: name value: (storage asSysmelValueInEnvironment: anEnvironment)

]

{ #category : #accessing }
SYMLFunctionLocalVariable >> currentValue [
	^ currentValue
]

{ #category : #accessing }
SYMLFunctionLocalVariable >> currentValue: anObject [
	currentValue := anObject
]

{ #category : #'as yet unclassified' }
SYMLFunctionLocalVariable >> doCreateSSADebugInformation [
	^ (SLVMDebugVariable scope: nil name: self validName)
		type: self type ssaType;
		yourself
]

{ #category : #'as yet unclassified' }
SYMLFunctionLocalVariable >> evaluateBoundIdentifierToMe: identifier inEnvironment: anEnvironment [
	(self isAnonymousGlobal or: [anEnvironment == definitionEnvironment]) ifTrue: [
		self isReadOnly ifTrue: [
			^ currentValue sysmelValueWithType: referenceType inEnvironment: anEnvironment
		].
		^ self sysmelValueWithType: referenceType inEnvironment: anEnvironment
	].
	
	^ super evaluateBoundIdentifierToMe: identifier inEnvironment: anEnvironment
]

{ #category : #'code generation' }
SYMLFunctionLocalVariable >> generateAnonymousSSAGlobalWith: builder [

	ssaValue := SLVMGlobalVariable module: module ssaModule
		name: nil
		valueType: type ssaType
		storage: SLVMType genericStorage.
	ssaValue minimalAlignment: alignment.
	ssaValue makePrivate.
	self setSSAGlobalDebuggingInformation: ssaValue.
	
	ssaValue initialValue: (type generateSSAConstant: currentValue forModule: self module).
]

{ #category : #'as yet unclassified' }
SYMLFunctionLocalVariable >> generateSSALocalWithBuilder: builder [
	self isReadOnly ifTrue: [ ^ self ].
	ssaValue := builder allocaBuilder alloca: type ssaType name: self validName.
	builder compilationTarget emittingDebugInformation ifTrue: [ 
		ssaValue debugInformation: self createSSADebugInformation
	].

]

{ #category : #'code generation' }
SYMLFunctionLocalVariable >> generateSSAReferenceWith: builder [
	(ssaValue isNil and: [ isAnonymousGlobal ]) ifTrue: [ self generateAnonymousSSAGlobalWith: builder ].
	self assert: ssaValue isNotNil.
	
	self isAnonymousGlobal ifTrue: [ 
		(self isReadOnly and: [ referenceType ssaType ~~ ssaValue type ]) ifTrue: [
			^ builder load: ssaValue
		].
	].

	^ ssaValue
]

{ #category : #initialization }
SYMLFunctionLocalVariable >> initialize [
	super initialize.
	isAnonymousGlobal := false.
]

{ #category : #accessing }
SYMLFunctionLocalVariable >> isAnonymousGlobal [
	^ isAnonymousGlobal
]

{ #category : #accessing }
SYMLFunctionLocalVariable >> isAnonymousGlobal: anObject [
	isAnonymousGlobal := anObject
]

{ #category : #'as yet unclassified' }
SYMLFunctionLocalVariable >> referenceType [
	^ referenceType
]

{ #category : #'as yet unclassified' }
SYMLFunctionLocalVariable >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	name ifNil: [
		message selector numArgs = 0 ifTrue: [
			self name: message selector.
			definitionEnvironment addLocalVariable: self at: aPosition.
			^ message receiver
		].
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #initialization }
SYMLFunctionLocalVariable >> sysmelEvaluateReference [
	^ currentValue
]

{ #category : #initialization }
SYMLFunctionLocalVariable >> sysmelSetReferencedValue: coercedValue [
	currentValue := coercedValue value
]

{ #category : #accessing }
SYMLFunctionLocalVariable >> type: aType [
	<compileTime>
	super type: aType.
	referenceType := self isReadOnly ifTrue: [ aType ] ifFalse: [ aType refFor: #function ].
	
]
