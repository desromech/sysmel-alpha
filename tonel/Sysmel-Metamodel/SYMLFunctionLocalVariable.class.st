Class {
	#name : #SYMLFunctionLocalVariable,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'name',
		'type',
		'valueType',
		'ssaValue',
		'function'
	],
	#category : #Sysmel-Metamodel-Program
}

{ #category : #'meta evaluation' }
SYMLFunctionLocalVariable >> evaluateReferenceAt: position [
	self error: 'TODO: Implement evaluation of local variables.'
]

{ #category : #'meta evaluation' }
SYMLFunctionLocalVariable >> evaluateTypeAt: position [
	^ type
]

{ #category : #accessing }
SYMLFunctionLocalVariable >> function [
	^ function
]

{ #category : #accessing }
SYMLFunctionLocalVariable >> function: anObject [
	function := anObject
]

{ #category : #'code generation' }
SYMLFunctionLocalVariable >> generateSSALocalWithBuilder: builder [
	self assert: ssaValue isNil.
	ssaValue := builder allocaBuilder alloca: valueType ssaType name: (name ifNil: [ builder function generateSymbol])
]

{ #category : #'meta evaluation' }
SYMLFunctionLocalVariable >> generateSSAReferenceWith: builder [
	self assert: ssaValue isNotNil.
	^ ssaValue
]

{ #category : #accessing }
SYMLFunctionLocalVariable >> name [
	^ name
]

{ #category : #accessing }
SYMLFunctionLocalVariable >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SYMLFunctionLocalVariable >> ssaValue [
	^ ssaValue
]

{ #category : #accessing }
SYMLFunctionLocalVariable >> type [
	^ type
]

{ #category : #accessing }
SYMLFunctionLocalVariable >> valueType [
	^ valueType
]

{ #category : #accessing }
SYMLFunctionLocalVariable >> valueType: anObject [
	valueType := anObject.
	type := valueType ref.
]
