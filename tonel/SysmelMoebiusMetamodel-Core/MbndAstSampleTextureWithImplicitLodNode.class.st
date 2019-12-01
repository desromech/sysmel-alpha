Class {
	#name : #MbndAstSampleTextureWithImplicitLodNode,
	#superclass : #MbndAstAbstractSampleTextureNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstSampleTextureWithImplicitLodNode >> accept: visitor [
	^ visitor visitSampleTextureWithImplicitLodNode: self
]

{ #category : #testing }
MbndAstSampleTextureWithImplicitLodNode >> isSampleTextureWithImplicitLodNode [
	^ true
]
