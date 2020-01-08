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
SGPUExecutionDriver class >> current: aCurrentDriver [
	CurrentSession := Smalltalk session.
	CurrentDriver := aCurrentDriver
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
computeShaderStage: shaderStageCode globalGridSize: gridSize
cpuFallbackWith: cpuFallbackBlock [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SGPUExecutionDriver >> enqueueComputationWithInputBuffers: inputBuffers outputBuffers: outputBuffers pushConstants: pushConstant
computeShaderStage: shaderStageCode globalSize: size
cpuFallbackWith: cpuFallbackBlock [
	| gridSize localSize blockSize requiredBlocks gridSizeX gridSizeY gridSizeZ |
	localSize := shaderStageCode localSize.
	blockSize := localSize first * localSize second * localSize third.
	requiredBlocks := (size + blockSize - 1) // blockSize.
	
	requiredBlocks <= 65535 ifTrue: [
		gridSize := { requiredBlocks . 1 . 1 }.
	] ifFalse: [
		requiredBlocks <= "65535*65535" 4294836225 ifTrue: [
			gridSizeX := requiredBlocks sqrt ceiling.
			gridSizeY := (requiredBlocks + gridSizeX - 1) // gridSizeX.
			self assert: gridSizeX <= 65535.
			self assert: gridSizeY <= 65535.
			self assert: gridSizeX*gridSizeY >= requiredBlocks.
			gridSize := { gridSizeX . gridSizeY . 1 }.
		] ifFalse: [
			self assert: requiredBlocks <= 65535*65535*65535.
			gridSizeX := (requiredBlocks raisedTo: 1.0/3.0) ceiling.
			gridSizeY := gridSizeX.
			gridSizeZ := (requiredBlocks + (gridSizeX*gridSizeY) - 1) // (gridSizeX*gridSizeX*gridSizeY).
			self assert: gridSizeX <= 65535.
			self assert: gridSizeY <= 65535.
			self assert: gridSizeZ <= 65535.
			self assert: gridSizeX*gridSizeY*gridSizeZ >= requiredBlocks.
			gridSize := { gridSizeX . gridSizeY . gridSizeZ }.
		]
	].
	
	^ self enqueueComputationWithInputBuffers: inputBuffers outputBuffers: outputBuffers pushConstants: pushConstant
computeShaderStage: shaderStageCode globalGridSize: gridSize
cpuFallbackWith: cpuFallbackBlock
]

{ #category : #'as yet unclassified' }
SGPUExecutionDriver >> ensureManagedDataArrayIsInCPU: managedDataArray [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SGPUExecutionDriver >> ensureManagedDataArrayIsInGPU: managedDataArray [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SGPUExecutionDriver >> finishPendingComputations [
]

{ #category : #'as yet unclassified' }
SGPUExecutionDriver >> flushPendingComputations [
]
