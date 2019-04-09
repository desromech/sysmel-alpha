Class {
	#name : #MbndMetaBuilderFactory,
	#superclass : #Object,
	#traits : 'TMbndSymbolBinding',
	#classTraits : 'TMbndSymbolBinding classTrait',
	#instVars : [
		'metaBuilderClass'
	],
	#category : #'MoebiusBandMetamodel-Core-MetaBuilder'
}

{ #category : #'semantic analysis' }
MbndMetaBuilderFactory >> analyzeReferenceNode: referenceNode with: analyzer [
	^ MbndAstMetaBuilderInstanceNode new
		instance: (metaBuilderClass new
			position: referenceNode;
			metaBuilderAnalyzer: analyzer;
			metaBuilderScope: analyzer scope;
			yourself);
		type: analyzer compilationTarget metaBuilderInstanceType;
		position: referenceNode;
		yourself
]

{ #category : #accessing }
MbndMetaBuilderFactory >> metaBuilderClass [
	^ metaBuilderClass
]

{ #category : #accessing }
MbndMetaBuilderFactory >> metaBuilderClass: anObject [
	metaBuilderClass := anObject
]
