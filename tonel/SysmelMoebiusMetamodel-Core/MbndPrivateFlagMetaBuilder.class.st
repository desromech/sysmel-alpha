Class {
	#name : #MbndPrivateFlagMetaBuilder,
	#superclass : #MbndAbstractFlagMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndPrivateFlagMetaBuilder class >> globalBindingName [
	^ #private
]

{ #category : #initialization }
MbndPrivateFlagMetaBuilder >> initialize [
	super initialize.
	self addFlag: #private.
]
