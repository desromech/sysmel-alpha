Class {
	#name : #SYMLAbstractVariable,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'type',
		'ssaDebugInformation'
	],
	#category : #'Sysmel-Metamodel-Program'
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

{ #category : #accessing }
SYMLAbstractVariable >> type [
	<compileTime>
	^ type
]

{ #category : #accessing }
SYMLAbstractVariable >> type: anObject [
	<compileTime>
	type := anObject
]
