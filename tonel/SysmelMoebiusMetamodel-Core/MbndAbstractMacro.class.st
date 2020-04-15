Class {
	#name : #MbndAbstractMacro,
	#superclass : #Object,
	#traits : 'TMbndMacro',
	#classTraits : 'TMbndMacro classTrait',
	#instVars : [
		'parent'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #serialization }
MbndAbstractMacro class >> messagePackTypeName [
	^ nil
]

{ #category : #serialization }
MbndAbstractMacro >> messagePackTypeName [
	^ self class messagePackTypeName
]

{ #category : #accessing }
MbndAbstractMacro >> module [
	^ self parent module
]

{ #category : #accessing }
MbndAbstractMacro >> parent [
	^ parent
]

{ #category : #accessing }
MbndAbstractMacro >> parent: anObject [
	parent := anObject
]

{ #category : #'as yet unclassified' }
MbndAbstractMacro >> recordAsExtensionFor: ownerProgramEntity withSelector: registeredSelector [
	self module recordExtensionFor: ownerProgramEntity macroMethod: self withSelector: registeredSelector
]
