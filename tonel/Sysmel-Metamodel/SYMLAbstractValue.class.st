Class {
	#name : #SYMLAbstractValue,
	#superclass : #SYMLObject,
	#category : #'Sysmel-Metamodel-Values'
}

{ #category : #'pattern matching' }
SYMLAbstractValue >> matchValue: suppliedValue withMatchingContext: argumentMatchingContext at: position [
	self subclassResponsibility
]

{ #category : #'pattern matching' }
SYMLAbstractValue >> matchValueOfType: suppliedType withMatchingContext: patternMatchingContext at: position [
	self subclassResponsibility
]
