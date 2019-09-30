Class {
	#name : #MbndPublicFlagMetaBuilder,
	#superclass : #MbndAbstractFlagMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndPublicFlagMetaBuilder class >> globalBindingName [
	^ #public
]

{ #category : #initialization }
MbndPublicFlagMetaBuilder >> initialize [
	super initialize.
	self addFlag: #public.
]
