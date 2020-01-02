Class {
	#name : #MbndAbstractVariable,
	#superclass : #Object,
	#traits : 'TMbndProgramEntity + TMbndVariable',
	#classTraits : 'TMbndProgramEntity classTrait + TMbndVariable classTrait',
	#instVars : [
		'parent',
		'name',
		'definitionNode',
		'definitionScope',
		'valueType',
		'minimalAlignment'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #'semantic analysis' }
MbndAbstractVariable >> analyzeReferenceNode: referenceNode with: analyzer [
	^ MbndAstVariableReference new
		binding: self;
		position: referenceNode;
		yourself
]

{ #category : #'compile time evaluation' }
MbndAbstractVariable >> asCompileTimeValueReferenceOfType: referenceType withEvaluator: evaluator at: node [
	^ (evaluator scope lookBindingStorageRecursively: self)
		ifNil: [ evaluator error: 'Invalid usage of local variable.' at: node]
		ifNotNil: [ :storage | storage asCompileTimeValueReferenceOfType: referenceType withEvaluator: evaluator at: node ]
]

{ #category : #accessing }
MbndAbstractVariable >> definitionNode [
	^ definitionNode
]

{ #category : #accessing }
MbndAbstractVariable >> definitionNode: anObject [
	definitionNode := anObject
]

{ #category : #accessing }
MbndAbstractVariable >> definitionPosition [
	^ definitionNode
]

{ #category : #accessing }
MbndAbstractVariable >> definitionScope [
	^ definitionScope
]

{ #category : #accessing }
MbndAbstractVariable >> definitionScope: anObject [
	definitionScope := anObject
]

{ #category : #'compile time evaluation' }
MbndAbstractVariable >> evaluateLocalDefinition: node withEvaluator: evaluator [
	| compileTimeVariable |
	compileTimeVariable := MbndCompileTimeVariable new
		name: node name;
		definitionNode: definitionNode;
		valueType: node binding valueType;
		type: node binding type;
		value: (evaluator visitNode: node initialValue);
		yourself.
	compileTimeVariable valueType isReferenceType ifFalse: [ 
		compileTimeVariable value: compileTimeVariable value copyForValueAssignment
	].

	"Add the store to the scope."
	evaluator scope setBinding: node binding storage: compileTimeVariable.
	^ compileTimeVariable asCompileTimeValueReferenceOfType: node type withEvaluator: evaluator at: node
]

{ #category : #accessing }
MbndAbstractVariable >> getPublicMetaBuilderFactoryList [
	^ { 
		#macro . MbndMacroMetaBuilder metaBuilderFactory.
		#method . MbndMethodMetaBuilder metaBuilderFactory.
	} ,  self getExtraMetaBuilderFactoryList
]

{ #category : #'as yet unclassified' }
MbndAbstractVariable >> hasPublicVisibility [
	^ false
]

{ #category : #accessing }
MbndAbstractVariable >> minimalAlignment [
	^ minimalAlignment
]

{ #category : #accessing }
MbndAbstractVariable >> minimalAlignment: anObject [
	minimalAlignment := anObject
]

{ #category : #accessing }
MbndAbstractVariable >> module [
	^ parent module
]

{ #category : #accessing }
MbndAbstractVariable >> name [
	^ name
]

{ #category : #accessing }
MbndAbstractVariable >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
MbndAbstractVariable >> parent [
	^ parent
]

{ #category : #accessing }
MbndAbstractVariable >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
MbndAbstractVariable >> type [
	^ valueType
]

{ #category : #accessing }
MbndAbstractVariable >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndAbstractVariable >> valueType: anObject [
	valueType := anObject
]
