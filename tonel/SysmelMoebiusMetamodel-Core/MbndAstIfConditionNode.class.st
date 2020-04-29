Class {
	#name : #MbndAstIfConditionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'condition',
		'trueValue',
		'falseValue',
		'storageCreationNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstIfConditionNode >> accept: aVisitor [
	^ aVisitor visitIfConditionNode: self
]

{ #category : #accessing }
MbndAstIfConditionNode >> condition [
	^ condition
]

{ #category : #accessing }
MbndAstIfConditionNode >> condition: anObject [
	condition := anObject
]

{ #category : #serialization }
MbndAstIfConditionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#condition . condition encodeGraphForMessagePackWith: graphEncoder.
		#trueValue . trueValue encodeGraphForMessagePackWith: graphEncoder.
		#falseValue . self falseValue encodeGraphForMessagePackWith: graphEncoder.
		#storageCreationNode . storageCreationNode encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstIfConditionNode >> falseValue [
	^ falseValue
]

{ #category : #accessing }
MbndAstIfConditionNode >> falseValue: anObject [
	falseValue := anObject
]

{ #category : #testing }
MbndAstIfConditionNode >> isIfConditionNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstIfConditionNode >> markStorageCreationNodeForCopyEllision: aStorageCreationNode [
	storageCreationNode := aStorageCreationNode
]

{ #category : #serialization }
MbndAstIfConditionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	condition := encodedFields at: #condition.
	trueValue := encodedFields at: #trueValue.
	self falseValue: (encodedFields at: #falseValue).
	storageCreationNode := encodedFields at: #storageCreationNode.
]

{ #category : #accessing }
MbndAstIfConditionNode >> storageCreationNode [
	^ storageCreationNode
]

{ #category : #accessing }
MbndAstIfConditionNode >> storageCreationNode: anObject [
	storageCreationNode := anObject
]

{ #category : #accessing }
MbndAstIfConditionNode >> trueValue [
	^ trueValue
]

{ #category : #accessing }
MbndAstIfConditionNode >> trueValue: anObject [
	trueValue := anObject
]
