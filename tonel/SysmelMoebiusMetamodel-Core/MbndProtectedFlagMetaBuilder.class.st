Class {
	#name : #MbndProtectedFlagMetaBuilder,
	#superclass : #MbndAbstractFlagMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndProtectedFlagMetaBuilder class >> globalBindingName [
	^ #protected
]

{ #category : #initialization }
MbndProtectedFlagMetaBuilder >> initialize [
	super initialize.
	self addFlag: #protected.
]
