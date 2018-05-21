Class {
	#name : #SYMLShaderStageOutputVariable,
	#superclass : #SYMLAbstractShaderStageVariable,
	#category : #'Sysmel-Metamodel-Shader'
}

{ #category : #'code generation' }
SYMLShaderStageOutputVariable >> getSpirVShaderInterfaceBlock [
	^ parent spvOutputVariable
]

{ #category : #testing }
SYMLShaderStageOutputVariable >> isOutput [
	^ true
]
