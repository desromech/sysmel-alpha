Class {
	#name : #MbndStandaloneModule,
	#superclass : #MbndAbstractModule,
	#instVars : [
		'compilationTarget',
		'useLibC',
		'hasRuntimeTypeInformation',
		'hasStandardLibrary',
		'hasGarbageCollectionSupport',
		'hasGarbageCollectionStackMap',
		'hasLibC',
		'optimizationLevel'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #'as yet unclassified' }
MbndStandaloneModule class >> compilationTarget: aCompilationTarget [
	^ self basicNew
		initializeWithCompilationTarget: aCompilationTarget;
		yourself

]

{ #category : #'as yet unclassified' }
MbndStandaloneModule class >> llvm_x86 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_x86
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule class >> llvm_x86_64 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_x86_64
]

{ #category : #accessing }
MbndStandaloneModule >> compilationTarget [
	^ compilationTarget
]

{ #category : #parameters }
MbndStandaloneModule >> freestanding [
	<compileTime>
	^ self
		noLibC;
		noRTTI.
]

{ #category : #parameters }
MbndStandaloneModule >> hasGarbageCollectionStackMap [
	<compileTime>
	^ hasGarbageCollectionStackMap ifNil: [ hasGarbageCollectionStackMap := false ]
]

{ #category : #parameters }
MbndStandaloneModule >> hasGarbageCollectionStackMap: aBoolean [
	<compileTime>
	hasGarbageCollectionStackMap := aBoolean
]

{ #category : #parameters }
MbndStandaloneModule >> hasGarbageCollectionSupport [
	<compileTime>
	^ hasGarbageCollectionSupport ifNil: [ hasGarbageCollectionSupport := self hasRuntimeTypeInformation ]
]

{ #category : #parameters }
MbndStandaloneModule >> hasGarbageCollectionSupport: aBoolean [
	<compileTime>
	hasGarbageCollectionSupport := aBoolean
]

{ #category : #parameters }
MbndStandaloneModule >> hasLibC [
	<compileTime>
	^ hasLibC ifNil: [ hasLibC := true ]
]

{ #category : #parameters }
MbndStandaloneModule >> hasLibC: aBoolean [
	<compileTime>
	hasLibC := aBoolean
]

{ #category : #parameters }
MbndStandaloneModule >> hasPreciseGarbageCollector [
	^ false
]

{ #category : #parameters }
MbndStandaloneModule >> hasRuntimeTypeInformation [
	<compileTime>
	^ hasRuntimeTypeInformation ifNil: [ hasRuntimeTypeInformation := true ]
]

{ #category : #parameters }
MbndStandaloneModule >> hasRuntimeTypeInformation: aBoolean [
	<compileTime>
	hasRuntimeTypeInformation := aBoolean
]

{ #category : #parameters }
MbndStandaloneModule >> hasStandardLibrary [
	<compileTime>
	^ hasStandardLibrary ifNil: [ hasStandardLibrary := true ]
]

{ #category : #parameters }
MbndStandaloneModule >> hasStandardLibrary: aBoolean [
	<compileTime>
	hasStandardLibrary := aBoolean
]

{ #category : #accessing }
MbndStandaloneModule >> initializeWithCompilationTarget: aCompilationTarget [
	compilationTarget := aCompilationTarget.
	compilationTarget
		coreDefinitionsModule: self;
		initialize.
	self initialize
]

{ #category : #parameters }
MbndStandaloneModule >> noLibC [
	<compileTime>
	self
		hasLibC: false;
		useLibC: false
]

{ #category : #parameters }
MbndStandaloneModule >> noRTTI [
	<compileTime>
	self hasRuntimeTypeInformation: false
]

{ #category : #parameters }
MbndStandaloneModule >> noStandardLibrary [
	<compileTime>
	self hasStandardLibrary: false
]

{ #category : #parameters }
MbndStandaloneModule >> optimizationLevel [
	^ optimizationLevel ifNil: [ optimizationLevel := 0 ]
]

{ #category : #parameters }
MbndStandaloneModule >> optimizationLevel: anInteger [
	^ optimizationLevel := anInteger
]

{ #category : #parameters }
MbndStandaloneModule >> useLibC [
	<compileTime>
	^ useLibC ifNil: [ useLibC := self hasLibC ]
]

{ #category : #parameters }
MbndStandaloneModule >> useLibC: aBoolean [
	<compileTime>
	useLibC := aBoolean
]

{ #category : #initialization }
MbndStandaloneModule >> withDebugInformation [
	compilationTarget withDebugInformation
]

{ #category : #writing }
MbndStandaloneModule >> writeMode: writeMode toFileNamed: outputFileName [
	| lowLevelModule ssaModule |
	self finishSemanticAnalysis.
	ssaModule := self generateTargetCodeModule.
	
	self optimizationLevel > 0 ifTrue: [ 
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
