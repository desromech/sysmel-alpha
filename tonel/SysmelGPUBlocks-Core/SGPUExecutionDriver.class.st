Class {
	#name : #SGPUExecutionDriver,
	#superclass : #Object,
	#classVars : [
		'CurrentDriver',
		'CurrentSession'
	],
	#category : #'SysmelGPUBlocks-Core-Driver'
}

{ #category : #accessing }
SGPUExecutionDriver class >> checkSession [
	CurrentSession == Smalltalk session ifTrue: [ ^ self ].
	CurrentDriver := self findDriver.
	CurrentSession := Smalltalk session
]

{ #category : #accessing }
SGPUExecutionDriver class >> current [
	self checkSession.
	^ CurrentDriver
]

{ #category : #accessing }
SGPUExecutionDriver class >> findDriver [
	self withAllSubclassesDo: [ :sc |
		sc isAvailable ifTrue: [ ^ sc new ]
	].
	^ SGPUCPUExecutionDriver new
]

{ #category : #testing }
SGPUExecutionDriver class >> isAvailable [
	^ false
]

{ #category : #accessing }
SGPUExecutionDriver class >> reset [
	CurrentSession := nil.
	CurrentDriver := nil.
]

{ #category : #'as yet unclassified' }
SGPUExecutionDriver >> enqueueComputationWithInputBuffers: inputBuffers outputBuffers: outputBuffers pushConstants: pushConstant
computeShaderStage: shaderStageCode globalSize: size
cpuFallbackWith: cpuFallbackBlock [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SGPUExecutionDriver >> ensureManagedDataArrayIsInCPU: managedDataArray [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SGPUExecutionDriver >> ensureManagedDataArrayIsInGPU: managedDataArray [
	self subclassResponsibility
]
