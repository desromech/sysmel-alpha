Class {
	#name : #MbndAbstractSourcePosition,
	#superclass : #Object,
	#category : #'SysmelMoebiusMetamodel-Core-Parsing'
}

{ #category : #converting }
MbndAbstractSourcePosition >> asActualSourcePosition [
	^ self
]

{ #category : #converting }
MbndAbstractSourcePosition >> asMoebiusBandSourcePosition [
	^ self
]

{ #category : #converting }
MbndAbstractSourcePosition >> asSourcePositionString [
	^ self asString
]

{ #category : #converting }
MbndAbstractSourcePosition >> asSysmelSourcePosition [
	^ self
]
