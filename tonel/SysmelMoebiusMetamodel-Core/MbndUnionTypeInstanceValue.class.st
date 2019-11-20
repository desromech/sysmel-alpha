Class {
	#name : #MbndUnionTypeInstanceValue,
	#superclass : #MbndAbstractValue,
	#traits : 'TMbndSymbolBinding',
	#classTraits : 'TMbndSymbolBinding classTrait',
	#instVars : [
		'type',
		'data'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #'semantic analysis' }
MbndUnionTypeInstanceValue >> analyzeReferenceNode: referenceNode with: analyzer [
	^ self asLiteralValueNode 
		position: referenceNode;
		yourself
]

{ #category : #converting }
MbndUnionTypeInstanceValue >> asLiteralValueNode [
	^ MbndAstLiteralValueNode new
		value: self;
		type: type;
		yourself
]

{ #category : #converting }
MbndUnionTypeInstanceValue >> asMoebiusLiteralValueNodeWithTarget: compilationTarget [
	^ self asLiteralValueNode
]

{ #category : #accessing }
MbndUnionTypeInstanceValue >> data [
	^ data
]

{ #category : #accessing }
MbndUnionTypeInstanceValue >> data: anObject [
	data := anObject
]

{ #category : #testing }
MbndUnionTypeInstanceValue >> isAllZeros [
	1 to: data size do: [ :i |
		(data at: i) ~~ 0 ifTrue: [ ^ false ]
	].
	^ true
]

{ #category : #accessing }
MbndUnionTypeInstanceValue >> type [
	^ type
]

{ #category : #accessing }
MbndUnionTypeInstanceValue >> type: anObject [
	type := anObject
]

{ #category : #evaluating }
MbndUnionTypeInstanceValue >> value [
	^ self
]
