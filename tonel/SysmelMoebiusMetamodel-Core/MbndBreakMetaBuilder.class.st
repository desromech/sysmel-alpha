Class {
	#name : #MbndBreakMetaBuilder,
	#superclass : #MbndAbstractStatementMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndBreakMetaBuilder class >> globalBindingName [
	^ #break
]

{ #category : #'semantic analysis' }
MbndBreakMetaBuilder >> concretizeNodeAt: node withAnalyzer: analyzer [
	^ analyzer visitNode: (MbndAstBreakStatementNode new
		position: position;
		yourself)
]
