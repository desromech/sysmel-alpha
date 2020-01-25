Class {
	#name : #MbndSlovimExceptionScope,
	#superclass : #Object,
	#instVars : [
		'parent',
		'scopeEntryBlock',
		'unwindBlock',
		'cleanUpBlock',
		'implicitFinalizationStateDictionary',
		'explicitFinalizationAction',
		'allowedNodesWithImplicitFinalization',
		'isInCleanUpAction'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #accessing }
MbndSlovimExceptionScope >> allowedNodesWithImplicitFinalization [
	^ allowedNodesWithImplicitFinalization
]

{ #category : #accessing }
MbndSlovimExceptionScope >> allowedNodesWithImplicitFinalization: anObject [
	allowedNodesWithImplicitFinalization := anObject
]

{ #category : #accessing }
MbndSlovimExceptionScope >> cleanUpBlock [
	^ cleanUpBlock
]

{ #category : #accessing }
MbndSlovimExceptionScope >> cleanUpBlock: anObject [
	cleanUpBlock := anObject
]

{ #category : #accessing }
MbndSlovimExceptionScope >> explicitFinalizationAction [
	^ explicitFinalizationAction
]

{ #category : #accessing }
MbndSlovimExceptionScope >> explicitFinalizationAction: anObject [
	explicitFinalizationAction := anObject
]

{ #category : #accessing }
MbndSlovimExceptionScope >> implicitFinalizationStateDictionary [
	^ implicitFinalizationStateDictionary
]

{ #category : #initialization }
MbndSlovimExceptionScope >> initialize [
	super initialize.
	implicitFinalizationStateDictionary := LLVMOrderedDictionary new.
]

{ #category : #accessing }
MbndSlovimExceptionScope >> isInCleanUpAction [
	^ isInCleanUpAction
]

{ #category : #accessing }
MbndSlovimExceptionScope >> isInCleanUpAction: anObject [
	isInCleanUpAction := anObject
]

{ #category : #testing }
MbndSlovimExceptionScope >> isNopExceptionScope [
	explicitFinalizationAction ifNotNil: [ ^ false ].
	implicitFinalizationStateDictionary valuesDo: [ :state |
		state isActuallyExecuted ifTrue: [ ^ false ]
	].
	^ true
]

{ #category : #accessing }
MbndSlovimExceptionScope >> parent [
	^ parent
]

{ #category : #accessing }
MbndSlovimExceptionScope >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
MbndSlovimExceptionScope >> scopeEntryBlock [
	^ scopeEntryBlock
]

{ #category : #accessing }
MbndSlovimExceptionScope >> scopeEntryBlock: anObject [
	scopeEntryBlock := anObject
]

{ #category : #accessing }
MbndSlovimExceptionScope >> unwindBlock [
	^ unwindBlock
]

{ #category : #accessing }
MbndSlovimExceptionScope >> unwindBlock: anObject [
	unwindBlock := anObject
]
