Class {
	#name : #MbndFunctionType,
	#superclass : #MbndFunctionalType,
	#instVars : [
		'argumentTypes',
		'returnType',
		'callingConvention'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndFunctionType class >> typeName [
	^ #_FunctionType
]

{ #category : #accessing }
MbndFunctionType >> argumentTypes [
	^ argumentTypes
]

{ #category : #accessing }
MbndFunctionType >> argumentTypes: anObject [
	argumentTypes := anObject
]

{ #category : #accessing }
MbndFunctionType >> callingConvention [
	^ callingConvention
]

{ #category : #accessing }
MbndFunctionType >> callingConvention: anObject [
	callingConvention := anObject
]

{ #category : #testing }
MbndFunctionType >> isFunctionType [
	^ true
]

{ #category : #accessing }
MbndFunctionType >> returnType [
	^ returnType
]

{ #category : #accessing }
MbndFunctionType >> returnType: anObject [
	returnType := anObject
]
