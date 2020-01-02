Class {
	#name : #MbndAstMacroMessageMethodDefinitionNode,
	#superclass : #MbndAstAbstractFunctionDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMacroMessageMethodDefinitionNode >> accept: aVisitor [
	^ aVisitor visitMacroMessageDefinitionNode: self
]

{ #category : #testing }
MbndAstMacroMessageMethodDefinitionNode >> isMacroMessageMethodDefinitionNode [
	^ true
]

{ #category : #accessing }
MbndAstMacroMessageMethodDefinitionNode >> selector [
	^ prototype selector
]
