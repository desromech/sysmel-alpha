Class {
	#name : #MbndAstAggregateConstructionWithNamedElementsNode,
	#superclass : #MbndAstAggregateConstructionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstAggregateConstructionWithNamedElementsNode >> accept: visitor [
	^ visitor visitAggregateConstructionWithNamedElementsNode: self
]

{ #category : #testing }
MbndAstAggregateConstructionWithNamedElementsNode >> isAggregateConstructionWithNamedElementsNode [
	^ true
]
