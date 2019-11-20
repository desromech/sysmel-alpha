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
