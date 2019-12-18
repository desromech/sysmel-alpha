"
I am an abstract compile time value, usually augmented with type information.
"
Class {
	#name : #MbndAbstractValue,
	#superclass : #Object,
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #converting }
MbndAbstractValue >> asMacroExpandedToConstant [
	^ MbndMacroExpandedToConstant new constantValue: self
]

{ #category : #converting }
MbndAbstractValue >> asMoebiusValueWithTarget: compilationTarget [
	^ self
]

{ #category : #converting }
MbndAbstractValue >> asMoebiusValueWithType: aType [
	^ self
]

{ #category : #accessing }
MbndAbstractValue >> compilationTarget [
	^ self type compilationTarget
]

{ #category : #copying }
MbndAbstractValue >> copyForValueAssignment [
	^ self
]

{ #category : #evaluation }
MbndAbstractValue >> evaluateReference [
	self assert: self type isReferenceType.
	^ self value value
]

{ #category : #testing }
MbndAbstractValue >> isAggregateTypeInstanceValue [
	^ false
]

{ #category : #testing }
MbndAbstractValue >> isMbndAbstractValue [
	^ true
]

{ #category : #accessing }
MbndAbstractValue >> type [
	self subclassResponsibility
]

{ #category : #evaluation }
MbndAbstractValue >> withoutReferences [
	self type isReferenceType ifTrue: [ ^ self evaluateReference ].
	^ self
]
