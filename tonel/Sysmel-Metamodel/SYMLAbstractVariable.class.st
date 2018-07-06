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

{ #category : #testing }
SYMLAbstractVariable >> isReadOnly [
	^ self hasFlag: #readOnly
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
SYMLAbstractVariable >> name: aNewName [
	<compileTime>
	name := aNewName.

]

{ #category : #accessing }
SYMLAbstractVariable >> readOnly [
	<compileTime>
	self addFlag: #readOnly
]

{ #category : #'as yet unclassified' }
SYMLAbstractVariable >> referenceType [
	^ self type
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
