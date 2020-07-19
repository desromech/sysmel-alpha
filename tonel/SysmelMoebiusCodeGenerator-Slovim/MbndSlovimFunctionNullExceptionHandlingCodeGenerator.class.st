Class {
	#name : #MbndSlovimFunctionNullExceptionHandlingCodeGenerator,
	#superclass : #MbndSlovimFunctionExceptionHandlingCodeGenerator,
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'cleanup scopes' }
MbndSlovimFunctionNullExceptionHandlingCodeGenerator >> executeScopeCleanUpActions: cleanUpScope exceptForTokens: suppressedCleanUpTokens [
	self inCleanUpContextDo: [ 
		cleanUpScope implicitFinalizationStateDictionary valuesDo: [ :action |
			(suppressedCleanUpTokens includes: action token) ifFalse: [ 
				self executeImplicitFinalizationAction: action
			].
		].
		cleanUpScope explicitFinalizationAction ifNotNil: [ :ac |
			ac value
		].

		self assert: cleanUpScope parentCatchAction isNil.
	].

]

{ #category : #visiting }
MbndSlovimFunctionNullExceptionHandlingCodeGenerator >> forbiddenExceptionDuringCleanupTarget [
	^ nil
]

{ #category : #'code generation' }
MbndSlovimFunctionNullExceptionHandlingCodeGenerator >> generateExceptionScopeNode: node [
	| cleanUpScope result |
	cleanUpScope := MbndSlovimExceptionScope new
		parent: currentCleanUpScope;
		compilationTarget: self compilationTarget.
	(currentCleanUpScope isNil and: self nonLocalReturnContext isNotNil) ifTrue: [ 
		cleanUpScope nonLocalReturnContext: self nonLocalReturnContext
	].

	allCleanUpScopes add: cleanUpScope.
	cleanUpScope allowedNodesWithImplicitFinalization: node nodesWithImplicitFinalization.
	
	cleanUpScope scopeEntryBlock: self slvmBuilder currentBlock.
	cleanUpScope isInCleanUpAction: inCleanUpContextCount > 0.

	node explicitCleanUpActions ifNotEmpty: [ 
		cleanUpScope explicitFinalizationAction: [
			node explicitCleanUpActions do: [ :cleanUpAction | self visitNode: cleanUpAction ]
		].
	].

	result := self generateExceptionScopeNodeContent: node onCleanUpScope: cleanUpScope.
	self slvmBuilder isLastTerminator ifFalse: [ 
		self executeScopeCleanUpActions: cleanUpScope
	].

	^ result
]

{ #category : #'exception handling' }
MbndSlovimFunctionNullExceptionHandlingCodeGenerator >> generateUnwindingCode [
	self assert: (self ssaFunction basicBlocks detect: [ :each | each unwindBlock ~~ nil ] ifFound: [ false ] ifNone: [ true]).
	self removeUnusedCleanUpActionStates.

]

{ #category : #testing }
MbndSlovimFunctionNullExceptionHandlingCodeGenerator >> hasExceptions [
	^ false
]

{ #category : #visiting }
MbndSlovimFunctionNullExceptionHandlingCodeGenerator >> validForbiddenExceptionDuringCleanupTarget [
	^ nil
]
