Class {
	#name : #MbndAstShaderEntryPointInfoReference,
	#superclass : #MbndAstSymbolReference,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstShaderEntryPointInfoReference >> accept: visitor [
	^ visitor visitShaderEntryPointInfoReferenceNode: self
]

{ #category : #testing }
MbndAstShaderEntryPointInfoReference >> isShaderEntryPointInfoReferenceNode [
	^ true
]
