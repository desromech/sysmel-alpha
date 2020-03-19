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

{ #category : #serialization }
MbndAstMetaBuilderInstanceNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#instance . instance encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
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

{ #category : #serialization }
MbndAstMetaBuilderInstanceNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	instance := encodedFields at: #instance.
]
