Class {
	#name : #SYMLBlockClosure,
	#superclass : #SYMLProgramEntityWithLocation,
	#instVars : [
		'arguments',
		'returnType',
		'type',
		'body',
		'returnTypeCoercionRule'
	],
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #accessing }
SYMLBlockClosure >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLBlockClosure >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
SYMLBlockClosure >> body [
	^ body
]

{ #category : #accessing }
SYMLBlockClosure >> body: anObject [
	body := anObject
]

{ #category : #'code generation' }
SYMLBlockClosure >> generateSSAInlineCall: argumentValues with: builder [
	| argumentDefinition resultValue |
	self assert: argumentValues size = arguments size.
	argumentValues doWithIndex: [ :argValue :index |
		argumentDefinition := arguments at: index.
		self assert: argumentDefinition ssaValue isNil.
		argumentDefinition ssaValue: argValue
	].

	resultValue := body generateSSACodeWith: builder.
	builder isLastTerminator ifTrue: [ ^ nil ].
	
	^ returnType isVoidType ifTrue: [
		nil
	] ifFalse: [ 
		returnTypeCoercionRule convertSSAValue: resultValue to: returnType with: builder at: body
	]
]

{ #category : #testing }
SYMLBlockClosure >> isInlined [
	^ self hasFlag: #inlined
]

{ #category : #testing }
SYMLBlockClosure >> isInlined: aBoolean [
	^ self setFlag: #inlined value: aBoolean
]

{ #category : #accessing }
SYMLBlockClosure >> returnType [
	^ returnType
]

{ #category : #accessing }
SYMLBlockClosure >> returnType: anObject [
	returnType := anObject
]

{ #category : #accessing }
SYMLBlockClosure >> returnTypeCoercionRule [
	^ returnTypeCoercionRule
]

{ #category : #accessing }
SYMLBlockClosure >> returnTypeCoercionRule: anObject [
	returnTypeCoercionRule := anObject
]

{ #category : #accessing }
SYMLBlockClosure >> type [
	^ type ifNil: [ type := self compilationTarget closureArguments: (arguments collect: #type) returnType: returnType ]
]
