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

{ #category : #composition }
MbndImportedModulePosition >> collection [
	^ nil
]

{ #category : #accessing }
MbndImportedModulePosition >> column [
	^ 0
]

{ #category : #accessing }
MbndImportedModulePosition >> endColumn [
	^ 0
]

{ #category : #accessing }
MbndImportedModulePosition >> endLine [
	^ 0
]

{ #category : #comparing }
MbndImportedModulePosition >> hash [
	^ module identityHash
]

{ #category : #testing }
MbndImportedModulePosition >> isEmptySourcePosition [
	^ true
]

{ #category : #accessing }
MbndImportedModulePosition >> line [
	^ 0
]

{ #category : #accessing }
MbndImportedModulePosition >> module [
	^ module
]

{ #category : #accessing }
MbndImportedModulePosition >> module: anObject [
	module := anObject
]

{ #category : #composition }
MbndImportedModulePosition >> originalSourceCode [
	^ ''
]

{ #category : #printing }
MbndImportedModulePosition >> printOn: aStream [
	aStream nextPutAll: 'imported module '; nextPutAll: module name
]

{ #category : #converting }
MbndImportedModulePosition >> sourceTextPosition [
	^ self
]

{ #category : #accessing }
MbndImportedModulePosition >> start [
	^ 0
]

{ #category : #accessing }
MbndImportedModulePosition >> stop [
	^ 0
]
