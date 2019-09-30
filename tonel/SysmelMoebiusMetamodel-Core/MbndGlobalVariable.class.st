Class {
	#name : #MbndGlobalVariable,
	#superclass : #MbndAbstractVariable,
	#instVars : [
		'currentValue',
		'type'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #visiting }
MbndGlobalVariable >> accept: aVisitor [
	^ aVisitor visitGlobalVariable: self
]

{ #category : #'compile time evaluation' }
MbndGlobalVariable >> asCompileTimeValueReferenceOfType: referenceType withEvaluator: evaluator at: node [
	valueType = referenceType ifTrue: [ ^ currentValue ].
	type = referenceType ifTrue: [ ^ MbndValue value: self type: referenceType ].
	evaluator error: 'Invalid compile time variable reference.' at: node
]

{ #category : #accessing }
MbndGlobalVariable >> currentValue [
	^ currentValue
]

{ #category : #accessing }
MbndGlobalVariable >> currentValue: anObject [
	currentValue := anObject
]

{ #category : #testing }
MbndGlobalVariable >> isExternal [
	^ self hasFlag: #external
]

{ #category : #testing }
MbndGlobalVariable >> isStatic [
	^ self hasFlag: #static
]

{ #category : #accessing }
MbndGlobalVariable >> type [
	^ type
]

{ #category : #accessing }
MbndGlobalVariable >> type: anObject [
	type := anObject
]
