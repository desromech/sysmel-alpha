Class {
	#name : #MbndMacroMessageMethod,
	#superclass : #MbndAbstractMacro,
	#instVars : [
		'parent',
		'concreteMethod'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #accessing }
MbndMacroMessageMethod >> children [
	^ {concreteMethod}
]

{ #category : #accessing }
MbndMacroMessageMethod >> concreteMethod [
	^ concreteMethod
]

{ #category : #accessing }
MbndMacroMessageMethod >> concreteMethod: aConcreteMethod [
	self assert: aConcreteMethod parent isNil.
	self assert: concreteMethod isNil.
	
	concreteMethod := aConcreteMethod.
	concreteMethod parent: self.
	
]

{ #category : #'semantic analysis' }
MbndMacroMessageMethod >> enqueueDelayedSemanticAnalysis [
	super enqueueDelayedSemanticAnalysis.
	concreteMethod enqueueDelayedSemanticAnalysis
]

{ #category : #'as yet unclassified' }
MbndMacroMessageMethod >> expandMessageNode: node with: analyzer [
	| evaluator builder compilerObjectType nodeType result |
	evaluator := MbndAstEvaluator new module: analyzer module.
	builder := MbndAstBuilder forModule: analyzer module.
	compilerObjectType := self compilationTarget compilerObjectType.
	nodeType := self compilationTarget astNodeType.
	result := concreteMethod evaluateWithReceiver:
			(node receiver ifNotNil: [MbndValue value: node receiver type: nodeType])
		arguments: ({
			MbndValue value: builder type: compilerObjectType.
			MbndValue value: analyzer type: compilerObjectType.
		} , node arguments collect: [ :arg | MbndValue value: arg type: nodeType])
		withEvaluator: evaluator at: node.
	self assert: result type isASTNodeType.
	^ analyzer visitNode: result value
]

{ #category : #accessing }
MbndMacroMessageMethod >> module [
	^ parent module
]

{ #category : #accessing }
MbndMacroMessageMethod >> parent [
	^ parent
]

{ #category : #accessing }
MbndMacroMessageMethod >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
MbndMacroMessageMethod >> selector [
	^ concreteMethod name
]
