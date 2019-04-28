Class {
	#name : #MbndCompileTimeConstant,
	#superclass : #Object,
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#instVars : [
		'name',
		'parent',
		'valueNode',
		'valueScope',
		'evaluatedValue'
	],
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'semantic analysis' }
MbndCompileTimeConstant >> analyzeReferenceNode: referenceNode with: analyzer [
	self ensureSemanticAnalysis.
	^ evaluatedValue asLiteralValueNode
]

{ #category : #accessing }
MbndCompileTimeConstant >> compilationTarget [
	^ parent compilationTarget
]

{ #category : #'semantic analysis' }
MbndCompileTimeConstant >> ensureSemanticAnalysis [
	evaluatedValue ifNotNil: [ ^ self ].

	evaluatedValue := MbndAstSemanticAnalyzer new 
		module: self module;
		scope: valueScope;
		evaluateCompileTimeExpression: valueNode.

]

{ #category : #testing }
MbndCompileTimeConstant >> isCompileTimeConstant [
	^ true
]

{ #category : #accessing }
MbndCompileTimeConstant >> module [
	^ parent module
]

{ #category : #accessing }
MbndCompileTimeConstant >> name [
	^ name
]

{ #category : #accessing }
MbndCompileTimeConstant >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MbndCompileTimeConstant >> parent [
	^ parent
]

{ #category : #accessing }
MbndCompileTimeConstant >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
MbndCompileTimeConstant >> valueNode [
	^ valueNode
]

{ #category : #accessing }
MbndCompileTimeConstant >> valueNode: anObject [
	valueNode := anObject
]

{ #category : #accessing }
MbndCompileTimeConstant >> valueScope [
	^ valueScope
]

{ #category : #accessing }
MbndCompileTimeConstant >> valueScope: anObject [
	valueScope := anObject
]
