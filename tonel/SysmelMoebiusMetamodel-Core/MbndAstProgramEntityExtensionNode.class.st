Class {
	#name : #MbndAstProgramEntityExtensionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'programEntity',
		'body'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstProgramEntityExtensionNode >> accept: visitor [
	^ visitor visitProgramEntityExtensionNode: self
]

{ #category : #accessing }
MbndAstProgramEntityExtensionNode >> body [
	^ body
]

{ #category : #accessing }
MbndAstProgramEntityExtensionNode >> body: anObject [
	body := anObject
]

{ #category : #testing }
MbndAstProgramEntityExtensionNode >> isProgramEntityExtensionNode [
	^ true
]

{ #category : #accessing }
MbndAstProgramEntityExtensionNode >> programEntity [
	^ programEntity
]

{ #category : #accessing }
MbndAstProgramEntityExtensionNode >> programEntity: anObject [
	programEntity := anObject
]
