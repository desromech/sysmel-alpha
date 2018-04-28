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

{ #category : #adding }
SYMLNamespace >> addMethod: value withSelector: selector [
	metaMethodDictionary at: selector ifPresent: [ :existent |
		self error: 'Trying to override meta method {1} with value {2}.' format: { selector printString . value }
	] ifAbsentPut: [ value ]
]

{ #category : #adding }
SYMLNamespace >> addSymbol: aSymbol value: newValue [
	symbols at: aSymbol ifPresent: [ :existent |
		self error: 'Trying to override symbol {1} with {2}.' format: { aSymbol printString . newValue printString }
	] ifAbsentPut: [ newValue ]
]

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
	
	| namespaceScope |
	namespaceScope := SYMLNamespaceScope parent: aDefinitionBlock environment.
	namespaceScope programEntity: self.
	
	aDefinitionBlock value analyzeAndEvaluateInEnvironment: namespaceScope.

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

{ #category : #'as yet unclassified' }
SYMLNamespace >> semanticAnalysis [
	symbols valuesDo: #semanticAnalysis
]

{ #category : #'as yet unclassified' }
SYMLNamespace >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	name ifNil: [
		message selector numArgs = 0 ifTrue: [
			^ self setName: message selector ifNewReturnNode: message receiver
		].
	].

	symbols at: message selector ifPresent: [ :value |
		^ value asAPSGNodeInEnvironment: environment at: aPosition
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]
