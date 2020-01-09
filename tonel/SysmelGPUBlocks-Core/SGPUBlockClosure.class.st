Class {
	#name : #SGPUBlockClosure,
	#superclass : #Object,
	#instVars : [
		'cpuBlock',
		'concreteMethod',
		'compilationEnvironment'
	],
	#category : #'SysmelGPUBlocks-Core-Blocks'
}

{ #category : #'as yet unclassified' }
SGPUBlockClosure class >> for: blockClosure withTypeExpression: typeExpression [
	^ SGPUCompilationEnvironment current compileBlockClosure: blockClosure withTypeExpression: typeExpression
]

{ #category : #converting }
SGPUBlockClosure >> asBinaryReductionShaderClass [
	^ self constructShaderClassWithTemplateNamed: 'BinaryReductionShader'.
]

{ #category : #converting }
SGPUBlockClosure >> asBinaryReductionShaderMethod [
	^ self asBinaryReductionShaderClass lookupSymbol: #main.
]

{ #category : #converting }
SGPUBlockClosure >> asBinaryReductionShaderStageCode [
	^ compilationEnvironment shaderStageCodeFor: (self asBinaryReductionShaderMethod).
]

{ #category : #converting }
SGPUBlockClosure >> asCollectionMapShaderClass [
	^ self constructShaderClassWithTemplateNamed: 'CollectionMapShader'.
]

{ #category : #converting }
SGPUBlockClosure >> asCollectionMapShaderMethod [
	^ self asCollectionMapShaderClass lookupSymbol: #main.
]

{ #category : #converting }
SGPUBlockClosure >> asCollectionMapShaderStageCode [
	^ compilationEnvironment shaderStageCodeFor: (self asCollectionMapShaderMethod).
]

{ #category : #accessing }
SGPUBlockClosure >> compilationEnvironment [
	^ compilationEnvironment
]

{ #category : #accessing }
SGPUBlockClosure >> compilationEnvironment: anObject [
	compilationEnvironment := anObject
]

{ #category : #accessing }
SGPUBlockClosure >> concreteMethod [
	^ concreteMethod
]

{ #category : #accessing }
SGPUBlockClosure >> concreteMethod: anObject [
	concreteMethod := anObject
]

{ #category : #converting }
SGPUBlockClosure >> constructShaderClassWithTemplateNamed: templateName [
	^ compilationEnvironment getShaderTemplateNamed: templateName instanceWithArguments: { concreteMethod }
]

{ #category : #accessing }
SGPUBlockClosure >> cpuBlock [
	^ cpuBlock
]

{ #category : #accessing }
SGPUBlockClosure >> cpuBlock: anObject [
	cpuBlock := anObject
]

{ #category : #evaluating }
SGPUBlockClosure >> cull: firstArg [
	^ cpuBlock cull: firstArg
]

{ #category : #evaluating }
SGPUBlockClosure >> cull: firstArg cull: secondArg [
	^ cpuBlock cull: firstArg cull: secondArg
]

{ #category : #evaluating }
SGPUBlockClosure >> cull: firstArg cull: secondArg cull: thirdArg [
	^ cpuBlock cull: firstArg cull: secondArg cull: thirdArg
]

{ #category : #evaluating }
SGPUBlockClosure >> cull: firstArg cull: secondArg cull: thirdArg cull: fourthArg [
	^ cpuBlock cull: firstArg cull: secondArg cull: thirdArg cull: fourthArg
]

{ #category : #accessing }
SGPUBlockClosure >> functionType [
	^ self concreteMethod type
]

{ #category : #testing }
SGPUBlockClosure >> isSGPUBlockClosure [
	^ true
]

{ #category : #accessing }
SGPUBlockClosure >> returnType [
	^ self functionType returnType
]

{ #category : #evaluating }
SGPUBlockClosure >> value [
	^ cpuBlock value
]

{ #category : #evaluating }
SGPUBlockClosure >> value: firstArg [
	^ cpuBlock value: firstArg
]

{ #category : #evaluating }
SGPUBlockClosure >> value: firstArg value: secondArg [
	^ cpuBlock value: firstArg value: secondArg
]

{ #category : #evaluating }
SGPUBlockClosure >> value: firstArg value: secondArg value: thirdArg [
	^ cpuBlock value: firstArg value: secondArg value: thirdArg
]

{ #category : #evaluating }
SGPUBlockClosure >> value: firstArg value: secondArg value: thirdArg value: fourthArg [
	^ cpuBlock value: firstArg value: secondArg value: thirdArg value: fourthArg
]

{ #category : #evaluating }
SGPUBlockClosure >> valueWithArguments: arguments [
	^ cpuBlock valueWithArguments: arguments
]
