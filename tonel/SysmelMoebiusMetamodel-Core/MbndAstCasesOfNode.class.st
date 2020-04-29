Class {
	#name : #MbndAstCasesOfNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'matchedExpression',
		'cases',
		'hasDefaultCase',
		'storageCreationNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCasesOfNode >> accept: aVisitor [
	^ aVisitor visitCasesOfNode: self
]

{ #category : #accessing }
MbndAstCasesOfNode >> cases [
	^ cases
]

{ #category : #accessing }
MbndAstCasesOfNode >> cases: anObject [
	cases := anObject
]

{ #category : #serialization }
MbndAstCasesOfNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#matchedExpression . matchedExpression encodeGraphForMessagePackWith: graphEncoder.
		#cases . cases encodeGraphForMessagePackWith: graphEncoder.
		#hasDefaultCase . hasDefaultCase.
		#storageCreationNode . storageCreationNode encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstCasesOfNode >> hasDefaultCase [
	^ hasDefaultCase ifNil: [ hasDefaultCase := false ]
]

{ #category : #accessing }
MbndAstCasesOfNode >> hasDefaultCase: anObject [
	hasDefaultCase := anObject
]

{ #category : #testing }
MbndAstCasesOfNode >> isCasesOfNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstCasesOfNode >> markStorageCreationNodeForCopyEllision: aStorageCreationNode [
	storageCreationNode := aStorageCreationNode
]

{ #category : #accessing }
MbndAstCasesOfNode >> matchedExpression [
	^ matchedExpression
]

{ #category : #accessing }
MbndAstCasesOfNode >> matchedExpression: anObject [
	matchedExpression := anObject
]

{ #category : #serialization }
MbndAstCasesOfNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	matchedExpression := encodedFields at: #matchedExpression.
	cases := encodedFields at: #cases.
	hasDefaultCase := encodedFields at: #hasDefaultCase.
	storageCreationNode := encodedFields at: #storageCreationNode.
]

{ #category : #accessing }
MbndAstCasesOfNode >> storageCreationNode [
	^ storageCreationNode
]

{ #category : #accessing }
MbndAstCasesOfNode >> storageCreationNode: anObject [
	storageCreationNode := anObject
]
