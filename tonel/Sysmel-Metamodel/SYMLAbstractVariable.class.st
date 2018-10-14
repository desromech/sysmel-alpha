Class {
	#name : #SYMLAbstractVariable,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'type',
		'ssaDebugInformation',
		'mangledName'
	],
	#category : #'Sysmel-Metamodel-Variable'
}

{ #category : #'as yet unclassified' }
SYMLAbstractVariable >> analyzeAPSGIdentifierToMe: identifier inEnvironment: anEnvironment [
	^ identifier copyWithBinding: self andType: self referenceType
]

{ #category : #converting }
SYMLAbstractVariable >> asIdentifierWithBindingAt: aPosition [
	^ SYMLAPSGIdentifierWithBinding new
		position: aPosition;
		value: self validName asSymbol;
		binding: self;
		type: self referenceType;
		yourself
]

{ #category : #converting }
SYMLAbstractVariable >> asIncompleteValue [
	^ SYMLIncompleteValue new
		type: type;
		binding: self;
		yourself
]

{ #category : #'as yet unclassified' }
SYMLAbstractVariable >> concretizeIncompleteValue: value inEnvironment: concreteEnvironment [
	^ concreteEnvironment lookSymbolRecursively: name ifAbsent: [ self error ]
]

{ #category : #accessing }
SYMLAbstractVariable >> const [
	<compileTime>
	self addFlag: #const
]

{ #category : #converting }
SYMLAbstractVariable >> convertNodeForSequenceElement: aNode inEnvironment: anEnvironment [
	^ self asIdentifierWithBindingAt: aNode position
]

{ #category : #'as yet unclassified' }
SYMLAbstractVariable >> createSSADebugInformation [
	^ ssaDebugInformation ifNil: [ssaDebugInformation := self doCreateSSADebugInformation
	]
]

{ #category : #'as yet unclassified' }
SYMLAbstractVariable >> doCreateSSADebugInformation [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SYMLAbstractVariable >> evaluateBindingInEnvironment: environment [
	self subclassResponsibility
]

{ #category : #testing }
SYMLAbstractVariable >> isConst [
	^ self hasFlag: #const
]

{ #category : #testing }
SYMLAbstractVariable >> isReadOnly [
	^ (self hasFlag: #mutable) not
]

{ #category : #testing }
SYMLAbstractVariable >> isRef [
	^ self hasFlag: #ref
]

{ #category : #accessing }
SYMLAbstractVariable >> mangledName [
	| escapedName |
	^ mangledName ifNil: [mangledName := ByteString streamContents: [ :out |
			escapedName := self validName sysmelEscapeForMangling.
			out
				nextPutAll: self parentMangledName;
				nextPut: $v;
				print: escapedName size;
				nextPutAll: escapedName.
		]
	]
]

{ #category : #accessing }
SYMLAbstractVariable >> mutable [
	<compileTime>
	self addFlag: #mutable
]

{ #category : #accessing }
SYMLAbstractVariable >> name: aNewName [
	<compileTime>
	name := aNewName.

]

{ #category : #accessing }
SYMLAbstractVariable >> ref [
	<compileTime>
	self addFlag: #ref
]

{ #category : #'as yet unclassified' }
SYMLAbstractVariable >> referenceType [
	^ self type
]

{ #category : #'as yet unclassified' }
SYMLAbstractVariable >> setSSAGlobalDebuggingInformation: ssaGlobalVariable [
	self module isEmittingDebugInformation ifTrue: [
		definitionPosition ifNotNil: [
			ssaGlobalVariable debugSourceLocation: (self module convertDebugPosition: definitionPosition).
		].
	
		ssaGlobalVariable debugInformation: self createSSADebugInformation.
	].
]

{ #category : #initialization }
SYMLAbstractVariable >> sysmelEvaluateReference [
	self subclassResponsibility
]

{ #category : #initialization }
SYMLAbstractVariable >> sysmelSetReferencedValue: coercedValue [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLAbstractVariable >> type [
	<compileTime>
	^ type
]

{ #category : #accessing }
SYMLAbstractVariable >> type: aType [
	<compileTime>
	type := aType asVariableValueType
]
