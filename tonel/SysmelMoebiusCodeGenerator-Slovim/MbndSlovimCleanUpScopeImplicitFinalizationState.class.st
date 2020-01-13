Class {
	#name : #MbndSlovimCleanUpScopeImplicitFinalizationState,
	#superclass : #Object,
	#instVars : [
		'token',
		'finalizationActivated',
		'finalizationActionBlocks'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #adding }
MbndSlovimCleanUpScopeImplicitFinalizationState >> addFinalizationActionBlock: aBlock [
	finalizationActionBlocks add: aBlock
]

{ #category : #accessing }
MbndSlovimCleanUpScopeImplicitFinalizationState >> finalizationActionBlocks [
	^ finalizationActionBlocks
]

{ #category : #accessing }
MbndSlovimCleanUpScopeImplicitFinalizationState >> finalizationActivated [
	^ finalizationActivated
]

{ #category : #accessing }
MbndSlovimCleanUpScopeImplicitFinalizationState >> finalizationActivated: anObject [
	finalizationActivated := anObject
]

{ #category : #initialization }
MbndSlovimCleanUpScopeImplicitFinalizationState >> initialize [
	super initialize.
	finalizationActionBlocks := OrderedCollection new.
]

{ #category : #accessing }
MbndSlovimCleanUpScopeImplicitFinalizationState >> token [
	^ token
]

{ #category : #accessing }
MbndSlovimCleanUpScopeImplicitFinalizationState >> token: anObject [
	token := anObject
]
