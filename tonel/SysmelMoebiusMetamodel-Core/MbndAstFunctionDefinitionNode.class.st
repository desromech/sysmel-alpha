Class {
	#name : #MbndAstFunctionDefinitionNode,
	#superclass : #MbndAstAbstractFunctionDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstFunctionDefinitionNode >> accept: aVisitor [
	^ aVisitor visitFunctionDefinitionNode: self
]

{ #category : #'as yet unclassified' }
MbndAstFunctionDefinitionNode >> inferTemplateKindWithCompilationTarget: compilationTarget [
	^ compilationTarget functionTemplateType
]

{ #category : #testing }
MbndAstFunctionDefinitionNode >> isFunctionDefinitionNode [
	^ true
]

{ #category : #accessing }
MbndAstFunctionDefinitionNode >> name [
	^ prototype name
]
