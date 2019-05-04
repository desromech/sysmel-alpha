Class {
	#name : #MbndAstCompileTimeConstantDefinitionNode,
	#superclass : #MbndAstSymbolDefinition,
	#instVars : [
		'value',
		'ownerProgramEntity'
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
MbndAstCompileTimeConstantDefinitionNode >> ownerProgramEntity [
	^ ownerProgramEntity
]

{ #category : #accessing }
MbndAstCompileTimeConstantDefinitionNode >> ownerProgramEntity: anObject [
	ownerProgramEntity := anObject
]

{ #category : #accessing }
MbndAstCompileTimeConstantDefinitionNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstCompileTimeConstantDefinitionNode >> value: anObject [
	value := anObject
]
