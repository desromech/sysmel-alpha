Class {
	#name : #MbndAbstractMethodGroup,
	#superclass : #MbndAbstractMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #evaluation }
MbndAbstractMethodGroup >> evaluateWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	self error: 'Cannot evaluate a method/function group with arguments.'
]

{ #category : #testing }
MbndAbstractMethodGroup >> isMethodGroup [
	^ true
]
