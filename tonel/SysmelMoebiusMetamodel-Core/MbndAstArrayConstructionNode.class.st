Class {
	#name : #MbndAstArrayConstructionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'elementType',
		'elements',
		'storageCreationNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstArrayConstructionNode >> accept: visitor [
	^ visitor visitArrayConstructionNode: self
]

{ #category : #accessing }
MbndAstArrayConstructionNode >> elementType [
	^ elementType
]

{ #category : #accessing }
MbndAstArrayConstructionNode >> elementType: anObject [
	elementType := anObject
]

{ #category : #accessing }
MbndAstArrayConstructionNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstArrayConstructionNode >> elements: anObject [
	elements := anObject
]

{ #category : #serialization }
MbndAstArrayConstructionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#elementType . elementType encodeGraphForMessagePackWith: graphEncoder.
		#elements . elements encodeGraphForMessagePackWith: graphEncoder.
		#storageCreationNode . storageCreationNode encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstArrayConstructionNode >> isArrayConstructionNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstArrayConstructionNode >> markStorageCreationNodeForCopyEllision: aStorageCreationNode [
	storageCreationNode := aStorageCreationNode
]

{ #category : #serialization }
MbndAstArrayConstructionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	elementType := encodedFields at: #elementType.
	elements := encodedFields at: #elements.
	storageCreationNode := encodedFields at: #storageCreationNode.
]

{ #category : #accessing }
MbndAstArrayConstructionNode >> storageCreationNode [
	^ storageCreationNode
]

{ #category : #accessing }
MbndAstArrayConstructionNode >> storageCreationNode: anObject [
	storageCreationNode := anObject
]
