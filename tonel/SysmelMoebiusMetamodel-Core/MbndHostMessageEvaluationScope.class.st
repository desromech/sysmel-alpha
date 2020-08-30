Class {
	#name : #MbndHostMessageEvaluationScope,
	#superclass : #ProcessLocalVariable,
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #'as yet unclassified' }
MbndHostMessageEvaluationScope class >> withValue: newValue do: aBlock [
	| oldValue |
	oldValue := self value.
	self value: newValue.
	aBlock ensure: [
		self value: oldValue
	]
]
