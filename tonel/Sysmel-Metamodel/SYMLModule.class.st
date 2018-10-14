Class {
	#name : #SYMLModule,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'compilationTarget',
		'currentDirectory',
		'globalNamespace',
		'topLevelScope',
		'ssaModule',
		'pendingSemanticAnalysis',
		'pendingSSACodeGeneration',
		'optimizationLevel',
		'debugLocationDictionary',
		'debugSourceFileDictionary',
		'evaluatedFileReferences',
		'hasNoRuntimeTypeInformation',
		'useLibC',
		'identityHashRandomGenerator',
		'defaultSourceCodeParser'
	],
	#classVars : [
		'GlobalParserRegistry'
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
SYMLModule class >> llvm_x86 [
	^ self for: SYMLCompilationTarget llvm_x86
]

{ #category : #'instance creation' }
SYMLModule class >> llvm_x86_64 [
	^ self for: SYMLCompilationTarget llvm_x86_64
]

{ #category : #'instance creation' }
SYMLModule class >> new [
	^ self compilationTarget: SYMLCompilationTarget default.
]

{ #category : #'multiple parsers' }
SYMLModule class >> parserRegistry [
	^ GlobalParserRegistry ifNil: [ GlobalParserRegistry := Dictionary new ]
]

{ #category : #'as yet unclassified' }
SYMLModule class >> registerParser: aParser forExtension: anExtension [
	^ self registerParser: aParser forExtensions: { anExtension }
]

{ #category : #'multiple parsers' }
SYMLModule class >> registerParser: aParser forExtensions: aCollectionOfExtensions [
	aCollectionOfExtensions do: [ :extension | self parserRegistry at: extension put: aParser]
]

{ #category : #'instance creation' }
SYMLModule class >> spirv [
	^ self spirv_logical64
]

{ #category : #'instance creation' }
SYMLModule class >> spirv_logical64 [
	^ self for: SYMLCompilationTarget spirv_logical64
]

{ #category : #'instance creation' }
SYMLModule class >> x86 [
	^ self for: SYMLCompilationTarget x86
]

{ #category : #'instance creation' }
SYMLModule class >> x86_64 [
	^ self for: SYMLCompilationTarget x86_64 pic
]

{ #category : #'semantic analysis' }
SYMLModule >> addPendingSSACodeGeneration: aNode [
	pendingSSACodeGeneration add: aNode.

]

{ #category : #'semantic analysis' }
SYMLModule >> addPendingSemanticAnalysis: aNode [
	pendingSemanticAnalysis add: aNode.

]

{ #category : #'code generation' }
SYMLModule >> buildSSAModule [
	| extraToGenerate |
	extraToGenerate := OrderedCollection new.
	
	[ pendingSSACodeGeneration isNotEmpty  ] whileTrue: [ 
		extraToGenerate addAll: pendingSSACodeGeneration.
		pendingSSACodeGeneration removeAll.
		
		extraToGenerate do: #generateSSACode.		
		extraToGenerate removeAll
	].

	^ self ssaModule
]

{ #category : #accessing }
SYMLModule >> compilationTarget [
	<compileTime>
	^ compilationTarget
]

{ #category : #'code generation' }
SYMLModule >> convertDebugPosition: aPosition [
	^ self debugLocationDictionary at: aPosition ifAbsentPut: [ SLVMDebugLocation new
			sourceFile: (self convertDebugSourceFile: aPosition collection);
			start: aPosition start;
			stop: aPosition stop;
			startLine: aPosition line;
			startColumn: aPosition column;
			endLine: aPosition endLine;
			endColumn: aPosition endColumn;
			collection: aPosition collection;
			yourself ]
]

{ #category : #'code generation' }
SYMLModule >> convertDebugSourceFile: aSourceCollection [
	| sourceRef |
	^ self debugSourceFileDictionary at: aSourceCollection ifAbsentPut: [ 
		sourceRef := (aSourceCollection ifNil: ['generated'] ifNotNil: [aSourceCollection name]) asFileReference.
		SLVMDebugSourceFile new
			directory: sourceRef parent fullName;
			name: sourceRef basename
	]
]

{ #category : #evaluating }
SYMLModule >> convertParseFailure: aFailure collection: collection [
	| position |
	aFailure isPetitFailure ifFalse: [ ^ self ].
	position := SYMLSourcePosition new collection: collection; start: aFailure position; stop: aFailure position.
	SYMLParseError new signal: position asString , ': ' , aFailure message.
]

{ #category : #'code generation' }
SYMLModule >> debugLocationDictionary [
	^ debugLocationDictionary ifNil: [debugLocationDictionary := Dictionary new]
]

{ #category : #'code generation' }
SYMLModule >> debugSourceFileDictionary [
	^ debugSourceFileDictionary ifNil: [debugSourceFileDictionary := Dictionary new]
]

{ #category : #'multiple parsers' }
SYMLModule >> defaultSourceCodeParser [
	^ defaultSourceCodeParser ifNil: [ defaultSourceCodeParser := self parserForSourceExtension: 'sysmel' ]
]

{ #category : #'multiple parsers' }
SYMLModule >> defaultSourceCodeParser: aParser [
	defaultSourceCodeParser := aParser
]

{ #category : #evaluating }
SYMLModule >> evaluateFileNamed: aFileName [
	<compileTime>
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
SYMLModule >> evaluateFileNamedOnce: aFileName [
	<compileTime>
	| fileEnvironment |
	fileEnvironment := self newEvaluationEnvironment.
	^ self evaluateFileNamedOnce: aFileName inContext: fileEnvironment
]

{ #category : #evaluating }
SYMLModule >> evaluateFileNamedOnce: aFileName inContext: context [
	| fileReference oldDirectory |
	fileReference := currentDirectory resolve: aFileName asFileReference.	
	oldDirectory := currentDirectory.
	currentDirectory := fileReference parent.

	[
		^ evaluatedFileReferences at: fileReference ifAbsentPut: [self evaluateSource: fileReference contents name: fileReference fullName inContext: context]
	] ensure: [  currentDirectory := oldDirectory ]

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
	| ast contents apsg result |

	contents := aSourceString asSysmelCollectionWithContext.
	contents name: aSourceName.

	ast := (self parserForSourceNamed: aSourceName inContext: context) parse: contents.
	self convertParseFailure: ast collection: contents.
	apsg := ast buildAPSG: (SYMLAPSGBuilder new environment: context).
	[
		result := apsg analyzeAndEvaluateInEnvironment: context
	] on: SYMLValueReturnException do: [ :returnException |
		self halt.
	].
	^ result

]

{ #category : #'compilation options' }
SYMLModule >> freestanding [
	^ self
		noLibC;
		noRTTI.
]

{ #category : #initialization }
SYMLModule >> generateIdentityHash [
	^ (identityHashRandomGenerator nextInt: (1<<32) + 1) - 1 
]

{ #category : #accessing }
SYMLModule >> globalNamespace [
	<compileTime>
	^ globalNamespace
]

{ #category : #'compilation options' }
SYMLModule >> hasNoRuntimeTypeInformation [
	<compileTime>
	^ hasNoRuntimeTypeInformation ifNil: [ hasNoRuntimeTypeInformation := false ]
]

{ #category : #'compilation options' }
SYMLModule >> hasNoRuntimeTypeInformation: aBoolean [
	<compileTime>
	hasNoRuntimeTypeInformation := aBoolean
]

{ #category : #'compilation options' }
SYMLModule >> hasRuntimeTypeInformation [
	<compileTime>
	^ self hasNoRuntimeTypeInformation not
]

{ #category : #initialization }
SYMLModule >> initializeWithCompilationTarget: aCompilationTarget [
	self initialize.
	compilationTarget := aCompilationTarget.
	optimizationLevel := 0.
	currentDirectory := FileSystem workingDirectory.
	globalNamespace := SYMLNamespace new name: #__global; module: self.
	pendingSemanticAnalysis := SLVMOrderedInsertionSet new.
	pendingSemanticAnalysis add: globalNamespace.

	pendingSSACodeGeneration := SLVMOrderedInsertionSet new.
	pendingSSACodeGeneration add: globalNamespace.
	
	evaluatedFileReferences := Dictionary new.
	
	identityHashRandomGenerator := Random seed: 1.
]

{ #category : #testing }
SYMLModule >> isEmittingDebugInformation [
	^ compilationTarget emittingDebugInformation
]

{ #category : #accessing }
SYMLModule >> mangledName [
	^ self parentMangledName 

]

{ #category : #adding }
SYMLModule >> methodWithSelector: selector ifPresent: presentBlock ifAbsentPut: absentBlock [
	^ topLevelScope methodWithSelector: selector ifPresent: presentBlock ifAbsentPut: absentBlock
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

{ #category : #'compilation options' }
SYMLModule >> noLibC [
	<compileTime>
	self useLibC: false
]

{ #category : #'compilation options' }
SYMLModule >> noRTTI [
	<compileTime>
	self hasNoRuntimeTypeInformation: true
]

{ #category : #accessing }
SYMLModule >> operatingSystemName [
	<compileTime>
	^ compilationTarget operatingSystemName
]

{ #category : #accessing }
SYMLModule >> optimizationLevel [
	^ optimizationLevel
]

{ #category : #accessing }
SYMLModule >> optimizationLevel: anObject [
	optimizationLevel := anObject
]

{ #category : #'multiple parsers' }
SYMLModule >> parserForSourceExtension: extension [
	| lowerExtension |
	lowerExtension := extension asLowercase.
	self class parserRegistry at: lowerExtension ifPresent: [ :found | ^ found ].
	^ nil
]

{ #category : #'multiple parsers' }
SYMLModule >> parserForSourceNamed: sourceName inContext: aContext [
	| extension |
	extension := sourceName asFileReference extension.
	(extension isNotNil and: [ extension isNotEmpty ]) ifTrue: [
		(self parserForSourceExtension: extension) ifNotNil: [ :parser | ^ parser ]
	].

	^ aContext currentSourceCodeParser
]

{ #category : #'semantic analysis' }
SYMLModule >> semanticAnalysis [
	| extraToAnalyze |
	extraToAnalyze := OrderedCollection new.
	
	[ pendingSemanticAnalysis isNotEmpty  ] whileTrue: [ 
		extraToAnalyze addAll: pendingSemanticAnalysis.
		pendingSemanticAnalysis removeAll.
		
		extraToAnalyze do: #semanticAnalysis.		
		extraToAnalyze removeAll
	]
	
]

{ #category : #'code generation' }
SYMLModule >> ssaConstantArrayValue: value type: type [
	<compileTime>
	| elementType elements ssaType actualValue defaultElement |
	ssaType := type ssaType.
	elementType := type elementType.
	elements := ssaType elements.
	value ifNil: [
		defaultElement := elementType generateSSAConstant: elementType defaultValue forModule: self.
		actualValue := (1 to: elements) collect: [:i | defaultElement]
	] ifNotNil: [
		self halt
	].

	^ SLVMConstant array: ssaType slots: actualValue asArray.
]

{ #category : #'code generation' }
SYMLModule >> ssaConstantPointer: value type: type [
	<compileTime>
	value isSLVMObject ifTrue: [
		^ SLVMConstant value: value bitcast: type ssaType
	].

	^ SLVMConstant type: type ssaType value: value
]

{ #category : #'code generation' }
SYMLModule >> ssaConstantPrimitiveValue: value type: type [
	<compileTime>
	^ SLVMConstant type: type ssaType value: value
]

{ #category : #'code generation' }
SYMLModule >> ssaConstantVariableArrayValue: value type: type [
	<compileTime>
	| elementType arrayType |
	elementType := type elementType.
	arrayType := SLVMArrayType baseType: elementType ssaType elements: value size.
	value class == ByteArray ifTrue: [ 
		^ SLVMConstant array: arrayType blob: value
	].

	^ SLVMConstant array: arrayType slots: (value collect: [ :slot |
		elementType generateSSAConstant: slot forModule: self
	]).

]

{ #category : #accessing }
SYMLModule >> ssaModule [
	ssaModule ifNil: [ 
		ssaModule := SLVMModule new compilationTarget: compilationTarget target
	].
	^ ssaModule
]

{ #category : #adding }
SYMLModule >> symbol: aSymbol ifPresent: ifPresentBlock ifAbsent: ifAbsentBlock [
	^ topLevelScope symbol: aSymbol ifPresent: ifPresentBlock ifAbsent: ifAbsentBlock
]

{ #category : #evaluating }
SYMLModule >> topLevelScope [
	<compileTime>
	^ topLevelScope ifNil: [topLevelScope := SYMLTopLevelScope new module: self]
]

{ #category : #'compilation options' }
SYMLModule >> useLibC [
	<compileTime>
	^ useLibC ifNil: [ useLibC := true ]
]

{ #category : #'compilation options' }
SYMLModule >> useLibC: aBoolean [
	<compileTime>
	useLibC := aBoolean
]

{ #category : #'compilation options' }
SYMLModule >> withDebugInformation [
	compilationTarget withDebugInformation
]

{ #category : #writing }
SYMLModule >> writeMode: writeMode ToFileNamed: outputFileName [
	| lowLevelModule |
	self semanticAnalysis;
		buildSSAModule.
	
	optimizationLevel > 0 ifTrue: [ 
		ssaModule optimizeGlobalVariables
	].

	lowLevelModule := ssaModule asLowLevelModuleWithOptimizationLevel: optimizationLevel.
	writeMode == #assembly ifTrue: [
		^ lowLevelModule writeAssemblyToFileNamed: outputFileName
	].

	writeMode == #object ifTrue: [
		^ lowLevelModule writeObjectToFileNamed: outputFileName
	].

	writeMode == #executable ifTrue: [
		^ lowLevelModule writeExecutableToFileNamed: outputFileName
	].

	writeMode == #shared ifTrue: [
		^ lowLevelModule writeSharedToFileNamed: outputFileName
	].

	self error: 'Writing mode ' , writeMode printString , ' not yet implemented'

]
