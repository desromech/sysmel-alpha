Class {
	#name : #MbndFunctionArgumentVariable,
	#superclass : #MbndFunctionVariable,
	#instVars : [
		'argumentIndex'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #serialization }
MbndFunctionArgumentVariable class >> messagePackTypeName [
	^ #FunctionArgumentVariable
]

{ #category : #visiting }
MbndFunctionArgumentVariable >> accept: visitor [
	^ visitor visitFunctionArgumentVariable: self
]

{ #category : #accessing }
MbndFunctionArgumentVariable >> argumentIndex [
	^ argumentIndex
]

{ #category : #accessing }
MbndFunctionArgumentVariable >> argumentIndex: anObject [
	argumentIndex := anObject
]

{ #category : #'compile time evaluation' }
MbndFunctionArgumentVariable >> asCompileTimeValueReferenceOfType: referenceType withEvaluator: evaluator at: node [
	self assert: referenceType = self type.
	^ evaluator scope lookBindingStorageRecursively: self
]

{ #category : #'as yet unclassified' }
MbndFunctionArgumentVariable >> createStorageInFunctionActivationScope: scope withValue: activationValue [
	^ scope setBinding: self storage: activationValue
]

{ #category : #serialization }
MbndFunctionArgumentVariable >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder) , {
		#argumentIndex . argumentIndex
	}
]

{ #category : #testing }
MbndFunctionArgumentVariable >> isFunctionArgumentVariable [
	^ true
]

{ #category : #serialization }
MbndFunctionArgumentVariable >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	argumentIndex := encodedFields at: #argumentIndex.
]
