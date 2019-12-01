Class {
	#name : #MbndOpaqueHandleType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndOpaqueHandleType class >> typeName [
	^ #_OpaqueHandleType
]

{ #category : #sizes }
MbndOpaqueHandleType >> instanceAlignment [
	^ self compilationTarget pointerAlignment
]

{ #category : #sizes }
MbndOpaqueHandleType >> instanceSize [
	^ self compilationTarget pointerSize
]

{ #category : #'testing methods' }
MbndOpaqueHandleType >> isOpaqueHandleType [
	^ true
]
