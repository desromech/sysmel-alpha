Class {
	#name : #MbndNamespaceType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndNamespaceType class >> typeName [
	^ #_NamespaceType
]

{ #category : #'testing methods' }
MbndNamespaceType >> isNamespaceType [
	^ true
]
