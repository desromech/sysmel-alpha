Class {
	#name : #MbndAstMetaBuilderInstanceNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'instance'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMetaBuilderInstanceNode >> accept: aVisitor [
	^ aVisitor visitMetaBuilderInstanceNode: self
]

{ #category : #'as yet unclassified' }
MbndAstMetaBuilderInstanceNode >> concretizeNodeWithAnalyzer: analyzer [
	^ instance concretizeNode: self withAnalyzer: analyzer
]

{ #category : #accessing }
MbndAstMetaBuilderInstanceNode >> instance [
	^ instance
]

{ #category : #accessing }
MbndAstMetaBuilderInstanceNode >> instance: anObject [
	instance := anObject
]

{ #category : #testing }
MbndAstMetaBuilderInstanceNode >> isMetaBuilderInstanceNode [
	^ true
]
