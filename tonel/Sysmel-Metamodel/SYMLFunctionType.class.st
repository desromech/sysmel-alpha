Class {
	#name : #SYMLFunctionType,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'compilationTarget',
		'arguments',
		'returnType',
		'callingConvention',
		'variadic'
	],
	#category : #'Sysmel-Metamodel-Program'
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
	<compileTime>
	^ arguments
]

{ #category : #accessing }
SYMLFunctionType >> arguments: anObject [
	<compileTime>
	arguments := anObject
]

{ #category : #'code generation' }
SYMLFunctionType >> buildSSAType [
	| argumentSSAType returnSSAType |
	argumentSSAType := arguments collect: #ssaType.
	returnSSAType := returnType ssaType.
	^ (SLVMFunctionType callingConvention: callingConvention arguments: argumentSSAType returnType: returnSSAType)
		variadic: variadic;
		yourself
]

{ #category : #accessing }
SYMLFunctionType >> callingConvention [
	<compileTime>
	^ callingConvention
]

{ #category : #accessing }
SYMLFunctionType >> callingConvention: anObject [
	<compileTime>
	callingConvention := anObject
]

{ #category : #accessing }
SYMLFunctionType >> compilationTarget [
	<compileTime>
	^ compilationTarget
]

{ #category : #accessing }
SYMLFunctionType >> compilationTarget: anObject [
	<compileTime>
	compilationTarget := anObject.
	definitionEnvironment := compilationTarget fakeEnvironment
]

{ #category : #comparing }
SYMLFunctionType >> hash [
	^ self class identityHash bitXor:
	( arguments hash bitXor:
	( returnType hash bitXor:
	( variadic hash bitXor:
	( callingConvention identityHash))))
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
	<compileTime>
	^ returnType
]

{ #category : #accessing }
SYMLFunctionType >> returnType: anObject [
	<compileTime>
	returnType := anObject
]

{ #category : #accessing }
SYMLFunctionType >> variadic [
	<compileTime>
	^ variadic
]

{ #category : #accessing }
SYMLFunctionType >> variadic: anObject [
	<compileTime>
	variadic := anObject
]
