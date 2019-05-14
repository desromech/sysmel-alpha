Class {
	#name : #MbndAbstractClassType,
	#superclass : #MbndAggregateTypeWithFields,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndAbstractClassType class >> typeName [
	^ #_AbstractClassType
]

{ #category : #'testing methods' }
MbndAbstractClassType >> isAbstractClassType [
	^ true
]
