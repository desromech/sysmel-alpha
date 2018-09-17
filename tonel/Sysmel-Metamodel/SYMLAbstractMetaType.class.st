Class {
	#name : #SYMLAbstractMetaType,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'instanceType'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #adding }
SYMLAbstractMetaType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	self
		addConversionRule: (SYMLIdentityTypeConversionRule when: [:source :target |
			source isMetaType and: [ target == self compilationTarget compilerObjectType ]
		])
]

{ #category : #accessing }
SYMLAbstractMetaType >> compilationTarget [
	^ instanceType compilationTarget
]

{ #category : #'as yet unclassified' }
SYMLAbstractMetaType >> generateSSATypeInfoForInstance: anInstanceType [
	^ SLVMConstant type: self ssaType value: 0
]

{ #category : #accessing }
SYMLAbstractMetaType >> instanceType [
	^ instanceType
]

{ #category : #accessing }
SYMLAbstractMetaType >> instanceType: anObject [
	instanceType := anObject
]

{ #category : #testing }
SYMLAbstractMetaType >> isMetaType [
	^ true
]
