Class {
	#name : #MbndAbstractVariable,
	#superclass : #Object,
	#traits : 'TMbndProgramEntity + TMbndVariable',
	#classTraits : 'TMbndProgramEntity classTrait + TMbndVariable classTrait',
	#instVars : [
		'parent',
		'name',
		'definitionNode',
		'valueType'
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

{ #category : #'compile time evaluation' }
MbndAbstractVariable >> evaluateLocalDefinition: node withEvaluator: evaluator [
	| compileTimeVariable |
	compileTimeVariable := MbndCompileTimeVariable new
		name: node name;
		valueType: node binding valueType;
		type: node binding type;
		value: (evaluator visitNode: node initialValue);
		yourself.
	"Add the store to the scope."
	evaluator scope setBinding: node binding storage: compileTimeVariable.
	^ compileTimeVariable asCompileTimeValueReferenceOfType: node type withEvaluator: evaluator at: node
]

{ #category : #'as yet unclassified' }
MbndAbstractVariable >> hasPublicVisibility [
	^ false
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
