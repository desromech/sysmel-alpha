Class {
	#name : #SYMLCompilationTargetFakeScope,
	#superclass : #SYMLAbstractScope,
	#instVars : [
		'compilationTarget'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #accessing }
SYMLCompilationTargetFakeScope >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
SYMLCompilationTargetFakeScope >> compilationTarget: anObject [
	compilationTarget := anObject
]
