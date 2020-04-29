Class {
	#name : #MbndAstTupleNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'storageCreationNode',
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #'as yet unclassified' }
MbndAstTupleNode >> accept: aVisitor [
	^ aVisitor visitTupleNode: self
]

{ #category : #accessing }
MbndAstTupleNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstTupleNode >> elements: anObject [
	elements := anObject
]

{ #category : #serialization }
MbndAstTupleNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#elements . elements encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #initialization }
MbndAstTupleNode >> initialize [
	super initialize.
	elements := #().
]

{ #category : #'as yet unclassified' }
MbndAstTupleNode >> isTupleNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstTupleNode >> markStorageCreationNodeForCopyEllision: aStorageCreationNode [
	storageCreationNode := aStorageCreationNode
]

{ #category : #serialization }
MbndAstTupleNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	elements := encodedFields at: #elements.
]

{ #category : #parsing }
MbndAstTupleNode >> parseAsFunctionArgumentsPrototype [
	^ elements collect: [:each | each parseAsArgumentDefinition]
]

{ #category : #accessing }
MbndAstTupleNode >> storageCreationNode [
	^ storageCreationNode
]

{ #category : #accessing }
MbndAstTupleNode >> storageCreationNode: anObject [
	storageCreationNode := anObject
]
