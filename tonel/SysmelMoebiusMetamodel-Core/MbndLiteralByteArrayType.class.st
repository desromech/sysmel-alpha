Class {
	#name : #MbndLiteralByteArrayType,
	#superclass : #MbndLiteralArrayType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralByteArrayType class >> typeName [
	^ #_LiteralByteArray
]

{ #category : #'testing methods' }
MbndLiteralByteArrayType >> isLiteralByteArrayType [
	^ true
]

{ #category : #'semantic analysis' }
MbndLiteralByteArrayType >> standardConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	self halt
]
