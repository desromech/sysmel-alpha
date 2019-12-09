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
	<compileTime>
	^ self compilationTarget pointerAlignment
]

{ #category : #sizes }
MbndOpaqueHandleType >> instanceSize [
	<compileTime>
	^ self compilationTarget pointerSize
]

{ #category : #'testing methods' }
MbndOpaqueHandleType >> isOpaqueHandleType [
	^ true
]
