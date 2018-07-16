Class {
	#name : #SYMLSLVMObjectModel,
	#superclass : #SLVMObjectModel,
	#instVars : [
		'stringClass',
		'symbolClass',
		'sysmelSuperMessageLookupFunction',
		'sysmelMessageLookupFunction'
	],
	#category : #'Sysmel-Metamodel-CompilationTarget'
}

{ #category : #'code generation' }
SYMLSLVMObjectModel >> createDoesNotUnderstandTrampolineWithType: functionType [
	| function builder entryBlock boxedMessage result convertedResult |
	function := SLVMFunction pointerSize: target pointerSize functionType: functionType.
	function compilationTarget: target.
	function propertyAt: #omitDebugInformation put: true.
	
	builder := SLVMBuilder on: function.
	
	entryBlock := builder newBasicBlockHere: #entry.
	
	boxedMessage := builder addDynamicLiteral: nil.
	
	result := builder send: (builder addDynamicLiteral: #doesNotUnderstand:)
		returnType: target dynamicObjectType 
		receiver: function arguments first
		arguments: { boxedMessage }.
	
	functionType returnType isDynamicObjectType ifTrue: [ 
		convertedResult := result type == functionType returnType
			ifTrue: [ result ]
			ifFalse: [ builder bitCast: result target: functionType returnType ].
		builder return: convertedResult.
	] ifFalse: [ 
		function returnType isVoidType ifTrue: [
			builder returnVoid
		] ifFalse: [ 
			self flag: 'TODO: Unbox the result.'.
			builder return: function returnType defaultValue
		].
	].

	^ function
]

{ #category : #'as yet unclassified' }
SYMLSLVMObjectModel >> createNonInlineLiteralConstant: aLiteral withCodeGenerator: aCodeGenerator [
	aLiteral isSymbol ifTrue: [
		^ self createObjectBytes: aLiteral asUTF8Bytes class: symbolClass
	].
	aLiteral isString ifTrue: [
		^ self createObjectBytes: aLiteral asUTF8Bytes class: stringClass
	].
	
	self error: 'Literal not yet supported.'.
]

{ #category : #'as yet unclassified' }
SYMLSLVMObjectModel >> createObjectBytes: bytes class: class [
	| object |
	object := class makeInstance: bytes size.
	object slots at: object slots size put: bytes.
	^ object createSSAInitialValueConstant
]

{ #category : #accessing }
SYMLSLVMObjectModel >> messageLookupFunction [
	<compileTime>
	^ sysmelMessageLookupFunction ssaValue
]

{ #category : #accessing }
SYMLSLVMObjectModel >> stringClass [
	<compileTime>
	^ stringClass
]

{ #category : #accessing }
SYMLSLVMObjectModel >> stringClass: anObject [
	<compileTime>
	stringClass := anObject
]

{ #category : #accessing }
SYMLSLVMObjectModel >> superMessageLookupFunction [
	<compileTime>
	^ sysmelSuperMessageLookupFunction ssaValue
]

{ #category : #accessing }
SYMLSLVMObjectModel >> symbolClass [
	<compileTime>
	^ symbolClass
]

{ #category : #accessing }
SYMLSLVMObjectModel >> symbolClass: anObject [
	<compileTime>
	symbolClass := anObject
]

{ #category : #accessing }
SYMLSLVMObjectModel >> sysmelMessageLookupFunction [
	<compileTime>
	^ sysmelMessageLookupFunction 
]

{ #category : #accessing }
SYMLSLVMObjectModel >> sysmelMessageLookupFunction: anObject [
	<compileTime>
	sysmelMessageLookupFunction := anObject
]

{ #category : #accessing }
SYMLSLVMObjectModel >> sysmelSuperMessageLookupFunction [
	<compileTime>
	^ sysmelSuperMessageLookupFunction
]

{ #category : #accessing }
SYMLSLVMObjectModel >> sysmelSuperMessageLookupFunction: anObject [
	<compileTime>
	sysmelSuperMessageLookupFunction := anObject
]
