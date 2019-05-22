Class {
	#name : #MbndFunctionTemplateType,
	#superclass : #MbndTemplateType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndFunctionTemplateType class >> typeName [
	^ #_FunctionTemplateType
]

{ #category : #testing }
MbndFunctionTemplateType >> isFunctionTemplateType [
	^ true
]
