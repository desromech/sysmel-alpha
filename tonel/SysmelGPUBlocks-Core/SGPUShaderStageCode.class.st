Class {
	#name : #SGPUShaderStageCode,
	#superclass : #Object,
	#instVars : [
		'spirVModule',
		'entryPointMetadata',
		'localSize',
		'localBlockSize'
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
SGPUShaderStageCode >> localBlockSize [
	^ localBlockSize ifNil: [localBlockSize := self localSize first * self localSize second * self localSize third]
]

{ #category : #accessing }
SGPUShaderStageCode >> localSize [
	^ localSize ifNil: [ localSize := {
		entryPointMetadata properties at: #localSizeX.
		entryPointMetadata properties at: #localSizeY.
		entryPointMetadata properties at: #localSizeZ.
	}]
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
