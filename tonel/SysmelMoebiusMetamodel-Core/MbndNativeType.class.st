"
I represent a native C style type.
"
Class {
	#name : #MbndNativeType,
	#superclass : #MbndBasicType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndNativeType class >> typeName [
	^ #_NativeType
]

{ #category : #'semantic analysis' }
MbndNativeType >> isDefined [
	^ self hasFlag: #defined
]

{ #category : #'as yet unclassified' }
MbndNativeType >> markAsDefined [
	self addFlag: #defined
]
