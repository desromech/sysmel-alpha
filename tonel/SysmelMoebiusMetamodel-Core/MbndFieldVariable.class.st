Class {
	#name : #MbndFieldVariable,
	#superclass : #MbndAbstractFieldVariable,
	#instVars : [
		'bits',
		'bitOffset',
		'bitMask'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #converting }
MbndFieldVariable >> asSymbolBoundWithReceiverBinding: receiverBinding [
	^ MbndFieldBoundWithReceiver new
		receiver: receiverBinding;
		field: self;
		yourself
]

{ #category : #accessing }
MbndFieldVariable >> bitMask [
	^ bitMask
]

{ #category : #accessing }
MbndFieldVariable >> bitMask: anObject [
	bitMask := anObject
]

{ #category : #accessing }
MbndFieldVariable >> bitOffset [
	^ bitOffset
]

{ #category : #accessing }
MbndFieldVariable >> bitOffset: anObject [
	bitOffset := anObject
]

{ #category : #accessing }
MbndFieldVariable >> bits [
	^ bits
]

{ #category : #accessing }
MbndFieldVariable >> bits: anObject [
	bits := anObject
]

{ #category : #testing }
MbndFieldVariable >> isFieldVariable [
	^ true
]
