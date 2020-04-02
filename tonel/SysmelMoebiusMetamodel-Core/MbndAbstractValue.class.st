"
I am an abstract compile time value, usually augmented with type information.
"
Class {
	#name : #MbndAbstractValue,
	#superclass : #Object,
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #serialization }
MbndAbstractValue class >> messagePackTypeName [
	^ nil
]

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
MbndAbstractValue >> compilationEnvironment [
	^ self type compilationEnvironment
]

{ #category : #accessing }
MbndAbstractValue >> compilationTarget [
	^ self type compilationTarget
]

{ #category : #copying }
MbndAbstractValue >> copyForValueAssignment [
	^ self
]

{ #category : #serialization }
MbndAbstractValue >> encodeFieldsForMessagePackWith: graphEncoder [
	self subclassResponsibility
]

{ #category : #serialization }
MbndAbstractValue >> encodeGraphForMessagePackWith: graphEncoder [
	^ graphEncoder encodeObject: self type: self messagePackTypeName fields: [self encodeFieldsForMessagePackWith: graphEncoder]
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
MbndAbstractValue >> isMatrixTypeInstanceValue [
	^ false
]

{ #category : #testing }
MbndAbstractValue >> isMbndAbstractValue [
	^ true
]

{ #category : #testing }
MbndAbstractValue >> isVectorTypeInstanceValue [
	^ false
]

{ #category : #serialization }
MbndAbstractValue >> messagePackTypeName [
	^ self class messagePackTypeName
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
