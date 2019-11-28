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
		'slotIndex'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #'semantic analysis' }
MbndAbstractFieldVariable >> analyzeReferenceNode: referenceNode with: analyzer [
	self error: 'Field description introspection is not yet implemented.' at: referenceNode
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
