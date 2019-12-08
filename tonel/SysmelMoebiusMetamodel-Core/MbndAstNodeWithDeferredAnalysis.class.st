Class {
	#name : #MbndAstNodeWithDeferredAnalysis,
	#superclass : #MbndAstSpecificCastNode,
	#instVars : [
		'node',
		'analyzer',
		'analysisBlock'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstNodeWithDeferredAnalysis >> accept: visitor [
	^ visitor visitNodeWithDeferredAnalysis: self
]

{ #category : #accessing }
MbndAstNodeWithDeferredAnalysis >> analysisBlock [
	^ analysisBlock
]

{ #category : #accessing }
MbndAstNodeWithDeferredAnalysis >> analysisBlock: anObject [
	analysisBlock := anObject
]

{ #category : #accessing }
MbndAstNodeWithDeferredAnalysis >> analyzer [
	^ analyzer
]

{ #category : #accessing }
MbndAstNodeWithDeferredAnalysis >> analyzer: anObject [
	analyzer := anObject
]

{ #category : #'public access' }
MbndAstNodeWithDeferredAnalysis >> asAnalyzedNode [
	^ analysisBlock value: node value: analyzer
]

{ #category : #'public access' }
MbndAstNodeWithDeferredAnalysis >> evaluate [
	^ analyzer evaluateCompileTimeExpression: self asAnalyzedNode
]

{ #category : #testing }
MbndAstNodeWithDeferredAnalysis >> isNodeWithDeferredAnalysis [
	^ true
]

{ #category : #accessing }
MbndAstNodeWithDeferredAnalysis >> node [
	^ node
]

{ #category : #accessing }
MbndAstNodeWithDeferredAnalysis >> node: anObject [
	node := anObject
]
