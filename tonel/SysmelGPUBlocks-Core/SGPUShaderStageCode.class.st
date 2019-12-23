Class {
	#name : #SGPUShaderStageCode,
	#superclass : #Object,
	#instVars : [
		'spirVModule',
		'entryPointMetadata'
	],
	#classVars : [
		'Current'
	],
	#category : #'SysmelGPUBlocks-Core-Compilation'
}

{ #category : #accessing }
SGPUShaderStageCode >> entryPointMetadata [
	^ entryPointMetadata
]

{ #category : #accessing }
SGPUShaderStageCode >> entryPointMetadata: anObject [
	entryPointMetadata := anObject
]

{ #category : #accessing }
SGPUShaderStageCode >> entryPointName [
	^ entryPointMetadata name
]

{ #category : #accessing }
SGPUShaderStageCode >> spirVModule [
	^ spirVModule
]

{ #category : #accessing }
SGPUShaderStageCode >> spirVModule: anObject [
	spirVModule := anObject
]

{ #category : #accessing }
SGPUShaderStageCode >> stage [
	^ entryPointMetadata stage
]
