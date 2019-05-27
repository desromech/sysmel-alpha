Class {
	#name : #MbndImplicitReceiverBoundSymbol,
	#superclass : #Object,
	#traits : 'TMbndSymbolBinding',
	#classTraits : 'TMbndSymbolBinding classTrait',
	#instVars : [
		'receiver'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #accessing }
MbndImplicitReceiverBoundSymbol >> receiver [
	^ receiver
]

{ #category : #accessing }
MbndImplicitReceiverBoundSymbol >> receiver: anObject [
	receiver := anObject
]
