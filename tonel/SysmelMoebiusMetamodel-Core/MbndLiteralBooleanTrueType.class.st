Class {
	#name : #MbndLiteralBooleanTrueType,
	#superclass : #MbndLiteralBooleanType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralBooleanTrueType class >> typeName [
	^ #_LiteralBooleanTrue
]

{ #category : #converting }
MbndLiteralBooleanTrueType >> asDynamicObjectTypeForLiteral [
	^ self compilationTarget managedObjectModel trueClass ifNil: [ super asDynamicObjectTypeForLiteral ]
]

{ #category : #'testing methods' }
MbndLiteralBooleanTrueType >> isLiteralBooleanTrueType [
	^ true
]
