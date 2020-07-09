Class {
	#name : #MbndSlovimFunctionNullExceptionHandlingCodeGenerator,
	#superclass : #MbndSlovimFunctionExceptionHandlingCodeGenerator,
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #visiting }
MbndSlovimFunctionNullExceptionHandlingCodeGenerator >> forbiddenExceptionDuringCleanupTarget [
	^ nil
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
