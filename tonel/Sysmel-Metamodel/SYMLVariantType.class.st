Class {
	#name : #SYMLVariantType,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'compilationTarget',
		'variants'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #comparing }
SYMLVariantType >> = other [
	^ self class == other class and:
	[ variants = other variants ]
]

{ #category : #conversions }
SYMLVariantType >> arithmeticCoercionWith: otherTypeValue into: resultTypeValue [
	<compileTime>
	<lazy>
	self variantAlternativesDo: [ :sourceVariantAlternative |
		sourceVariantAlternative arithmeticCoercionWith: otherTypeValue into: resultTypeValue
	]

]

{ #category : #accessing }
SYMLVariantType >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
SYMLVariantType >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #conversions }
SYMLVariantType >> conversionTo: targetTypeKindLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	self variantAlternativesDo: [ :sourceVariantAlternative |
		sourceVariantAlternative conversionTo: targetTypeKindLazyValue doOn: actionRules
	]

]

{ #category : #conversions }
SYMLVariantType >> explicitConversionTo: targetTypeKindLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	self variantAlternativesDo: [ :sourceVariantAlternative |
		sourceVariantAlternative explicitConversionTo: targetTypeKindLazyValue doOn: actionRules
	]

]

{ #category : #comparing }
SYMLVariantType >> hash [
	^ self class identityHash bitXor: variants hash
]

{ #category : #conversions }
SYMLVariantType >> implicitConversionTo: targetTypeKindLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	self variantAlternativesDo: [ :sourceVariantAlternative |
		sourceVariantAlternative implicitConversionTo: targetTypeKindLazyValue doOn: actionRules
	]

]

{ #category : #'as yet unclassified' }
SYMLVariantType >> isAnonymousType [
	^ true
]

{ #category : #conversions }
SYMLVariantType >> reinterpretConversionTo: targetTypeKindLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	self variantAlternativesDo: [ :sourceVariantAlternative |
		sourceVariantAlternative reinterpretConversionTo: targetTypeKindLazyValue doOn: actionRules
	]

]

{ #category : #'as yet unclassified' }
SYMLVariantType >> typeKindBaseTrait [
	^ self compilationTarget variantTypeTrait
]

{ #category : #'type composition' }
SYMLVariantType >> union: variantAlternative [
	<compileTime>
	^ self compilationTarget variantTypes: (variants copyWith: variantAlternative)
]

{ #category : #enumerating }
SYMLVariantType >> variantAlternativesDo: aBlock [
	variants do: aBlock
]

{ #category : #accessing }
SYMLVariantType >> variants [
	^ variants
]

{ #category : #accessing }
SYMLVariantType >> variants: anObject [
	variants := anObject
]
