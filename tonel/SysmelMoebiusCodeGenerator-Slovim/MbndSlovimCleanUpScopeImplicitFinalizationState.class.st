Class {
	#name : #MbndSlovimCleanUpScopeImplicitFinalizationState,
	#superclass : #Object,
	#instVars : [
		'finalizationActivated',
		'finalizationActionBlock'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #accessing }
MbndSlovimCleanUpScopeImplicitFinalizationState >> finalizationActionBlock [
	^ finalizationActionBlock
]

{ #category : #accessing }
MbndSlovimCleanUpScopeImplicitFinalizationState >> finalizationActionBlock: anObject [
	finalizationActionBlock := anObject
]

{ #category : #accessing }
MbndSlovimCleanUpScopeImplicitFinalizationState >> finalizationActivated [
	^ finalizationActivated
]

{ #category : #accessing }
MbndSlovimCleanUpScopeImplicitFinalizationState >> finalizationActivated: anObject [
	finalizationActivated := anObject
]
