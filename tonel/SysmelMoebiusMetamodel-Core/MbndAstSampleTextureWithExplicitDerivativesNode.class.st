Class {
	#name : #MbndAstSampleTextureWithExplicitDerivativesNode,
	#superclass : #MbndAstAbstractSampleTextureNode,
	#instVars : [
		'dtdx',
		'dtdy'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstSampleTextureWithExplicitDerivativesNode >> accept: visitor [
	^ visitor visitSampleTextureWithExplicitDerivativesNode: self
]

{ #category : #accessing }
MbndAstSampleTextureWithExplicitDerivativesNode >> dtdx [
	^ dtdx
]

{ #category : #accessing }
MbndAstSampleTextureWithExplicitDerivativesNode >> dtdx: anObject [
	dtdx := anObject
]

{ #category : #accessing }
MbndAstSampleTextureWithExplicitDerivativesNode >> dtdy [
	^ dtdy
]

{ #category : #accessing }
MbndAstSampleTextureWithExplicitDerivativesNode >> dtdy: anObject [
	dtdy := anObject
]

{ #category : #testing }
MbndAstSampleTextureWithExplicitDerivativesNode >> isSampleTextureWithExplicitDerivativesNode [
	^ true
]
