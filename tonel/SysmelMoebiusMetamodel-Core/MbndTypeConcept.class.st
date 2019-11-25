Class {
	#name : #MbndTypeConcept,
	#superclass : #MbndBasicType,
	#traits : 'TMbndMetaType',
	#classTraits : 'TMbndMetaType classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndTypeConcept class >> typeName [
	^ #_TypeConcept
]

{ #category : #'as yet unclassified' }
MbndTypeConcept >> doesTypeComplyWithConcept: aType [
	self subclassResponsibility
]

{ #category : #accessing }
MbndTypeConcept >> instanceType [
	self error: 'Cannot obtain an instance type from a concept.'
]

{ #category : #testing }
MbndTypeConcept >> isTypeConcept [
	^ true
]
