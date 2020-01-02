Class {
	#name : #MbndAstMessageMethodDefinitionNode,
	#superclass : #MbndAstAbstractFunctionDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMessageMethodDefinitionNode >> accept: aVisitor [
	^ aVisitor visitMessageDefinitionNode: self
]

{ #category : #'as yet unclassified' }
MbndAstMessageMethodDefinitionNode >> inferTemplateKindWithCompilationTarget: compilationTarget [
	^ compilationTarget messageTemplateType
]

{ #category : #testing }
MbndAstMessageMethodDefinitionNode >> isMessageMethodDefinitionNode [
	^ true
]

{ #category : #running }
MbndAstMessageMethodDefinitionNode >> override [
	<compileTime>
	prototype := prototype copy override
]

{ #category : #accessing }
MbndAstMessageMethodDefinitionNode >> selector [
	^ prototype selector
]

{ #category : #running }
MbndAstMessageMethodDefinitionNode >> virtual [
	<compileTime>
	prototype := prototype copy virtual
]
