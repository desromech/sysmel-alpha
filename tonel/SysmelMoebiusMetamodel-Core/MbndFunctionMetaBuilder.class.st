Class {
	#name : #MbndFunctionMetaBuilder,
	#superclass : #MbndAbstractFunctionMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndFunctionMetaBuilder class >> globalBindingName [
	^ #function
]

{ #category : #flags }
MbndFunctionMetaBuilder >> CVariadic [
	self addFlag: #cvariadic
]

{ #category : #flags }
MbndFunctionMetaBuilder >> externC [
	self addFlag: #externC
]
