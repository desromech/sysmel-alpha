Class {
	#name : #MbndAbstractMacro,
	#superclass : #Object,
	#traits : 'TMbndMacro',
	#classTraits : 'TMbndMacro classTrait',
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

{ #category : #'as yet unclassified' }
MbndAbstractMacro >> recordAsExtensionFor: ownerProgramEntity withSelector: registeredSelector [
	self module recordExtensionFor: ownerProgramEntity macroMethod: self withSelector: registeredSelector
]
