Class {
	#name : #MbndMetaBuilderInstanceType,
	#superclass : #MbndBasicType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndMetaBuilderInstanceType class >> typeName [
	^ #_MetaBuilderInstanceType
]

{ #category : #'semantic analysis' }
MbndMetaBuilderInstanceType >> analyzeUnexpandedMessageSendNode: node with: analyzer [
	self assert: node receiver isMetaBuilderInstanceNode.
	^ node receiver instance analyzeUnexpandedMessageSendNode: node with: analyzer
]

{ #category : #'testing methods' }
MbndMetaBuilderInstanceType >> isMetaBuilderInstanceType [
	^ true
]
