Class {
	#name : #SYMLShaderStageInputVariable,
	#superclass : #SYMLAbstractShaderStageVariable,
	#category : #'Sysmel-Metamodel-Shader'
}

{ #category : #'code generation' }
SYMLShaderStageInputVariable >> getSpirVShaderInterfaceBlock [
	^ parent spvInputVariable
]

{ #category : #testing }
SYMLShaderStageInputVariable >> isInput [
	^ true
]

{ #category : #'as yet unclassified' }
SYMLShaderStageInputVariable >> spirvStorage [
	^ SLVMType inputStorage
]