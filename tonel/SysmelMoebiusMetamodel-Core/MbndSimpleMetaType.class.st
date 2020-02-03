Class {
	#name : #MbndSimpleMetaType,
	#superclass : #MbndBehaviorType,
	#traits : 'TMbndMetaType',
	#classTraits : 'TMbndMetaType classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndSimpleMetaType class >> typeName [
	^ #_SimpleMetaType
]

{ #category : #visiting }
MbndSimpleMetaType >> accept: aVisitor [
	^ aVisitor visitSimpleMetaType: self
]

{ #category : #converting }
MbndSimpleMetaType >> analyzeReinterpretCastNode: node to: targetType with: analyzer [
	node expression isLiteralValueNode ifFalse: [ 
		self error: 'Metatype reinterpret cast is only supported with literal types.' at: node
	].

	^ node expression copy type: targetType
]

{ #category : #accessing }
MbndSimpleMetaType >> instanceType: anObject [
	instanceType := anObject.
	name := nil.
]

{ #category : #accessing }
MbndSimpleMetaType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].
	
	instanceType ifNil: [ ^ super printOn: aStream ].
	instanceType printOn: aStream.
	aStream nextPutAll: ' type'.
]
