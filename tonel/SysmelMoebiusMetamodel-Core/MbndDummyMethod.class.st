"
I am a dummy method that is typically used for generating trampolines.
"
Class {
	#name : #MbndDummyMethod,
	#superclass : #MbndAbstractSpecificMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndDummyMethod class >> messagePackTypeName [
	^ #DummyMethod
]

{ #category : #'as yet unclassified' }
MbndDummyMethod >> getNonLocalReturnTarget [
	^ nil
]
