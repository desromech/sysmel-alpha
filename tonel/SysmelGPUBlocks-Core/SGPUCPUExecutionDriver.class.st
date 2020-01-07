Class {
	#name : #SGPUCPUExecutionDriver,
	#superclass : #SGPUExecutionDriver,
	#category : #'SysmelGPUBlocks-Core-Driver'
}

{ #category : #'as yet unclassified' }
SGPUCPUExecutionDriver >> enqueueComputationWithInputBuffers: inputBuffers outputBuffers: outputBuffers pushConstants: pushConstant
computeShaderStage: shaderStageCode globalGridSize: gridSize
cpuFallbackWith: cpuFallbackBlock [
	cpuFallbackBlock value
]

{ #category : #'as yet unclassified' }
SGPUCPUExecutionDriver >> enqueueComputationWithInputBuffers: inputBuffers outputBuffers: outputBuffers pushConstants: pushConstant
computeShaderStage: shaderStageCode globalSize: size
cpuFallbackWith: cpuFallbackBlock [
	cpuFallbackBlock value
]

{ #category : #'as yet unclassified' }
SGPUCPUExecutionDriver >> ensureManagedDataArrayIsInCPU: managedDataArray [
	managedDataArray markSynchronizedCopies
]

{ #category : #'as yet unclassified' }
SGPUCPUExecutionDriver >> ensureManagedDataArrayIsInGPU: managedDataArray [
	managedDataArray isNotYetGenerated ifTrue: [ managedDataArray ensureInCPU ].
	managedDataArray markSynchronizedCopies
]
