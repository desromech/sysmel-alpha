Class {
	#name : #MbndInterfaceType,
	#superclass : #MbndAbstractClassType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndInterfaceType class >> typeName [
	^ #_InterfaceType
]

{ #category : #'testing methods' }
MbndInterfaceType >> isInterfaceType [
	^ true
]
