Class {
	#name : #SYMLNamespaceScope,
	#superclass : #SYMLAbstractScope,
	#instVars : [
		'namespace'
	],
	#category : #Sysmel-Metamodel-Semantic
}

{ #category : #accessing }
SYMLNamespaceScope >> compilationTarget [
	^ namespace compilationTarget
]

{ #category : #adding }
SYMLNamespaceScope >> findProgramEntityDefinitionScopeFrom: startingPoint [
	^ self
]

{ #category : #testing }
SYMLNamespaceScope >> hasSupportForOverloadedFunctions [
	^ true
]

{ #category : #variables }
SYMLNamespaceScope >> lookSymbol: identifier ifPresent: aBlock [
	^ namespace lookSymbol: identifier ifPresent: aBlock
]

{ #category : #variables }
SYMLNamespaceScope >> lookSymbol: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock [
	^ namespace lookSymbol: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock
]

{ #category : #'meta methods' }
SYMLNamespaceScope >> metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	^ namespace metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
]

{ #category : #accessing }
SYMLNamespaceScope >> namespace [
	^ namespace
]

{ #category : #accessing }
SYMLNamespaceScope >> namespace: anObject [
	namespace := anObject
]

{ #category : #'as yet unclassified' }
SYMLNamespaceScope >> programEntity [
	^ namespace
]
