Class {
	#name : #MbndConcreteFunclet,
	#superclass : #MbndAbstractConcreteMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndConcreteFunclet class >> messagePackTypeName [
	^ #ConcreteFunclet
]

{ #category : #visiting }
MbndConcreteFunclet >> accept: visitor [
	^ visitor visitConcreteFunclet: self
]

{ #category : #accessing }
MbndConcreteFunclet >> argumentNodes [
	^ #()
]

{ #category : #accessing }
MbndConcreteFunclet >> contentNode [
	^ definitionNode
]

{ #category : #accessing }
MbndConcreteFunclet >> contentNode: aNode [
	self
		declarationPosition: aNode;
		definitionNode: aNode
]

{ #category : #accessing }
MbndConcreteFunclet >> definitionBody [
	^ definitionNode
]

{ #category : #'semantic analysis' }
MbndConcreteFunclet >> hasExplicitReturnStatement [
	^ false
]

{ #category : #'as yet unclassified' }
MbndConcreteFunclet >> inferResultValueType [
	self ensureSemanticAnalysis.
	self assert: self returnType isNotNil.
	^ self returnType
]

{ #category : #testing }
MbndConcreteFunclet >> isFunclet [
	^ true
]

{ #category : #'semantic analysis' }
MbndConcreteFunclet >> preprocessDefinitionBody: node [
	^ node lexicallyScoped
]

{ #category : #initialization }
MbndConcreteFunclet >> setArguments: newArguments returnType: returnType [
	| functionType |
	functionType := (self compilationTarget functionTypeWithArguments: (newArguments collect: [:each | each type]) returnType: returnType).
	self
		receiverType: self compilationTarget voidType;
		type: functionType;
		boundType: functionType.
]
