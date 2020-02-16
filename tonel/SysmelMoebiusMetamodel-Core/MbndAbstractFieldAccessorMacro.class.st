Class {
	#name : #MbndAbstractFieldAccessorMacro,
	#superclass : #MbndAbstractMacro,
	#instVars : [
		'field'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #converting }
MbndAbstractFieldAccessorMacro >> createMethodAccessorForReceiver: receiverType withSelector: accessorSelector [
]

{ #category : #accessing }
MbndAbstractFieldAccessorMacro >> field [
	^ field
]

{ #category : #accessing }
MbndAbstractFieldAccessorMacro >> field: anObject [
	field := anObject
]
