Class {
	#name : #MbndOpaqueType,
	#superclass : #MbndNativeType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndOpaqueType class >> typeName [
	^ #_OpaqueType
]

{ #category : #'testing methods' }
MbndOpaqueType >> isOpaqueType [
	^ true
]
