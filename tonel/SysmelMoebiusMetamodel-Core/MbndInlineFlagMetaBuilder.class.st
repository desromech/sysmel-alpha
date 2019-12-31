Class {
	#name : #MbndInlineFlagMetaBuilder,
	#superclass : #MbndAbstractFlagMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndInlineFlagMetaBuilder class >> globalBindingName [
	^ #inline
]

{ #category : #initialization }
MbndInlineFlagMetaBuilder >> initialize [
	super initialize.
	self addFlag: #inline.
]
