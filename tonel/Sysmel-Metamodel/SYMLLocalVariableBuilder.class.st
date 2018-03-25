Class {
	#name : #SYMLLocalVariableBuilder,
	#superclass : #SYMLProgramEntityBuilder,
	#instVars : [
		'name',
		'initialValue',
		'type',
		'binding'
	],
	#category : #Sysmel-Metamodel-MetaBuilders
}

{ #category : #'meta methods' }
SYMLLocalVariableBuilder >> assignValue: theInitialValue [
	<compileTime>
	<lazy>
	<rewrite>
	| environment |
	self assert: theInitialValue type isAPSGNode.
	
	environment := theInitialValue environment.
	initialValue := theInitialValue value semanticAnalysisInEnvironment: theInitialValue environment.
	type ifNil: [
		type := (initialValue evaluateTypeInEnvironment: environment) valueType cleanType concreteTypeForNode: initialValue.
	].

	^ self createInitialValueNodeAt: initialValue position inEnvironment: theInitialValue environment
	
]

{ #category : #converting }
SYMLLocalVariableBuilder >> binding [
	binding ifNil: [ self createBinding ].
	^ binding
]

{ #category : #converting }
SYMLLocalVariableBuilder >> convertNodeForSequenceElement: node inEnvironment: anEnvironment [
	^ self createInitialValueNodeAt: node inEnvironment: anEnvironment
]

{ #category : #converting }
SYMLLocalVariableBuilder >> convertNodeForTupleElement: node inEnvironment: anEnvironment [
	^ self createInitialValueNodeAt: node inEnvironment: anEnvironment
]

{ #category : #converting }
SYMLLocalVariableBuilder >> createBinding [
	| parentEntity |
	type ifNil: [
		self error: 'A type or initial value is required for local variable {1}.' format: { name } at: sourcePosition
	].

	parentEntity := definitionEnvironment programEntity.
	binding := definitionEnvironment lookSymbol: name ifPresent: [ :existent |
		self error: 'Overriding existent local symbol {1}.' format: { name } at: sourcePosition
	] ifAbsentPut: [
		parentEntity createLocalVariableBinding: self
	].

	^ binding
]

{ #category : #converting }
SYMLLocalVariableBuilder >> createInitialValueNodeAt: aPosition inEnvironment: anEnvironment [
	| variableReferenceNode |
	variableReferenceNode := SYMLAPSGIdentifierWithBinding new
			position: aPosition;
			value: name;
			binding: self binding;
			yourself.

	initialValue ifNil: [ ^ variableReferenceNode ].

^ (SYMLAPSGMessageSend new	
		position: aPosition;
		receiver: variableReferenceNode;
		selector: #assignValue:;
		arguments: { initialValue };
		yourself) semanticAnalysisInEnvironment: anEnvironment
]

{ #category : #accessing }
SYMLLocalVariableBuilder >> initialValue [
	^ initialValue
]

{ #category : #accessing }
SYMLLocalVariableBuilder >> name [
	^ name
]

{ #category : #accessing }
SYMLLocalVariableBuilder >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SYMLLocalVariableBuilder >> type [
	^ type
]

{ #category : #accessing }
SYMLLocalVariableBuilder >> type: aType [
	<compileTime>
	aType type isMetaType ifFalse: [ 
		self error: 'Expected a type for the local variable "{1}".' format: { name }
	].

	type := aType value
]
