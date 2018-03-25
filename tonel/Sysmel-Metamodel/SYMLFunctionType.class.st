Class {
	#name : #SYMLFunctionType,
	#superclass : #SYMLType,
	#instVars : [
		'arguments',
		'returnType',
		'callingConvention',
		'variadic'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #comparing }
SYMLFunctionType >> = other [
	^ self class == other class and:
	[ arguments = other arguments and:
	[ returnType = other returnType and:
	[ variadic = other variadic and:
	[ callingConvention == other callingConvention ]]]]
]

{ #category : #accessing }
SYMLFunctionType >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLFunctionType >> arguments: anObject [
	arguments := anObject
]

{ #category : #'as yet unclassified' }
SYMLFunctionType >> buildSSAType [
	| argumentTypes returnSSAType |
	argumentTypes := arguments collect: #ssaType.
	returnSSAType := returnType ssaType.
	^ (SLVMFunctionType callingConvention: callingConvention arguments: argumentTypes returnType: returnSSAType)
		variadic: variadic;
		yourself
]

{ #category : #accessing }
SYMLFunctionType >> callingConvention [
	^ callingConvention
]

{ #category : #accessing }
SYMLFunctionType >> callingConvention: anObject [
	callingConvention := anObject
]

{ #category : #comparing }
SYMLFunctionType >> hash [
	^ self class identityHash bitXor:
	( arguments hash bitXor:
	( returnType hash bitXor:
	( variadic hash bitXor:
	( callingConvention identityHash))))
]

{ #category : #initialization }
SYMLFunctionType >> initialize [
	super initialize.
	variadic := false.
	callingConvention := #cdecl.
]

{ #category : #testing }
SYMLFunctionType >> isFunctionType [
	^ true
]

{ #category : #printing }
SYMLFunctionType >> printOn: aStream [
	aStream nextPut: $(.
	arguments doWithIndex: [ :arg :index |
		index > 1 ifTrue: [ aStream nextPutAll: ', ' ].
		aStream print: arg. 
	].

	aStream nextPutAll: ') -> '.
	aStream print: returnType.
]

{ #category : #accessing }
SYMLFunctionType >> returnType [
	^ returnType
]

{ #category : #accessing }
SYMLFunctionType >> returnType: anObject [
	returnType := anObject
]

{ #category : #accessing }
SYMLFunctionType >> variadic [
	^ variadic
]

{ #category : #accessing }
SYMLFunctionType >> variadic: anObject [
	variadic := anObject
]
