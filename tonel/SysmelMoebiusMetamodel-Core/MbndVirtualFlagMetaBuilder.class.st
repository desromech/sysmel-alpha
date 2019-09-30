Class {
	#name : #MbndVirtualFlagMetaBuilder,
	#superclass : #MbndAbstractFlagMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndVirtualFlagMetaBuilder class >> globalBindingName [
	^ #virtual
]

{ #category : #initialization }
MbndVirtualFlagMetaBuilder >> initialize [
	super initialize.
	self addFlag: #virtual.
]
