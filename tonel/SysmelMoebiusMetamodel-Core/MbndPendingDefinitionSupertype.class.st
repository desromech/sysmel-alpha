Class {
	#name : #MbndPendingDefinitionSupertype,
	#superclass : #MbndPendingDefinitionFragment,
	#instVars : [
		'type'
	],
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'public access' }
MbndPendingDefinitionSupertype >> evaluate [
	type setSupertypeFromDefinition: (MbndAstSemanticAnalyzer new 
		module: module;
		scope: scope;
		evaluateTypeExpression: node)
]

{ #category : #testing }
MbndPendingDefinitionSupertype >> isSupertypeDefinition [
	^ true
]

{ #category : #accessing }
MbndPendingDefinitionSupertype >> priority [
	^ 0
]

{ #category : #accessing }
MbndPendingDefinitionSupertype >> type [
	^ type
]

{ #category : #accessing }
MbndPendingDefinitionSupertype >> type: anObject [
	type := anObject
]
