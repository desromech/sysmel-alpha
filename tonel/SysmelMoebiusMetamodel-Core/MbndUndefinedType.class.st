Class {
	#name : #MbndUndefinedType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndUndefinedType class >> typeName [
	^ #_UndefinedType
]

{ #category : #'default values' }
MbndUndefinedType >> defaultValue [
	^ MbndValue value: nil type: self
]

{ #category : #'testing methods' }
MbndUndefinedType >> isUndefinedType [
	^ true
]