Class {
	#name : #MbndImportedModulePosition,
	#superclass : #MbndAbstractSourcePosition,
	#instVars : [
		'module'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Parsing'
}

{ #category : #comparing }
MbndImportedModulePosition >> = other [
	^ self class == other class and: [module == other module]
]

{ #category : #comparing }
MbndImportedModulePosition >> hash [
	^ module identityHash
]

{ #category : #accessing }
MbndImportedModulePosition >> module [
	^ module
]

{ #category : #accessing }
MbndImportedModulePosition >> module: anObject [
	module := anObject
]

{ #category : #printing }
MbndImportedModulePosition >> printOn: aStream [
	aStream nextPutAll: 'imported module '; nextPutAll: module name
]
