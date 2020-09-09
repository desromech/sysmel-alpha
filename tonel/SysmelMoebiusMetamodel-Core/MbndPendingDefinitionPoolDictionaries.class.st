Class {
	#name : #MbndPendingDefinitionPoolDictionaries,
	#superclass : #MbndPendingDefinitionFragment,
	#instVars : [
		'type'
	],
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'public access' }
MbndPendingDefinitionPoolDictionaries >> evaluate [
	| poolDictionaries |
	poolDictionaries := (MbndAstSemanticAnalyzer new 
		module: module;
		scope: scope;
		evaluateCompileTimeExpression: node) unwrapMbndValue.
	poolDictionaries isCollection ifFalse: [
		poolDictionaries := {poolDictionaries}
	] ifTrue: [
		poolDictionaries := (poolDictionaries collect: [ :each | each unwrapMbndValue ]) asArray
	].

	poolDictionaries detect: [ :each | each isMbndType not ] ifFound: [
		self error: 'Invalid parameter specified as a pool dictionary. Specified pools: {1}.' format: { poolDictionaries asString } at: node 
	].
	type addPoolDictionaries: poolDictionaries
]

{ #category : #testing }
MbndPendingDefinitionPoolDictionaries >> isPoolDictionaries [
	^ false
]

{ #category : #accessing }
MbndPendingDefinitionPoolDictionaries >> priority [
	^ 3
]

{ #category : #accessing }
MbndPendingDefinitionPoolDictionaries >> type [
	^ type
]

{ #category : #accessing }
MbndPendingDefinitionPoolDictionaries >> type: anObject [
	type := anObject
]
