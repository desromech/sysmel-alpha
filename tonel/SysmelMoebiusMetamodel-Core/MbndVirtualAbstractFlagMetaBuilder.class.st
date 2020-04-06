Class {
	#name : #MbndVirtualAbstractFlagMetaBuilder,
	#superclass : #MbndAbstractFlagMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndVirtualAbstractFlagMetaBuilder class >> globalBindingName [
	^ #abstract
]

{ #category : #initialization }
MbndVirtualAbstractFlagMetaBuilder >> initialize [
	super initialize.
	self addFlag: #abstract.
]
