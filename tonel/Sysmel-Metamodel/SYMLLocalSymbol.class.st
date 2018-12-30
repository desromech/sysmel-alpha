Class {
	#name : #SYMLLocalSymbol,
	#superclass : #SYMLObject,
	#instVars : [
		'environment',
		'value'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLLocalSymbol >> = other [
	^ self class == other class and:
	[ environment == other environment and:
	[ value == other value ]]
]

{ #category : #accessing }
SYMLLocalSymbol >> asString [
	^ value asString
]

{ #category : #accessing }
SYMLLocalSymbol >> asSymbol [
	^ value
]

{ #category : #accessing }
SYMLLocalSymbol >> environment [
	^ environment
]

{ #category : #accessing }
SYMLLocalSymbol >> environment: anObject [
	environment := anObject
]

{ #category : #accessing }
SYMLLocalSymbol >> hash [
	^ self class identityHash bitXor: (environment identityHash bitXor: value identityHash)
]

{ #category : #testing }
SYMLLocalSymbol >> isLLVMAnon [
	^ value isLLVMAnon
]

{ #category : #testing }
SYMLLocalSymbol >> isSysmelLocalSymbol [
	^ true
]

{ #category : #accessing }
SYMLLocalSymbol >> numArgs [
	^ value numArgs
]

{ #category : #accessing }
SYMLLocalSymbol >> printOn: aStream [
	value printOn: aStream
]

{ #category : #accessing }
SYMLLocalSymbol >> value [
	^ value
]

{ #category : #accessing }
SYMLLocalSymbol >> value: anObject [
	value := anObject
]
