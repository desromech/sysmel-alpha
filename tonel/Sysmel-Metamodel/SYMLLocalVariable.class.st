Class {
	#name : #SYMLLocalVariable,
	#superclass : #SYMLAbstractVariable,
	#instVars : [
		'refererenceType',
		'ssaValue'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #definition }
SYMLLocalVariable >> assignValue: initialValue [
	<compileTime>
	<lazy>
	<rewrite>
	
	| initialValueNode initialValueType |
	initialValueNode := initialValue node semanticAnalysisInEnvironment: initialValue environment.
	initialValueType := initialValueNode evaluateTypeInEnvironment: initialValue environment.
	type ifNil: [
		self type: initialValueType cleanValueType.
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
SYMLLocalVariable >> convertNodeForSequenceElement: aNode inEnvironment: anEnvironment [
	^ SYMLAPSGLocalInitialization new
		position: definitionPosition;
		local: self;
		yourself.
		
]

{ #category : #'as yet unclassified' }
SYMLLocalVariable >> doCreateSSADebugInformation [
	^ (SLVMDebugVariable scope: nil name: self validName)
		type: self type ssaType;
		yourself
]

{ #category : #'as yet unclassified' }
SYMLLocalVariable >> generateSSALocalWithBuilder: builder [
	ssaValue := builder allocaBuilder alloca: type ssaType name: self validName.
	builder compilationTarget emittingDebugInformation ifTrue: [ 
		ssaValue debugInformation: self createSSADebugInformation
	].

]

{ #category : #'code generation' }
SYMLLocalVariable >> generateSSAReferenceWith: builder [
	self assert: ssaValue isNotNil.
	^ ssaValue
]

{ #category : #'as yet unclassified' }
SYMLLocalVariable >> referenceType [
	^ refererenceType
]

{ #category : #'as yet unclassified' }
SYMLLocalVariable >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	name ifNil: [
		message selector numArgs = 0 ifTrue: [
			self name: message selector.
			definitionEnvironment addLocalVariable: self at: aPosition.
			^ message receiver
		].
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #accessing }
SYMLLocalVariable >> ssaValue [
	^ ssaValue
]

{ #category : #accessing }
SYMLLocalVariable >> ssaValue: anObject [
	ssaValue := anObject
]

{ #category : #accessing }
SYMLLocalVariable >> type: aType [
	<compileTime>
	super type: aType.
	refererenceType := aType ref
]
