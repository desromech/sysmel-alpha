Class {
	#name : #MbndVariantUnionType,
	#superclass : #MbndBasicType,
	#instVars : [
		'components'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndVariantUnionType class >> typeName [
	^ #_VariantUnion
]

{ #category : #converting }
MbndVariantUnionType >> addExplicitConversionTo: targetType rule: conversionRule [
	components do: [ :comp |
		comp addExplicitConversionTo: targetType rule: conversionRule
	].
]

{ #category : #converting }
MbndVariantUnionType >> addImplicitConversionTo: targetType rule: conversionRule [
	components do: [ :comp |
		comp addImplicitConversionTo: targetType rule: conversionRule
	].
]

{ #category : #accessing }
MbndVariantUnionType >> components [
	^ components
]

{ #category : #accessing }
MbndVariantUnionType >> components: anObject [
	components := anObject
]

{ #category : #'testing methods' }
MbndVariantUnionType >> isVariantUnionType [
	^ true
]

{ #category : #'type composition' }
MbndVariantUnionType >> | otherType [
	<compileTime>
	^ self compilationTarget variantUnionTypeWithComponents: components , { otherType }
]
