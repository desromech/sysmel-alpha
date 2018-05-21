Class {
	#name : #SYMLShader,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'interface',
		'analyzed'
	],
	#category : #'Sysmel-Metamodel-Shader'
}

{ #category : #adding }
SYMLShader >> addShaderVariable: variable at: aPosition [
	self halt
]

{ #category : #converting }
SYMLShader >> asReceiverType [
	^ self compilationTarget voidType
]

{ #category : #definition }
SYMLShader >> definitionScopeClass [
	^ SYMLShaderScope
]

{ #category : #'code generation' }
SYMLShader >> ensureShaderInterfaceIsGenerated [
	children do: #ensureShaderInterfaceIsGenerated
]

{ #category : #'code generation' }
SYMLShader >> generateSSACode [
	self ensureShaderInterfaceIsGenerated.
	children do: #generateSSACode
]

{ #category : #initialization }
SYMLShader >> initialize [
	super initialize.
	interface := false.
	analyzed := false.
]

{ #category : #'accessing comment' }
SYMLShader >> interface [
	<compileTime>
	interface := true.
]

{ #category : #testing }
SYMLShader >> isShaderType [
	^ true
]

{ #category : #accessing }
SYMLShader >> mangledName [
	| escapedName |
	^ mangledName ifNil: [mangledName := ByteString streamContents: [ :out |
			escapedName := self validName sysmelEscapeForMangling.
			out
				nextPutAll: self parentMangledName;
				nextPutAll: '_s';
				print: escapedName size;
				nextPutAll: escapedName.
		]
	]
]

{ #category : #'semantic analysis' }
SYMLShader >> semanticAnalysis [
	analyzed ifTrue: [ ^ self ].
	analyzed := true.
	
	children do: #semanticAnalysis
]
