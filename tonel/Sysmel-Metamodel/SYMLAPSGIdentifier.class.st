Class {
	#name : #SYMLAPSGIdentifier,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'value'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #printing }
SYMLAPSGIdentifier >> printOn: aStream [
	aStream nextPutAll: 'identifier '; print: value
]

{ #category : #accessing }
SYMLAPSGIdentifier >> semanticAnalysisInEnvironment: anEnvironment [
	| binding |
	binding := anEnvironment lookSymbolRecursively: value ifAbsent: [
		self error: 'Failed to find identifier {1}.' format: { value } at: position
	].

	binding isMetaBuilder ifTrue: [ 
		^ SYMLAPSGMetaObjectInstance new
			position: self;
			metaObject: (binding newInstanceInEnvironment: anEnvironment);
			yourself
	].

	binding isMetaObject ifTrue: [ 
		^ SYMLAPSGMetaObjectInstance new
			position: self;
			metaObject: binding;
			yourself
	].
	
	^ SYMLAPSGIdentifierWithBinding new
		position: self;
		value: value;
		binding: binding;
		yourself
]

{ #category : #accessing }
SYMLAPSGIdentifier >> value [
	^ value
]

{ #category : #accessing }
SYMLAPSGIdentifier >> value: anObject [
	value := anObject
]
