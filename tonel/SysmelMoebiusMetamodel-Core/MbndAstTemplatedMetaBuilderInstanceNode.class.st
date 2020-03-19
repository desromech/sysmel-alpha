Class {
	#name : #MbndAstTemplatedMetaBuilderInstanceNode,
	#superclass : #MbndAstMetaBuilderInstanceNode,
	#instVars : [
		'templateNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #'as yet unclassified' }
MbndAstTemplatedMetaBuilderInstanceNode >> accept: aVisitor [
	^ aVisitor visitTemplatedMetaBuilderInstanceNode: self
]

{ #category : #serialization }
MbndAstTemplatedMetaBuilderInstanceNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#templateNode . templateNode encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #'as yet unclassified' }
MbndAstTemplatedMetaBuilderInstanceNode >> isTemplatedMetaBuilderInstanceNode [
	^ true
]

{ #category : #serialization }
MbndAstTemplatedMetaBuilderInstanceNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	templateNode := encodedFields at: #templateNode.
]

{ #category : #accessing }
MbndAstTemplatedMetaBuilderInstanceNode >> templateNode [
	^ templateNode
]

{ #category : #accessing }
MbndAstTemplatedMetaBuilderInstanceNode >> templateNode: anObject [
	templateNode := anObject
]
