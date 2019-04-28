Class {
	#name : #MbndNamespace,
	#superclass : #MbndAbstractNamespace,
	#traits : 'TMbndNamespaceLikeSymbolContainer',
	#classTraits : 'TMbndNamespaceLikeSymbolContainer classTrait',
	#instVars : [
		'parent',
		'name',
		'module'
	],
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'semantic analysis' }
MbndNamespace >> analyzeReferenceNode: referenceNode with: analyzer [
	^ self asLiteralValueNode
]

{ #category : #'semantic analysis' }
MbndNamespace >> asLiteralValueNode [
	^ MbndAstLiteralValueNode new
		value: self;
		type: self type;
		yourself
]

{ #category : #accessing }
MbndNamespace >> module [
	^ module
]

{ #category : #accessing }
MbndNamespace >> module: anObject [
	module := anObject
]

{ #category : #accessing }
MbndNamespace >> name [
	^ name
]

{ #category : #accessing }
MbndNamespace >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MbndNamespace >> parent [
	^ parent
]

{ #category : #accessing }
MbndNamespace >> parent: anObject [
	parent := anObject
]

{ #category : #'semantic analysis' }
MbndNamespace >> type [
	^ self compilationTarget namespaceType
]
