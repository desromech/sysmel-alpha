Class {
	#name : #MbndAstVariantUnboxingNode,
	#superclass : #MbndAstNode,
	#traits : 'TMbndFlagContainer',
	#classTraits : 'TMbndFlagContainer classTrait',
	#instVars : [
		'variant',
		'typeSelector'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstVariantUnboxingNode >> accept: visitor [
	^ visitor visitVariantUnboxingNode: self
]

{ #category : #serialization }
MbndAstVariantUnboxingNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#variant . variant encodeGraphForMessagePackWith: graphEncoder.
		#typeSelector . typeSelector encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #visiting }
MbndAstVariantUnboxingNode >> isVariantUnboxingNode [
	^ true
]

{ #category : #serialization }
MbndAstVariantUnboxingNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	variant := encodedFields at: #variant.
	typeSelector := encodedFields at: #typeSelector.
]

{ #category : #accessing }
MbndAstVariantUnboxingNode >> typeSelector [
	^ typeSelector
]

{ #category : #accessing }
MbndAstVariantUnboxingNode >> typeSelector: anObject [
	typeSelector := anObject
]

{ #category : #accessing }
MbndAstVariantUnboxingNode >> unchecked [
	^ self hasFlag: #unchecked
]

{ #category : #accessing }
MbndAstVariantUnboxingNode >> unchecked: aBoolean [
	^ self setFlag: #unchecked value: aBoolean
]

{ #category : #accessing }
MbndAstVariantUnboxingNode >> variant [
	^ variant
]

{ #category : #accessing }
MbndAstVariantUnboxingNode >> variant: anObject [
	variant := anObject
]
