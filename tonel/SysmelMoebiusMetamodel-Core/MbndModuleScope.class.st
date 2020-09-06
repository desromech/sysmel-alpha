Class {
	#name : #MbndModuleScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'module'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #accessing }
MbndModuleScope >> activePackageName [
	^ module activePackageName
]

{ #category : #accessing }
MbndModuleScope >> module [
	^ module
]

{ #category : #accessing }
MbndModuleScope >> module: anObject [
	module := anObject
]
