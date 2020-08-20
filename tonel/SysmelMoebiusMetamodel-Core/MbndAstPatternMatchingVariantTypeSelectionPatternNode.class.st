Class {
	#name : #MbndAstPatternMatchingVariantTypeSelectionPatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#instVars : [
		'expectedValueType',
		'valuePattern',
		'variantTypeSelector'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingVariantTypeSelectionPatternNode >> accept: visitor [
	^ visitor visitPatternMatchingVariantTypeSelectionPatternNode: self
]

{ #category : #serialization }
MbndAstPatternMatchingVariantTypeSelectionPatternNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#expectedValueType . expectedValueType encodeGraphForMessagePackWith: graphEncoder.
		#valuePattern . valuePattern encodeGraphForMessagePackWith: graphEncoder.
		#variantTypeSelector . variantTypeSelector.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstPatternMatchingVariantTypeSelectionPatternNode >> expectedValueType [
	^ expectedValueType
]

{ #category : #accessing }
MbndAstPatternMatchingVariantTypeSelectionPatternNode >> expectedValueType: anObject [
	expectedValueType := anObject
]

{ #category : #serialization }
MbndAstPatternMatchingVariantTypeSelectionPatternNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	expectedValueType := encodedFields at: #expectedValueType.
	valuePattern := encodedFields at: #valuePattern.
	variantTypeSelector := encodedFields at: #variantTypeSelector.
]

{ #category : #accessing }
MbndAstPatternMatchingVariantTypeSelectionPatternNode >> valuePattern [
	^ valuePattern
]

{ #category : #accessing }
MbndAstPatternMatchingVariantTypeSelectionPatternNode >> valuePattern: anObject [
	valuePattern := anObject
]

{ #category : #accessing }
MbndAstPatternMatchingVariantTypeSelectionPatternNode >> variantTypeSelector [
	^ variantTypeSelector
]

{ #category : #accessing }
MbndAstPatternMatchingVariantTypeSelectionPatternNode >> variantTypeSelector: anObject [
	variantTypeSelector := anObject
]
