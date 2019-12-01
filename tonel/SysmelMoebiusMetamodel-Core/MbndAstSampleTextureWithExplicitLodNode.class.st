Class {
	#name : #MbndAstSampleTextureWithExplicitLodNode,
	#superclass : #MbndAstAbstractSampleTextureNode,
	#instVars : [
		'lod'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstSampleTextureWithExplicitLodNode >> accept: visitor [
	^ visitor visitSampleTextureWithExplicitLodNode: self
]

{ #category : #testing }
MbndAstSampleTextureWithExplicitLodNode >> isSampleTextureWithExplicitLodNode [
	^ true
]

{ #category : #accessing }
MbndAstSampleTextureWithExplicitLodNode >> lod [
	^ lod
]

{ #category : #accessing }
MbndAstSampleTextureWithExplicitLodNode >> lod: anObject [
	lod := anObject
]
