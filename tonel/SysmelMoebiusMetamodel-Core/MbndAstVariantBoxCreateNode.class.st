Class {
	#name : #MbndAstVariantBoxCreateNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'variantType',
		'typeSelector',
		'boxedValue',
		'storageCreationNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstVariantBoxCreateNode >> accept: visitor [
	^ visitor visitVariantBoxCreateNode: self
]

{ #category : #accessing }
MbndAstVariantBoxCreateNode >> boxedValue [
	^ boxedValue
]

{ #category : #accessing }
MbndAstVariantBoxCreateNode >> boxedValue: anObject [
	boxedValue := anObject
]

{ #category : #serialization }
MbndAstVariantBoxCreateNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#variantType . variantType encodeGraphForMessagePackWith: graphEncoder.
		#typeSelector . typeSelector encodeGraphForMessagePackWith: graphEncoder.
		#boxedValue . boxedValue encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstVariantBoxCreateNode >> isVariantBoxCreateNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstVariantBoxCreateNode >> markStorageCreationNodeForCopyEllision: aStorageCreationNode [
	storageCreationNode := aStorageCreationNode
]

{ #category : #serialization }
MbndAstVariantBoxCreateNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	variantType := encodedFields at: #variantType.
	typeSelector := encodedFields at: #typeSelector.
	boxedValue := encodedFields at: #boxedValue.
]

{ #category : #accessing }
MbndAstVariantBoxCreateNode >> storageCreationNode [
	^ storageCreationNode
]

{ #category : #accessing }
MbndAstVariantBoxCreateNode >> storageCreationNode: anObject [
	storageCreationNode := anObject
]

{ #category : #accessing }
MbndAstVariantBoxCreateNode >> typeSelector [
	^ typeSelector
]

{ #category : #accessing }
MbndAstVariantBoxCreateNode >> typeSelector: anObject [
	typeSelector := anObject
]

{ #category : #accessing }
MbndAstVariantBoxCreateNode >> variantType [
	^ variantType
]

{ #category : #accessing }
MbndAstVariantBoxCreateNode >> variantType: anObject [
	variantType := anObject
]
