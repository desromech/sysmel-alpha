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

{ #category : #'as yet unclassified' }
SYMLShaderStageOutputVariable >> spirvStorage [
	^ SLVMType outputStorage
]
