Class {
	#name : #MbndStandaloneModule,
	#superclass : #MbndAbstractModule,
	#instVars : [
		'compilationTarget'
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

{ #category : #accessing }
MbndStandaloneModule >> initializeWithCompilationTarget: aCompilationTarget [
	compilationTarget := aCompilationTarget.
	compilationTarget
		coreDefinitionsModule: self;
		initialize.
	self initialize
]
