Class {
	#name : #MbndAstAggregateConstructionWithOrderedElementsNode,
	#superclass : #MbndAstAggregateConstructionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstAggregateConstructionWithOrderedElementsNode >> accept: visitor [
	^ visitor visitAggregateConstructionWithOrderedElementsNode: self
]

{ #category : #testing }
MbndAstAggregateConstructionWithOrderedElementsNode >> isAggregateConstructionWithOrderedElementsNode [
	^ true
]
