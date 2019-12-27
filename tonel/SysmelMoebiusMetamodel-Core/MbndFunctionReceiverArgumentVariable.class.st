Class {
	#name : #MbndFunctionReceiverArgumentVariable,
	#superclass : #MbndFunctionArgumentVariable,
	#instVars : [
		'superArgumentVariable'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #visiting }
MbndFunctionReceiverArgumentVariable >> accept: visitor [
	^ visitor visitFunctionReceiverArgumentVariable: self
]

{ #category : #converting }
MbndFunctionReceiverArgumentVariable >> asSuperArgumentVariable [
	^ superArgumentVariable ifNil: [superArgumentVariable := MbndFunctionSuperReceiverArgumentVariable new
		name: #super;
		parent: parent;
		valueType: valueType asSuperArgumentType;
		vanillaReceiverVariable: self;
		yourself
	]
]

{ #category : #testing }
MbndFunctionReceiverArgumentVariable >> isFunctionReceiverArgumentVariable [
	^ true
]
