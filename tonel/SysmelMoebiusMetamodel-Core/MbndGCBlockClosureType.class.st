Class {
	#name : #MbndGCBlockClosureType,
	#superclass : #MbndAbstractBlockClosureType,
	#instVars : [
		'functionTypeWithGenericClosurePointer'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndGCBlockClosureType class >> typeName [
	^ #_GCBlockClosureType
]

{ #category : #visiting }
MbndGCBlockClosureType >> accept: aVisitor [
	^ aVisitor visitGCBlockClosureType: self
]

{ #category : #accessing }
MbndGCBlockClosureType >> functionTypeWithGenericClosurePointer [
	^ functionTypeWithGenericClosurePointer ifNil: [
		functionTypeWithGenericClosurePointer := functionType prependArguments: {self compilationTarget dynamicObjectType}
	]
]

{ #category : #testing }
MbndGCBlockClosureType >> isGCBlockClosureType [
	^ true
]

{ #category : #'testing methods' }
MbndGCBlockClosureType >> isGarbageCollectedType [
	^ true
]

{ #category : #printing }
MbndGCBlockClosureType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].

	aStream nextPut: $(.
	functionType printOn: aStream.
	aStream nextPutAll: ') gcBlockClosure'.
]
