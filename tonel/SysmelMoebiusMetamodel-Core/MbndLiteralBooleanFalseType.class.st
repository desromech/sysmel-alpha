Class {
	#name : #MbndLiteralBooleanFalseType,
	#superclass : #MbndLiteralBooleanType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralBooleanFalseType class >> typeName [
	^ #_LiteralBooleanFalse
]

{ #category : #converting }
MbndLiteralBooleanFalseType >> asDynamicObjectTypeForLiteral [
	^ self compilationTarget managedObjectModel falseClass ifNil: [ super asDynamicObjectTypeForLiteral ]
]

{ #category : #'testing methods' }
MbndLiteralBooleanFalseType >> isLiteralBooleanFalseType [
	^ true
]
