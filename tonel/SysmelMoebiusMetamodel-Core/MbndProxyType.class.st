"
I am a MoebiusBand proxy type. I am used to enforce module level isolation.
"
Class {
	#name : #MbndProxyType,
	#superclass : #Object,
	#traits : 'TMbndAbstractType',
	#classTraits : 'TMbndAbstractType classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndProxyType >> analyzeExpandedMessageNode: node with: analyzer [
	| method |
	method := self lookupOverloadedSelector: node selector value.
	method ifNotNil: [
		^ method analyzeExpandedMessageSendNode: node with: analyzer
	].
	
	"We failed to find the method, then ask the receiver type to interpret this message."
	^ self analyzeUnboundExpandedMessageSendNode: node with: analyzer

]

{ #category : #'semantic analysis' }
MbndProxyType >> analyzeInitializationFromCopyNode: node with: analyzer [
	self hasTrivialInitializationCopyingFrom ifTrue: [
		^ analyzer visitNode: (node asUnexpandedMessageSend
			selector: ((analyzer astBuilder literalSymbol: #assignValue:)
				position: node))
	].
	^ analyzer visitNode: node asExpandedMessageSend
]

{ #category : #testing }
MbndProxyType >> hasTrivialInitializationCopyingFrom [
	^ self hasTrivialInstanceInitializationCopyingFrom
]

{ #category : #testing }
MbndProxyType >> isPOD [
	^ self hasTrivialBasicInitialization and: [
	  self hasTrivialInitialization and: [
	  self hasTrivialFinalization and: [
	  self hasTrivialInitializationCopyingFrom and: [
	  self hasTrivialInitializationMovingFrom ]]]]
]

{ #category : #testing }
MbndProxyType >> isPODInstance [
	^ self hasTrivialInstanceBasicInitialization and: [
	  self hasTrivialInstanceInitialization and: [
	  self hasTrivialInstanceFinalization and: [
	  self hasTrivialInstanceInitializationCopyingFrom and: [
	  self hasTrivialInstanceInitializationMovingFrom ]]]]
]

{ #category : #'as yet unclassified' }
MbndProxyType >> programEntitionInformationData [
	^ self programEntityInformationData
]
