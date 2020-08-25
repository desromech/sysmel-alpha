Class {
	#name : #MbndAstSampleTextureWithDepthReferenceNode,
	#superclass : #MbndAstAbstractSampleTextureNode,
	#instVars : [
		'depthReference'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstSampleTextureWithDepthReferenceNode >> accept: visitor [
	^ visitor visitSampleTextureWithDepthReferenceNode: self
]

{ #category : #accessing }
MbndAstSampleTextureWithDepthReferenceNode >> depthReference [
	^ depthReference
]

{ #category : #accessing }
MbndAstSampleTextureWithDepthReferenceNode >> depthReference: anObject [
	depthReference := anObject
]

{ #category : #testing }
MbndAstSampleTextureWithDepthReferenceNode >> isSampleTextureWithDepthReferenceNode [
	^ true
]
