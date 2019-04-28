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
MbndAbstractConcreteMethod >> analyzeExpandedMessageSendNode: node with: analyzer [
	| newReceiverNode argumentTypes newArgumentNodes |
	self receiverType isVoidType ~= node receiver isNil ifTrue: [
		self error: 'analyzing message send {1} with mismatching presence or lack of receiver types.'
			format: {self name asPrettySymbolName} at: node
	].

	self boundType argumentTypes size ~= node arguments size ifTrue: [ 
		self error: 'message send {1} with mismatching number of arguments. Expected {2} arguments.'
			format: {self name asPrettySymbolName . self boundType argumentTypes size asString} at: node
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
