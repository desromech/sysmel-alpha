Class {
	#name : #MbndNativeBlockClosureType,
	#superclass : #MbndAbstractBlockClosureType,
	#instVars : [
		'functionTypeWithGenericClosurePointer'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndNativeBlockClosureType class >> typeName [
	^ #_NativeClosureType
]

{ #category : #visiting }
MbndNativeBlockClosureType >> accept: aVisitor [
	^ aVisitor visitNativeBlockClosureType: self
]

{ #category : #testing }
MbndNativeBlockClosureType >> canHaveDynamicMethodWrapper [
	^ false
]

{ #category : #accessing }
MbndNativeBlockClosureType >> functionTypeWithGenericClosurePointer [
	^ functionTypeWithGenericClosurePointer ifNil: [
		functionTypeWithGenericClosurePointer := functionType prependArguments: {self compilationTarget voidType pointer}
	]
]

{ #category : #testing }
MbndNativeBlockClosureType >> isNativeBlockClosureType [
	^ true
]

{ #category : #printing }
MbndNativeBlockClosureType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].

	aStream nextPut: $(.
	functionType printOn: aStream.
	aStream nextPutAll: ') nativeBlockClosure'.
]
