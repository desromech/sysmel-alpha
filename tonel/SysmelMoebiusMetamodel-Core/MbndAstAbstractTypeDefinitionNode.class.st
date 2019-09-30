Class {
	#name : #MbndAstAbstractTypeDefinitionNode,
	#superclass : #MbndAstAbstractProgramEntityDefinitionNode,
	#instVars : [
		'body'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractTypeDefinitionNode >> body [
	^ body
]

{ #category : #accessing }
MbndAstAbstractTypeDefinitionNode >> body: anObject [
	body := anObject
]

{ #category : #'as yet unclassified' }
MbndAstAbstractTypeDefinitionNode >> inferTemplateKindWithCompilationTarget: compilationTarget [
	^ compilationTarget typeTemplateType
]

{ #category : #testing }
MbndAstAbstractTypeDefinitionNode >> isAbstractTypeDefinitionNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstAbstractTypeDefinitionNode >> superTypeNode [
	^ nil
]

{ #category : #'as yet unclassified' }
MbndAstAbstractTypeDefinitionNode >> superTypeNode: aNode [
]
