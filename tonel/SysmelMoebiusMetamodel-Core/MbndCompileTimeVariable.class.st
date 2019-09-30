Class {
	#name : #MbndCompileTimeVariable,
	#superclass : #MbndAbstractVariable,
	#instVars : [
		'type',
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #visiting }
MbndCompileTimeVariable >> accept: aVisitor [
	^ aVisitor visitCompileTimeVariable: self
]

{ #category : #converting }
MbndCompileTimeVariable >> asCompileTimeValueReferenceOfType: referenceType withEvaluator: evaluator at: node [
	valueType = referenceType ifTrue: [ ^ value ].
	type = referenceType ifTrue: [ ^ MbndValue value: self type: referenceType ].
	evaluator error: 'Invalid compile time variable reference.' at: node
]

{ #category : #accessing }
MbndCompileTimeVariable >> type [
	^ type
]

{ #category : #accessing }
MbndCompileTimeVariable >> type: anObject [
	type := anObject
]

{ #category : #accessing }
MbndCompileTimeVariable >> value [
	^ value
]

{ #category : #accessing }
MbndCompileTimeVariable >> value: anObject [
	value := anObject
]
