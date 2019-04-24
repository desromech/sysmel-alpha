Class {
	#name : #MbndAbstractMethod,
	#superclass : #Object,
	#traits : 'TMbndMethod',
	#classTraits : 'TMbndMethod classTrait',
	#instVars : [
		'name'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #'semantic analysis' }
MbndAbstractMethod >> analyzeExpandedMessageNode: node with: analyzer [
	self subclassResponsibility
]

{ #category : #evaluation }
MbndAbstractMethod >> evaluateWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	self subclassResponsibility
]

{ #category : #accessing }
MbndAbstractMethod >> name [
	^ name
]

{ #category : #accessing }
MbndAbstractMethod >> name: anObject [
	name := anObject
]
