Class {
	#name : #MbndUndefinedType,
	#superclass : #MbndOpaqueType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndUndefinedType class >> typeName [
	^ #_UndefinedType
]

{ #category : #'testing methods' }
MbndUndefinedType >> isUndefinedType [
	^ true
]
