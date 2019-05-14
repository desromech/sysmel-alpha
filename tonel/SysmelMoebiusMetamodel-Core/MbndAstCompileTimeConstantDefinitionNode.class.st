Class {
	#name : #MbndAstCompileTimeConstantDefinitionNode,
	#superclass : #MbndAstSymbolDefinition,
	#instVars : [
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstCompileTimeConstantDefinitionNode >> accept: aVisitor [
	^ aVisitor visitCompileTimeConstantDefinitionNode: self
]

{ #category : #testing }
MbndAstCompileTimeConstantDefinitionNode >> isCompileTimeConstantDefinitionNode [
	^ true
]

{ #category : #accessing }
MbndAstCompileTimeConstantDefinitionNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstCompileTimeConstantDefinitionNode >> value: anObject [
	value := anObject
]
