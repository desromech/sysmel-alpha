Class {
	#name : #MbndConceptMetaBuilder,
	#superclass : #MbndAbstractNamedMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndConceptMetaBuilder class >> globalBindingName [
	^ #concept
]

{ #category : #accessing }
MbndConceptMetaBuilder >> assignValue: aPredicateNode [
	^ self predicate: aPredicateNode
]

{ #category : #accessing }
MbndConceptMetaBuilder >> predicate: aPredicateNode [
	| typeConceptNode |
	typeConceptNode := MbndAstPredicatedTypeConceptDefinitionNode new
		position: position;
		name: name;
		predicate: aPredicateNode;
		ownerProgramEntity: ownerProgramEntity;
		yourself.
	^ currentAnalyzer analyzeNodeIfNeeded: typeConceptNode
]
