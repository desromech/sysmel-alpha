Class {
	#name : #MbndAstVariantTypeSelectorExtractionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'variant'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstVariantTypeSelectorExtractionNode >> accept: visitor [
	^ visitor visitVariantTypeSelectorExtractionNode: self
]

{ #category : #serialization }
MbndAstVariantTypeSelectorExtractionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#variant . variant encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #visiting }
MbndAstVariantTypeSelectorExtractionNode >> isVariantTypeSelectorExtractionNode [
	^ true
]

{ #category : #serialization }
MbndAstVariantTypeSelectorExtractionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	variant := encodedFields at: #variant.
]

{ #category : #accessing }
MbndAstVariantTypeSelectorExtractionNode >> variant [
	^ variant
]

{ #category : #accessing }
MbndAstVariantTypeSelectorExtractionNode >> variant: anObject [
	variant := anObject
]
