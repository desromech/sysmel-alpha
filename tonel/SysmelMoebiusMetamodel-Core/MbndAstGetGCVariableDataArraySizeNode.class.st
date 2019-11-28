Class {
	#name : #MbndAstGetGCVariableDataArraySizeNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'container'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstGetGCVariableDataArraySizeNode >> accept: visitor [
	^ visitor visitGetGCVariableDataArraySizeNode: self
]

{ #category : #accessing }
MbndAstGetGCVariableDataArraySizeNode >> container [
	^ container
]

{ #category : #accessing }
MbndAstGetGCVariableDataArraySizeNode >> container: anObject [
	container := anObject
]

{ #category : #testing }
MbndAstGetGCVariableDataArraySizeNode >> isGetGCVariableDataArraySizeNode [
	^ true
]
