Class {
	#name : #MbndAstMetaBuilderInstanceNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'instance'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMetaBuilderInstanceNode >> accept: aVisitor [
	^ aVisitor visitMetaBuilderInstanceNode: self
]

{ #category : #'as yet unclassified' }
MbndAstMetaBuilderInstanceNode >> concretizeNodeWithAnalyzer: analyzer [
	^ instance concretizeGenericNode: self withAnalyzer: analyzer
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

{ #category : #'as yet unclassified' }
MbndAstMetaBuilderInstanceNode >> isNonConcreteNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstMetaBuilderInstanceNode >> isTemplatedMetaBuilderInstanceNode [
	^ true
]
