Class {
	#name : #MbndFunctionReceiverArgumentVariable,
	#superclass : #MbndFunctionArgumentVariable,
	#instVars : [
		'superArgumentVariable'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #serialization }
MbndFunctionReceiverArgumentVariable class >> messagePackTypeName [
	^ #FunctionReceiverVariable
]

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

{ #category : #serialization }
MbndFunctionReceiverArgumentVariable >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder) , {
		#superArgumentVariable . superArgumentVariable encodeGraphForMessagePackWith: graphEncoder
	}
]

{ #category : #testing }
MbndFunctionReceiverArgumentVariable >> isFunctionReceiverArgumentVariable [
	^ true
]

{ #category : #serialization }
MbndFunctionReceiverArgumentVariable >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	superArgumentVariable := encodedFields at: #superArgumentVariable.
]
