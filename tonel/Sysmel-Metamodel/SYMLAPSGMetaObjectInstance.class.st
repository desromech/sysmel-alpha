Class {
	#name : #SYMLAPSGMetaObjectInstance,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'metaObject'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #converting }
SYMLAPSGMetaObjectInstance >> asNodeForSequenceElementIn: anEnvironment [
	^ metaObject convertNodeForSequenceElement: self inEnvironment: anEnvironment
]

{ #category : #converting }
SYMLAPSGMetaObjectInstance >> asNodeForTupleElementIn: anEnvironment [
	^ metaObject convertNodeForTupleElement: self inEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGMetaObjectInstance >> evaluateInEnvironment: anEnvironment [
	^ metaObject asSysmelValueInEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGMetaObjectInstance >> evaluateTypeInEnvironment: anEnvironment [
	^ metaObject evaluateMetaObjectTypeInEnvironment: anEnvironment

]

{ #category : #'meta evaluation' }
SYMLAPSGMetaObjectInstance >> generateSSACodeWith: aBuilder [
	aBuilder withDebugPosition: self position do: [
		^ metaObject generateSSAReferenceWith: aBuilder
	]
]

{ #category : #testing }
SYMLAPSGMetaObjectInstance >> isMetaObjectInstance [
	^ true
]

{ #category : #'meta evaluation' }
SYMLAPSGMetaObjectInstance >> macroExpansionInEnvironment: anEnvironment [
	^ self
]

{ #category : #accessing }
SYMLAPSGMetaObjectInstance >> metaObject [
	^ metaObject
]

{ #category : #accessing }
SYMLAPSGMetaObjectInstance >> metaObject: anObject [
	metaObject := anObject
]

{ #category : #printing }
SYMLAPSGMetaObjectInstance >> printOn: aStream [
	aStream nextPutAll: 'metaObject '; print: metaObject
]

{ #category : #'meta evaluation' }
SYMLAPSGMetaObjectInstance >> semanticAnalysisInEnvironment: environment [
	^ self
]
