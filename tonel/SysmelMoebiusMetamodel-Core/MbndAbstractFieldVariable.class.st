Class {
	#name : #MbndAbstractFieldVariable,
	#superclass : #MbndAbstractVariable,
	#traits : 'TMbndEntityWithVisibility',
	#classTraits : 'TMbndEntityWithVisibility classTrait',
	#instVars : [
		'type',
		'initialValueNode',
		'initialValueScope',
		'byteOffset',
		'slotIndex',
		'location',
		'intrinsic'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #'semantic analysis' }
MbndAbstractFieldVariable >> analyzeReferenceNode: referenceNode with: analyzer [
	self error: 'Field description introspection is not yet implemented.' at: referenceNode
]

{ #category : #converting }
MbndAbstractFieldVariable >> asDescriptorSetBinding [
	^ slotIndex
]

{ #category : #converting }
MbndAbstractFieldVariable >> asDescriptorSetIndex [
	^ location isInteger ifTrue: [ location ] ifFalse: [ slotIndex ]
]

{ #category : #converting }
MbndAbstractFieldVariable >> asPushConstantIndex [
	^ location isInteger ifTrue: [ location ] ifFalse: [ 0 ]
]

{ #category : #converting }
MbndAbstractFieldVariable >> asSymbolBoundWithReceiverBinding: receiverBinding [
	^ MbndFieldBoundWithReceiver new
		receiver: receiverBinding;
		field: self;
		yourself
]

{ #category : #accessing }
MbndAbstractFieldVariable >> bits [
	^ nil
]

{ #category : #accessing }
MbndAbstractFieldVariable >> byteOffset [
	^ byteOffset
]

{ #category : #accessing }
MbndAbstractFieldVariable >> byteOffset: anObject [
	byteOffset := anObject
]

{ #category : #'as yet unclassified' }
MbndAbstractFieldVariable >> createPublicAccessorsIn: aParent [
	self assert: self name isMbndAnonymousSymbol not.
	aParent
		addInstanceAccessor: (MbndFieldGetterAccessorMacro new field: self) for: name asSymbol;
		addInstanceAccessor: (MbndFieldSetterAccessorMacro new field: self) for: (name , ':') asSymbol
]

{ #category : #accessing }
MbndAbstractFieldVariable >> defaultVisibilityMode [
	^ #protected
]

{ #category : #serialization }
MbndAbstractFieldVariable >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder) , {
		#type . type encodeGraphForMessagePackWith: graphEncoder.
		#byteOffset . byteOffset.
		#slotIndex . slotIndex.
		#location . location encodeGraphForMessagePackWith: graphEncoder..
		#intrinsic . intrinsic encodeGraphForMessagePackWith: graphEncoder..
	}
]

{ #category : #'as yet unclassified' }
MbndAbstractFieldVariable >> evaluateAggregateValue: aggregate [
	^ (aggregate slots at: slotIndex + 1) asMoebiusValueWithType: valueType
]

{ #category : #'as yet unclassified' }
MbndAbstractFieldVariable >> evaluateSetAggregate: aggregate value: newValue [
	aggregate slots at: slotIndex + 1 put: newValue unwrapMbndValue.
	^ aggregate
]

{ #category : #accessing }
MbndAbstractFieldVariable >> initialValueNode [
	^ initialValueNode
]

{ #category : #accessing }
MbndAbstractFieldVariable >> initialValueNode: anObject [
	initialValueNode := anObject
]

{ #category : #accessing }
MbndAbstractFieldVariable >> initialValueScope [
	^ initialValueScope
]

{ #category : #accessing }
MbndAbstractFieldVariable >> initialValueScope: anObject [
	initialValueScope := anObject
]

{ #category : #initialization }
MbndAbstractFieldVariable >> initialize [
	super initialize.
]

{ #category : #accessing }
MbndAbstractFieldVariable >> intrinsic [
	^ intrinsic
]

{ #category : #accessing }
MbndAbstractFieldVariable >> intrinsic: anObject [
	intrinsic := anObject
]

{ #category : #testing }
MbndAbstractFieldVariable >> isAlwaysExported [
	^ true
]

{ #category : #accessing }
MbndAbstractFieldVariable >> location [
	^ location
]

{ #category : #accessing }
MbndAbstractFieldVariable >> location: anObject [
	location := anObject
]

{ #category : #serialization }
MbndAbstractFieldVariable >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	type := encodedFields at: #type.
	byteOffset := encodedFields at: #byteOffset.
	slotIndex := encodedFields at: #slotIndex.
	location := encodedFields at: #location.
	intrinsic := encodedFields at: #intrinsic.
]

{ #category : #accessing }
MbndAbstractFieldVariable >> slotIndex [
	^ slotIndex
]

{ #category : #accessing }
MbndAbstractFieldVariable >> slotIndex: anObject [
	slotIndex := anObject
]

{ #category : #accessing }
MbndAbstractFieldVariable >> type [
	^ type
]

{ #category : #accessing }
MbndAbstractFieldVariable >> type: anObject [
	type := anObject
]
