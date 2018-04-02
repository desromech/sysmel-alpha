Class {
	#name : #SYMLModule,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'compilationTarget',
		'currentDirectory',
		'globalNamespace',
		'topLevelScope',
		'ssaModule'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'instance creation' }
SYMLModule class >> compilationTarget: aCompilationTarget [
	^ self basicNew initializeWithCompilationTarget: aCompilationTarget; yourself
]

{ #category : #'instance creation' }
SYMLModule class >> for: aCompilationTarget [
	^ self compilationTarget: aCompilationTarget
]

{ #category : #'instance creation' }
SYMLModule class >> forCurrentImage [
	^ self for: SYMLCompilationTarget forCurrentImage
]

{ #category : #'instance creation' }
SYMLModule class >> new [
	^ self compilationTarget: SYMLCompilationTarget default.
]

{ #category : #'instance creation' }
SYMLModule class >> x86 [
	^ self for: SYMLCompilationTarget x86
]

{ #category : #'instance creation' }
SYMLModule class >> x86_64 [
	^ self for: SYMLCompilationTarget x86_64
]

{ #category : #adding }
SYMLModule >> addSymbol: symbol value: value [
	^ topLevelScope addSymbol: symbol value: value
]

{ #category : #accessing }
SYMLModule >> compilationTarget [
	<compileTime>
	^ compilationTarget
]

{ #category : #evaluating }
SYMLModule >> convertParseFailure: aFailure collection: collection [
	| position |
	aFailure isPetitFailure ifFalse: [ ^ self ].
	position := SYMLSourcePosition new collection: collection; start: aFailure position; stop: aFailure position.
	SYMLParseError new signal: position asString , ': ' , aFailure message.
]

{ #category : #evaluating }
SYMLModule >> evaluateFileNamed: aFileName [
	| fileEnvironment |
	fileEnvironment := self newEvaluationEnvironment.
	^ self evaluateFileNamed: aFileName inContext: fileEnvironment
]

{ #category : #evaluating }
SYMLModule >> evaluateFileNamed: aFileName inContext: context [
	| fileReference oldDirectory |
	fileReference := currentDirectory resolve: aFileName asFileReference.
	oldDirectory := currentDirectory.
	currentDirectory := fileReference parent.

	[
		^ self evaluateSource: fileReference contents name: fileReference fullName inContext: context
	] ensure: [  currentDirectory := oldDirectory ]

]

{ #category : #evaluating }
SYMLModule >> evaluateLanguageKernelFileNamed: aFileName [
	<compileTime>
	| fileEnvironment |
	fileEnvironment := self newLanguageKernelEnvironment.
	^ self evaluateFileNamed: aFileName value inContext: fileEnvironment
]

{ #category : #evaluating }
SYMLModule >> evaluateSource: aSourceString [
	^ self evaluateSource: aSourceString name: 'unnamed string'
]

{ #category : #evaluating }
SYMLModule >> evaluateSource: aSourceString name: aSourceName [
	| lexicalScope |
	lexicalScope := self newEvaluationEnvironment.
	^ self evaluateSource: aSourceString name: aSourceName inContext: lexicalScope
]

{ #category : #evaluating }
SYMLModule >> evaluateSource: aSourceString name: aSourceName inContext: context [
	| ast contents apsg |

	contents := aSourceString asSysmelCollectionWithContext.
	contents name: aSourceName.

	ast := SYMLParser parse: contents.
	self convertParseFailure: ast collection: contents.
	apsg := ast buildAPSG: (SYMLAPSGBuilder new environment: context).
	^ apsg analyzeAndEvaluateInEnvironment: context

]

{ #category : #accessing }
SYMLModule >> globalNamespace [
	<compileTime>
	^ globalNamespace
]

{ #category : #initialization }
SYMLModule >> initializeWithCompilationTarget: aCompilationTarget [
	compilationTarget := aCompilationTarget.
	currentDirectory := FileSystem workingDirectory.
	globalNamespace := SYMLNamespace new name: #__global; module: self.
]

{ #category : #evaluating }
SYMLModule >> moduleScope [
	^ SYMLNamespaceScope new
		parent: self topLevelScope;
		programEntity: globalNamespace;
		yourself
]

{ #category : #evaluating }
SYMLModule >> newEvaluationEnvironment [
	^ SYMLLexicalScope parent: self moduleScope
]

{ #category : #evaluating }
SYMLModule >> newLanguageKernelEnvironment [
	^ SYMLLexicalScope parent: self topLevelScope
]

{ #category : #accessing }
SYMLModule >> ssaModule [
	ssaModule ifNil: [ 
		ssaModule := SLVMModule new compilationTarget: compilationTarget lowLevelTarget
	].
	^ ssaModule
]

{ #category : #evaluating }
SYMLModule >> topLevelScope [
	^ topLevelScope ifNil: [topLevelScope := SYMLTopLevelScope new module: self]
]
