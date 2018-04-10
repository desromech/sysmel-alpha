Class {
	#name : #SYMLChainedTypeConversionRule,
	#superclass : #SYMLTypeConversionRule,
	#instVars : [
		'intermediateType',
		'nextRule'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLChainedTypeConversionRule >> intermediateType [
	^ intermediateType
]

{ #category : #accessing }
SYMLChainedTypeConversionRule >> intermediateType: anObject [
	intermediateType := anObject
]

{ #category : #accessing }
SYMLChainedTypeConversionRule >> nextRule [
	^ nextRule
]

{ #category : #accessing }
SYMLChainedTypeConversionRule >> nextRule: anObject [
	nextRule := anObject
]
