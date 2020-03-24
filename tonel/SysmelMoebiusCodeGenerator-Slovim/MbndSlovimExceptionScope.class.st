Class {
	#name : #MbndSlovimExceptionScope,
	#superclass : #Object,
	#instVars : [
		'parent',
		'parentCatchAction',
		'scopeEntryBlock',
		'unwindBlock',
		'normalCleanUpBlock',
		'implicitFinalizationStateDictionary',
		'explicitFinalizationAction',
		'allowedNodesWithImplicitFinalization',
		'isInCleanUpAction',
		'catchSelectionBlock',
		'unwindCleanUpBlock',
		'catchedExceptions',
		'flattenedCatchedExceptions',
		'nonLocalReturnContext',
		'compilationTarget'
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
MbndSlovimExceptionScope >> catchSelectionBlock [
	^ catchSelectionBlock
]

{ #category : #accessing }
MbndSlovimExceptionScope >> catchSelectionBlock: anObject [
	catchSelectionBlock := anObject
]

{ #category : #accessing }
MbndSlovimExceptionScope >> catchedExceptions [
	^ catchedExceptions
]

{ #category : #accessing }
MbndSlovimExceptionScope >> catchedExceptions: anObject [
	catchedExceptions := anObject
]

{ #category : #accessing }
MbndSlovimExceptionScope >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
MbndSlovimExceptionScope >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #accessing }
MbndSlovimExceptionScope >> explicitFinalizationAction [
	^ explicitFinalizationAction
]

{ #category : #accessing }
MbndSlovimExceptionScope >> explicitFinalizationAction: anObject [
	explicitFinalizationAction := anObject
]

{ #category : #testing }
MbndSlovimExceptionScope >> flattenedCatchedExceptions [
	flattenedCatchedExceptions ifNil: [
		flattenedCatchedExceptions := #().
		parentCatchAction ifNil: [ 
			parent ifNotNil: [
				flattenedCatchedExceptions := parent flattenedCatchedExceptions
			]
		] ifNotNil: [
			flattenedCatchedExceptions := parentCatchAction scope parent
				ifNil: [ #() ]
				ifNotNil: [ :p | p flattenedCatchedExceptions ]
		].
	
		flattenedCatchedExceptions := flattenedCatchedExceptions , (catchedExceptions collect: [ :each | each node exceptionType ] thenReject: [:each | flattenedCatchedExceptions includes: each]).
		self nonLocalReturnContext ifNotNil: [
			flattenedCatchedExceptions := flattenedCatchedExceptions , { compilationTarget internalNonLocalReturnExceptionClass }
		].
	].
	^ flattenedCatchedExceptions
]

{ #category : #accessing }
MbndSlovimExceptionScope >> implicitFinalizationStateDictionary [
	^ implicitFinalizationStateDictionary
]

{ #category : #initialization }
MbndSlovimExceptionScope >> initialize [
	super initialize.
	catchedExceptions := #().
	implicitFinalizationStateDictionary := LLVMOrderedDictionary new.
]

{ #category : #testing }
MbndSlovimExceptionScope >> isCleanUpScopeOrParentCleanUp [
	parentCatchAction ifNotNil: [ ^ true ].
	explicitFinalizationAction ifNotNil: [ ^ true ].
	implicitFinalizationStateDictionary valuesDo: [ :state |
		state isActuallyExecuted ifTrue: [ ^ true ]
	].

	^ parent ifNil: [false] ifNotNil: [ parent isCleanUpScopeOrParentCleanUp ]
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
	catchedExceptions ifNotEmpty: [ ^ false ].
	parentCatchAction ifNotNil: [ ^ false ].
	explicitFinalizationAction ifNotNil: [ ^ false ].
	implicitFinalizationStateDictionary valuesDo: [ :state |
		state isActuallyExecuted ifTrue: [ ^ false ]
	].
	nonLocalReturnContext ifNotNil: [ ^ false ].
	^ true
]

{ #category : #testing }
MbndSlovimExceptionScope >> mustBeNopExceptionScope [
	catchedExceptions ifNotEmpty: [ ^ false ].
	parentCatchAction ifNotNil: [ ^ false ].
	explicitFinalizationAction ifNotNil: [ ^ false ].
	implicitFinalizationStateDictionary ifNotEmpty: [ ^ false ].
	nonLocalReturnContext ifNotNil: [ ^ false ].
	^ true
]

{ #category : #accessing }
MbndSlovimExceptionScope >> nonLocalReturnContext [
	^ nonLocalReturnContext
]

{ #category : #accessing }
MbndSlovimExceptionScope >> nonLocalReturnContext: anObject [
	nonLocalReturnContext := anObject
]

{ #category : #accessing }
MbndSlovimExceptionScope >> normalCleanUpBlock [
	^ normalCleanUpBlock
]

{ #category : #accessing }
MbndSlovimExceptionScope >> normalCleanUpBlock: anObject [
	normalCleanUpBlock := anObject
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
MbndSlovimExceptionScope >> parentCatchAction [
	^ parentCatchAction
]

{ #category : #accessing }
MbndSlovimExceptionScope >> parentCatchAction: anObject [
	parentCatchAction := anObject
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

{ #category : #accessing }
MbndSlovimExceptionScope >> unwindCleanUpBlock [
	^ unwindCleanUpBlock
]

{ #category : #accessing }
MbndSlovimExceptionScope >> unwindCleanUpBlock: anObject [
	unwindCleanUpBlock := anObject
]
