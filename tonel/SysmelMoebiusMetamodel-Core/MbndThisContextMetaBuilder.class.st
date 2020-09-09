Class {
	#name : #MbndThisContextMetaBuilder,
	#superclass : #MbndAbstractStatementMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndThisContextMetaBuilder class >> globalBindingName [
	^ #thisContext
]

{ #category : #'semantic analysis' }
MbndThisContextMetaBuilder >> concretizeNodeAt: node withAnalyzer: analyzer [
	^ analyzer visitNode: (MbndAstThisContextReferenceNode new
		position: position;
		yourself)
]
