Class {
	#name : #SYMLSLVMObjectModel,
	#superclass : #SLVMObjectModel,
	#instVars : [
		'arrayClass',
		'byteArrayClass',
		'dictionaryClass',
		'methodDictionaryClass',
		'stringClass',
		'symbolClass',
		'sysmelSuperMessageLookupFunction',
		'sysmelMessageLookupFunction'
	],
	#category : #'Sysmel-Metamodel-CompilationTarget'
}

{ #category : #accessing }
SYMLSLVMObjectModel >> arrayClass [
	<compileTime>
	^ arrayClass
]

{ #category : #accessing }
SYMLSLVMObjectModel >> arrayClass: anObject [
	<compileTime>
	arrayClass := anObject
]

{ #category : #accessing }
SYMLSLVMObjectModel >> byteArrayClass [
	<compileTime>
	^ byteArrayClass
]

{ #category : #accessing }
SYMLSLVMObjectModel >> byteArrayClass: anObject [
	<compileTime>
	byteArrayClass := anObject
]

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

{ #category : #'object literals' }
SYMLSLVMObjectModel >> createNonInlineLiteralConstant: aLiteral withCodeGenerator: aCodeGenerator [
	^ aLiteral createNonInlineLiteralConstantForSysmelObjectModel: self withCodeGenerator: aCodeGenerator

]

{ #category : #'object literals' }
SYMLSLVMObjectModel >> createObjectBytes: bytes class: class [
	| object |
	object := class makeInstance: bytes size.
	object slots at: object slots size put: bytes.
	^ object createSSAInitialValueConstant
]

{ #category : #accessing }
SYMLSLVMObjectModel >> dictionaryClass [
	<compileTime>
	^ dictionaryClass
]

{ #category : #accessing }
SYMLSLVMObjectModel >> dictionaryClass: anObject [
	<compileTime>
	dictionaryClass := anObject
]

{ #category : #accessing }
SYMLSLVMObjectModel >> messageLookupFunction [
	<compileTime>
	^ sysmelMessageLookupFunction ssaValue
]

{ #category : #accessing }
SYMLSLVMObjectModel >> methodDictionaryClass [
	<compileTime>
	^ methodDictionaryClass
]

{ #category : #accessing }
SYMLSLVMObjectModel >> methodDictionaryClass: anObject [
	<compileTime>
	methodDictionaryClass := anObject
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
