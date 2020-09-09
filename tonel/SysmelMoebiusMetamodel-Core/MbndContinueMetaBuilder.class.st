Class {
	#name : #MbndContinueMetaBuilder,
	#superclass : #MbndAbstractStatementMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndContinueMetaBuilder class >> globalBindingName [
	^ #continue
]

{ #category : #'semantic analysis' }
MbndContinueMetaBuilder >> concretizeNodeAt: node withAnalyzer: analyzer [
	^ analyzer visitNode: (MbndAstContinueStatementNode new
		position: position;
		yourself)
]
