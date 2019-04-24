Class {
	#name : #MbndAbstractConcreteMethod,
	#superclass : #MbndAbstractMethod,
	#instVars : [
		'receiverType',
		'type',
		'boundType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #'semantic analysis' }
MbndAbstractConcreteMethod >> analyzeExpandedMessageNode: node with: analyzer [
	| newReceiverNode argumentTypes newArgumentNodes |
	self receiverType isNil ~= node receiver isNil ifTrue: [
		self halt
	].

	self boundType argumentTypes size ~= node arguments size ifTrue: [ 
		self halt
	].

	newReceiverNode := node receiver ifNotNil: [ :receiver |
		analyzer addImplicitCastFor: (analyzer analyzeNodeIfNeeded: receiver) to: self receiverType 
	].

	argumentTypes := self boundType argumentTypes.
	newArgumentNodes := node arguments collectWithIndex: [ :argumentNode :index |
		analyzer addImplicitCastFor: (analyzer analyzeNodeIfNeeded: argumentNode) to: (argumentTypes at: index)
	].
	
	^ node copy
		method: self;
		receiver: newReceiverNode;
		arguments: newArgumentNodes;
		type: self returnType;
		yourself
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> boundType [
	^ boundType
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> boundType: anObject [
	boundType := anObject
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> receiverType [
	^ receiverType
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> receiverType: anObject [
	receiverType := anObject
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> type [
	^ type
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> type: anObject [
	type := anObject
]
