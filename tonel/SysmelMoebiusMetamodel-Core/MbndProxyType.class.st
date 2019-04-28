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
