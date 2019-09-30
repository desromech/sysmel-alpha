Class {
	#name : #MbndOverrideFlagMetaBuilder,
	#superclass : #MbndAbstractFlagMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndOverrideFlagMetaBuilder class >> globalBindingName [
	^ #override
]

{ #category : #initialization }
MbndOverrideFlagMetaBuilder >> initialize [
	super initialize.
	self addFlag: #override.
]
