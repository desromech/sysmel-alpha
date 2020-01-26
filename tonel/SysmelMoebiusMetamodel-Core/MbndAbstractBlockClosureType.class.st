Class {
	#name : #MbndAbstractBlockClosureType,
	#superclass : #MbndFunctionalType,
	#instVars : [
		'functionType',
		'functionTypeWithClosureParameter'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndAbstractBlockClosureType class >> typeName [
	^ #_AbstractBlockClosureType
]

{ #category : #'as yet unclassified' }
MbndAbstractBlockClosureType >> analyzeFunctionCallNode: node with: analyzer [
	^ functionType analyzeFunctionCallNode: node with: analyzer
]

{ #category : #accessing }
MbndAbstractBlockClosureType >> argumentTypes [
	<compileTime>
	^ functionType argumentTypes
]

{ #category : #accessing }
MbndAbstractBlockClosureType >> functionType [
	<compileTime>
	^ functionType
]

{ #category : #accessing }
MbndAbstractBlockClosureType >> functionType: anObject [
	functionType := anObject
]

{ #category : #accessing }
MbndAbstractBlockClosureType >> functionTypeWithClosureParameter [
	^ functionTypeWithClosureParameter ifNil: [ functionTypeWithClosureParameter := functionType prependArguments: { self } ]
]

{ #category : #'testing methods' }
MbndAbstractBlockClosureType >> isBlockClosureType [
	^ true
]

{ #category : #accessing }
MbndAbstractBlockClosureType >> returnType [
	<compileTime>
	^ functionType returnType
]