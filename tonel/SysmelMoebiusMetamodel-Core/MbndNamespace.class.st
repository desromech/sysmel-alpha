Class {
	#name : #MbndNamespace,
	#superclass : #MbndAbstractNamespace,
	#traits : 'TMbndNamespaceLikeSymbolContainer',
	#classTraits : 'TMbndNamespaceLikeSymbolContainer classTrait',
	#instVars : [
		'name',
		'module'
	],
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'member symbols' }
MbndNamespace >> lookupSymbol: aSymbol [
	methodDict ifNil: [ ^ nil ].
	^ methodDict at: aSymbol ifAbsent: [ nil ]
]

{ #category : #accessing }
MbndNamespace >> module [
	^ module
]

{ #category : #accessing }
MbndNamespace >> module: anObject [
	module := anObject
]

{ #category : #accessing }
MbndNamespace >> name [
	^ name
]

{ #category : #accessing }
MbndNamespace >> name: anObject [
	name := anObject
]
