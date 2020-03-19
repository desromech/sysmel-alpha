Class {
	#name : #MbndSimpleMetaType,
	#superclass : #MbndBehaviorType,
	#traits : 'TMbndMetaType',
	#classTraits : 'TMbndMetaType classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndSimpleMetaType class >> materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder [
	objectType == #CoreBasicMetaType ifTrue: [
		| fields basicType basicMetaType |
		fields := Dictionary newFromPairs: graphDecoder decodeNext.
		basicType := graphDecoder compilationTarget getBasicTypeNamed: (fields at: #instanceType).
		basicMetaType := basicType type.
		graphDecoder registerObjectInstance: basicMetaType.
		^ basicMetaType
	].

	^ super materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder
]

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

{ #category : #serialization }
MbndSimpleMetaType >> encodeFieldsForMessagePackWith: graphEncoder [
	^ { #instanceType . instanceType encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #serialization }
MbndSimpleMetaType >> encodeGraphForMessagePackWith: graphEncoder [
	instanceType ifNotNil: [ 
		instanceType isCoreBasicType ifTrue: [ 
			^ graphEncoder encodeObject: self type: #CoreBasicMetaType fields: [
				{#instanceType . instanceType name}
			]
		].

		instanceType isSystemProvidedTypeTemplateInstanceMainChild ifTrue: [
			^ graphEncoder encodeObject: self type: #SystemProvidedTypeTemplateInstanceMainChildType fields: [
				self assert: instanceType parent isSystemProvidedTypeTemplateInstance.
				self assert: instanceType parent parent isSystemProvidedTypeTemplate.
				self assert: (self compilationTarget getBasicTypeNamed: instanceType parent parent name) == instanceType parent parent.

			{#systemTypeTemplate . instanceType parent parent name.
			 #instanceArguments . instanceType parent instanceArguments collect: [:each | each encodeGraphForMessagePackWith: graphEncoder]}
			]
		].
	].

	^ super encodeGraphForMessagePackWith: graphEncoder
]

{ #category : #accessing }
MbndSimpleMetaType >> instanceType: anObject [
	instanceType := anObject.
	name := nil.
]

{ #category : #serialization }
MbndSimpleMetaType >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	instanceType := encodedFields at: #instanceType.
]

{ #category : #accessing }
MbndSimpleMetaType >> printOn: aStream [
	| instanceTypeString |
	name ifNotNil: [ ^ super printOn: aStream ].
	
	instanceType ifNil: [ ^ super printOn: aStream ].
	instanceTypeString := instanceType asString.
	(instanceTypeString includes: Character space) ifTrue: [
		aStream nextPut: $(.
		aStream nextPutAll: instanceTypeString.
		aStream nextPut: $).
	] ifFalse: [ 
		aStream nextPutAll: instanceTypeString
	].
	aStream nextPutAll: ' type'.
]
