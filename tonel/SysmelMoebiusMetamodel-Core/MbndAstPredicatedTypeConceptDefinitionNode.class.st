Class {
	#name : #MbndAstPredicatedTypeConceptDefinitionNode,
	#superclass : #MbndAstSymbolDefinition,
	#instVars : [
		'predicate'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPredicatedTypeConceptDefinitionNode >> accept: aVisitor [
	^ aVisitor visitPredicatedTypeConceptDefinitionNode: self
]

{ #category : #testing }
MbndAstPredicatedTypeConceptDefinitionNode >> isPredicatedTypeConceptDefinitionNode [
	^ true
]

{ #category : #accessing }
MbndAstPredicatedTypeConceptDefinitionNode >> predicate [
	^ predicate
]

{ #category : #accessing }
MbndAstPredicatedTypeConceptDefinitionNode >> predicate: anObject [
	predicate := anObject
]
