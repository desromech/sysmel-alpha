Class {
	#name : #MbndEnumType,
	#superclass : #MbndDerivedType,
	#instVars : [
		'valueType',
		'values'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndEnumType class >> typeName [
	^ #_EnumType
]

{ #category : #visiting }
MbndEnumType >> accept: visitor [
	^ visitor visitEnumType: self
]

{ #category : #initialization }
MbndEnumType >> initialize [
	super initialize.
	values := OrderedDictionary new.
]

{ #category : #sizes }
MbndEnumType >> instanceAlignment [
	^ valueType instanceAlignment
]

{ #category : #sizes }
MbndEnumType >> instanceSize [
	^ valueType instanceSize
]

{ #category : #'testing methods' }
MbndEnumType >> isEnumType [
	^ true
]

{ #category : #'as yet unclassified' }
MbndEnumType >> lookupStaticMacroSelector: selector [
	values at: selector ifPresent: [ :enumValue |
		^ enumValue asMacroExpandedToConstant
	].
	^ super lookupStaticMacroSelector: selector
]

{ #category : #accessing }
MbndEnumType >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndEnumType >> valueType: anObject [
	self assert: anObject ~~ self.
	valueType := anObject

]

{ #category : #accessing }
MbndEnumType >> values [
	^ values
]

{ #category : #accessing }
MbndEnumType >> values: anObject [
	values := anObject
]
