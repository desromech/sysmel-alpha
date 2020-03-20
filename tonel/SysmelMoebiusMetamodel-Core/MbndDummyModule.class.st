Class {
	#name : #MbndDummyModule,
	#superclass : #MbndAbstractModule,
	#instVars : [
		'compilationTarget',
		'compilationEnvironment'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #serialization }
MbndDummyModule class >> messagePackTypeName [
	^ #DummyModule
]

{ #category : #accessing }
MbndDummyModule >> compilationEnvironment [
	compilationEnvironment ifNil: [
		compilationEnvironment := MbndDummyCompilationEnvironment new dummyModule: self.
	].
	^ compilationEnvironment
]

{ #category : #accessing }
MbndDummyModule >> compilationTarget [
	compilationTarget ifNil: [
		compilationTarget := MbndDummyCompilationTarget basicNew.
		compilationTarget
			coreDefinitionsModule: self;
			initialize
	].

	^ compilationTarget
]
