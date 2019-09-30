Class {
	#name : #MbndStaticFlagMetaBuilder,
	#superclass : #MbndAbstractFlagMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndStaticFlagMetaBuilder class >> globalBindingName [
	^ #static
]

{ #category : #initialization }
MbndStaticFlagMetaBuilder >> initialize [
	super initialize.
	self addFlag: #static.
]
