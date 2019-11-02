Class {
	#name : #MbndAbstractMethod,
	#superclass : #Object,
	#traits : 'TMbndMethod',
	#classTraits : 'TMbndMethod classTrait',
	#instVars : [
		'parent',
		'name'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #'semantic analysis' }
MbndAbstractMethod >> analyzeExpandedMessageSendNode: node with: analyzer [
	self subclassResponsibility
]

{ #category : #'semantic analysis' }
MbndAbstractMethod >> analyzeReferenceNode: referenceNode with: analyzer [
	^ MbndAstMethodReference new
		binding: self;
		position: referenceNode;
		type: self type ref;
		yourself
]

{ #category : #evaluation }
MbndAbstractMethod >> evaluateApplicationWithArguments: arguments withEvaluator: evaluator at: node [
	self assert: self receiverType isVoidType.
	^ self evaluateApplicationWithReceiver: nil arguments: arguments withEvaluator: evaluator at: node
]

{ #category : #evaluation }
MbndAbstractMethod >> evaluateApplicationWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	self subclassResponsibility
]

{ #category : #evaluation }
MbndAbstractMethod >> evaluateWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	self subclassResponsibility
]

{ #category : #testing }
MbndAbstractMethod >> hasVirtualTableEntry [
	^ false
]

{ #category : #accessing }
MbndAbstractMethod >> module [
	^ parent module
]

{ #category : #accessing }
MbndAbstractMethod >> name [
	^ name
]

{ #category : #accessing }
MbndAbstractMethod >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
MbndAbstractMethod >> parent [
	^ parent
]

{ #category : #accessing }
MbndAbstractMethod >> parent: anObject [
	parent := anObject
]
