Class {
	#name : #MbndModuleScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'module'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #accessing }
MbndModuleScope >> module [
	^ module
]

{ #category : #accessing }
MbndModuleScope >> module: anObject [
	module := anObject
]
