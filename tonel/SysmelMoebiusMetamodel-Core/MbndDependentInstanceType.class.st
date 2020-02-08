Class {
	#name : #MbndDependentInstanceType,
	#superclass : #MbndDependentType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndDependentInstanceType class >> typeName [
	^ #_DependentInstanceType
]

{ #category : #converting }
MbndDependentInstanceType >> asConcreteTypeForAnalysisOfFunctionType: functionType [
	^ functionType argumentTypes first asDefaultInstanceType
]

{ #category : #converting }
MbndDependentInstanceType >> asResultTypeWithReceiver: receiverNode withArguments: argumentNodes [
	| receiverType |
	receiverType := receiverNode type withoutReferences withoutTopDecorations.
	receiverType isMetaType ifTrue: [ ^ receiverType instanceType ].
	^ receiverType asDefaultInstanceType
]

{ #category : #'testing methods' }
MbndDependentInstanceType >> isGarbageCollectedType [
	self flag: 'HACK: for basicNew new'.
	^ true
]
