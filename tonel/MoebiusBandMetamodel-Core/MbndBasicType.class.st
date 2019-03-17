"
I am a MoebiusBand basic type that is not necesarily a Smalltalk Behavior.
"
Class {
	#name : #MbndBasicType,
	#superclass : #Object,
	#traits : 'TMbndBasicType',
	#classTraits : 'TMbndBasicType classTrait',
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndBasicType class >> typeName [
	^ nil
]

{ #category : #accessing }
MbndBasicType >> name [
	^ self class typeName
]
