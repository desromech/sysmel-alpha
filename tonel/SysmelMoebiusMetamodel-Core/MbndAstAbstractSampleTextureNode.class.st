Class {
	#name : #MbndAstAbstractSampleTextureNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'sampler',
		'texture',
		'texcoord'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractSampleTextureNode >> sampler [
	^ sampler
]

{ #category : #accessing }
MbndAstAbstractSampleTextureNode >> sampler: anObject [
	sampler := anObject
]

{ #category : #accessing }
MbndAstAbstractSampleTextureNode >> texcoord [
	^ texcoord
]

{ #category : #accessing }
MbndAstAbstractSampleTextureNode >> texcoord: anObject [
	texcoord := anObject
]

{ #category : #accessing }
MbndAstAbstractSampleTextureNode >> texture [
	^ texture
]

{ #category : #accessing }
MbndAstAbstractSampleTextureNode >> texture: anObject [
	texture := anObject
]
