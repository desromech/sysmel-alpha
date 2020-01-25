Class {
	#name : #MbndSlovimExceptionScopeImplicitFinalizationState,
	#superclass : #Object,
	#instVars : [
		'token',
		'finalizationActivated',
		'finalizationActionBlocks',
		'isActuallyExecuted'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #adding }
MbndSlovimExceptionScopeImplicitFinalizationState >> addFinalizationActionBlock: aBlock [
	finalizationActionBlocks add: aBlock
]

{ #category : #accessing }
MbndSlovimExceptionScopeImplicitFinalizationState >> finalizationActionBlocks [
	^ finalizationActionBlocks
]

{ #category : #accessing }
MbndSlovimExceptionScopeImplicitFinalizationState >> finalizationActionBlocks: anObject [
	finalizationActionBlocks := anObject
]

{ #category : #accessing }
MbndSlovimExceptionScopeImplicitFinalizationState >> finalizationActivated [
	^ finalizationActivated
]

{ #category : #accessing }
MbndSlovimExceptionScopeImplicitFinalizationState >> finalizationActivated: anObject [
	finalizationActivated := anObject
]

{ #category : #initialization }
MbndSlovimExceptionScopeImplicitFinalizationState >> initialize [
	super initialize.
	finalizationActionBlocks := OrderedCollection new.
	isActuallyExecuted := false.
]

{ #category : #accessing }
MbndSlovimExceptionScopeImplicitFinalizationState >> isActuallyExecuted [
	^ isActuallyExecuted
]

{ #category : #accessing }
MbndSlovimExceptionScopeImplicitFinalizationState >> isActuallyExecuted: anObject [
	isActuallyExecuted := anObject
]

{ #category : #accessing }
MbndSlovimExceptionScopeImplicitFinalizationState >> token [
	^ token
]

{ #category : #accessing }
MbndSlovimExceptionScopeImplicitFinalizationState >> token: anObject [
	token := anObject
]
