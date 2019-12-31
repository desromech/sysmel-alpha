Class {
	#name : #MbndConstFlagMetaBuilder,
	#superclass : #MbndAbstractFlagMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndConstFlagMetaBuilder class >> globalBindingName [
	^ #const
]

{ #category : #initialization }
MbndConstFlagMetaBuilder >> initialize [
	super initialize.
	self addFlag: #const.
]
