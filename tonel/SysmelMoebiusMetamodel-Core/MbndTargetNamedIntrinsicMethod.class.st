Class {
	#name : #MbndTargetNamedIntrinsicMethod,
	#superclass : #MbndAbstractIntrinsicMethod,
	#instVars : [
		'evaluationBlock'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndTargetNamedIntrinsicMethod >> accept: aVisitor [
	^ aVisitor visitTargetNamedIntrinsicMethod: self
]

{ #category : #evaluation }
MbndTargetNamedIntrinsicMethod >> evaluateWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	evaluationBlock ifNil: [ 
		self error: 'Cannot evaluate intrinsic method at {1} compile time.' format: (intrinsicName asPrettySymbolName) at: node
	].
	^ evaluationBlock cull: receiver cull: arguments cull: evaluator cull: node
]

{ #category : #accessing }
MbndTargetNamedIntrinsicMethod >> evaluationBlock [
	^ evaluationBlock
]

{ #category : #accessing }
MbndTargetNamedIntrinsicMethod >> evaluationBlock: anObject [
	evaluationBlock := anObject
]
