Class {
	#name : #MbndAstMacroMessageDefinitionNode,
	#superclass : #MbndAstAbstractFunctionDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMacroMessageDefinitionNode >> accept: aVisitor [
	^ aVisitor visitMacroMessageDefinitionNode: self
]

{ #category : #testing }
MbndAstMacroMessageDefinitionNode >> isMacroMessageDefinitionNode [
	^ true
]

{ #category : #accessing }
MbndAstMacroMessageDefinitionNode >> selector [
	^ prototype selector
]
