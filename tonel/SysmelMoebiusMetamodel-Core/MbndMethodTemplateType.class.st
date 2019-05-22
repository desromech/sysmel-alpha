Class {
	#name : #MbndMethodTemplateType,
	#superclass : #MbndTemplateType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndMethodTemplateType class >> typeName [
	^ #_MethodTemplateType
]

{ #category : #testing }
MbndMethodTemplateType >> isMethodTemplateType [
	^ true
]
