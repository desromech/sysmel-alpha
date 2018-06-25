Class {
	#name : #SYMLNamespace,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'symbols',
		'metaMethodDictionary',
		'mangledName'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #definition }
SYMLNamespace >> assignValue: aDefinitionBlock [
	<compileTime>
	<lazy>
	^ self definition: aDefinitionBlock
]

{ #category : #accessing }
SYMLNamespace >> definition: aDefinitionBlock [
	<compileTime>
	<lazy>
	
	| namespaceScope lexicalScope |
	namespaceScope := SYMLNamespaceScope parent: aDefinitionBlock environment.
	namespaceScope programEntity: self.
	
	lexicalScope := SYMLLexicalScope parent: namespaceScope.
	aDefinitionBlock value analyzeAndEvaluateInEnvironment: lexicalScope.

]

{ #category : #'as yet unclassified' }
SYMLNamespace >> generateSSACode [
	symbols valuesDo: #generateSSACode
]

{ #category : #initialization }
SYMLNamespace >> initialize [
	super initialize.
	symbols := SYMLOrderedDictionary new.
	metaMethodDictionary := SYMLOrderedDictionary new.
]

{ #category : #testing }
SYMLNamespace >> isNamespace [
	^ true
]

{ #category : #accessing }
SYMLNamespace >> lookMetaMethodSelector: selector [
	^ metaMethodDictionary at: selector ifAbsent: [nil]
]

{ #category : #'as yet unclassified' }
SYMLNamespace >> lookSymbol: symbol ifPresent: ifPresentBlock [
	symbols at: symbol ifPresent: ifPresentBlock
]

{ #category : #accessing }
SYMLNamespace >> mangledName [
	| validName |
	^ mangledName ifNil: [ mangledName := ByteString streamContents: [ :out |
			out nextPutAll: self parentMangledName.
			
			(parent isNil and: [ name = #__global ]) ifFalse: [
				validName := self validName.
				out
					nextPut: $N;
					nextPutAll: validName size asString;
					nextPutAll: validName
			].
		]
	]
	
]

{ #category : #accessing }
SYMLNamespace >> metaMethodDictionary [
	^ metaMethodDictionary
]

{ #category : #adding }
SYMLNamespace >> methodWithSelector: selector ifPresent: presentBlock ifAbsentPut: absentBlock [
	metaMethodDictionary at: selector ifPresent: presentBlock ifAbsentPut: absentBlock
]

{ #category : #'as yet unclassified' }
SYMLNamespace >> semanticAnalysis [
	symbols valuesDo: #semanticAnalysis
]

{ #category : #'as yet unclassified' }
SYMLNamespace >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	| identifier |
	name ifNil: [
		message selector numArgs = 0 ifTrue: [
			^ self setName: message selector ifNewReturnNode: message receiver
		].
	].

	symbols at: message selector ifPresent: [ :value |
		identifier := SYMLAPSGIdentifier new
			position: message;
			value: message selector;
			yourself.
		^ value analyzeAPSGIdentifierToMe: identifier inEnvironment: environment
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #adding }
SYMLNamespace >> symbol: aSymbol ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock [
	^ symbols at: aSymbol ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock

]
