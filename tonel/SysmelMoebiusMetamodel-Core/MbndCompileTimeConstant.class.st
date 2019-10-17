Class {
	#name : #MbndCompileTimeConstant,
	#superclass : #MbndAbstractCompileTimeConstant,
	#traits : 'TMbndFlagContainer + TMbndEntityWithVisibility',
	#classTraits : 'TMbndFlagContainer classTrait + TMbndEntityWithVisibility classTrait',
	#instVars : [
		'name',
		'parent',
		'valueNode',
		'valueScope',
		'evaluatedValue'
	],
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'as yet unclassified' }
MbndCompileTimeConstant >> accept: aVisitor [
	^ aVisitor visitCompileTimeConstant: self
]

{ #category : #'semantic analysis' }
MbndCompileTimeConstant >> analyzeReferenceNode: referenceNode with: analyzer [
	self ensureSemanticAnalysis.
	^ evaluatedValue asLiteralValueNode
]

{ #category : #'as yet unclassified' }
MbndCompileTimeConstant >> compilationTarget [
	^ parent compilationTarget
]

{ #category : #accessing }
MbndCompileTimeConstant >> defaultVisibilityMode [
	^ #public
]

{ #category : #'semantic analysis' }
MbndCompileTimeConstant >> ensureSemanticAnalysis [
	evaluatedValue ifNotNil: [ ^ self ].

	evaluatedValue := MbndAstSemanticAnalyzer new 
		module: self module;
		scope: valueScope;
		evaluateCompileTimeExpression: valueNode.

]

{ #category : #accessing }
MbndCompileTimeConstant >> immediateValue: aValue [
	evaluatedValue := aValue
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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
