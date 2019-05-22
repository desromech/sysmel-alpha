Class {
	#name : #MbndAstMessageDefinitionNode,
	#superclass : #MbndAstAbstractFunctionDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMessageDefinitionNode >> accept: aVisitor [
	^ aVisitor visitMessageDefinitionNode: self
]

{ #category : #'as yet unclassified' }
MbndAstMessageDefinitionNode >> inferTemplateKindWithCompilationTarget: compilationTarget [
	^ compilationTarget messageTemplateType
]

{ #category : #testing }
MbndAstMessageDefinitionNode >> isMessageDefinitionNode [
	^ true
]

{ #category : #accessing }
MbndAstMessageDefinitionNode >> selector [
	^ prototype selector
]
