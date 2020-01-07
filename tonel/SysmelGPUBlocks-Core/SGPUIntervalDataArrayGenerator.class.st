Class {
	#name : #SGPUIntervalDataArrayGenerator,
	#superclass : #SGPUDataArrayGenerator,
	#instVars : [
		'first',
		'increment'
	],
	#category : #'SysmelGPUBlocks-Core-Data'
}

{ #category : #accessing }
SGPUIntervalDataArrayGenerator >> first [
	^ first
]

{ #category : #accessing }
SGPUIntervalDataArrayGenerator >> first: anObject [
	first := anObject
]

{ #category : #'as yet unclassified' }
SGPUIntervalDataArrayGenerator >> generateDataInGPUManagedBuffer: managedBuffer [
	| compilationEnvironment shaderStageCode elementType pushConstants pointer |
	compilationEnvironment := managedBuffer compilationEnvironment.
	shaderStageCode := compilationEnvironment intervalGenerationShaderStageCodeForValueType: managedBuffer mbndType.
	
	elementType := managedBuffer rawCpuData elementType.
	pushConstants := ByteArray new: 32.
	pushConstants unsignedLongAt: 1 put: managedBuffer size.
	"pushConstants unsignedLongAt: 5 put: managedBuffer size."
	pointer := SLVMInternalObjectPointer object: pushConstants offset: 8.
	elementType write: first intoPointer: pointer.
	elementType write: increment intoPointer: (pointer offset: 8 + elementType size; yourself).
	
	SGPUExecutionDriver current
		enqueueComputationWithInputBuffers: #() outputBuffers: { managedBuffer }
		pushConstants: pushConstants
		computeShaderStage: shaderStageCode globalSize: managedBuffer size
		cpuFallbackWith: [
			self generateDataWithSize: managedBuffer size intoCPUBuffer: managedBuffer rawCpuData
		].

]

{ #category : #'as yet unclassified' }
SGPUIntervalDataArrayGenerator >> generateDataWithSize: arraySize intoCPUBuffer: cpuData [
	0 to: arraySize - 1 do: [ :i |
		"Compute from the beginning to improve floating point accuracy. See Interval >> #do:"
		cpuData at: i + 1 put: first + (increment*i).
	].
]

{ #category : #accessing }
SGPUIntervalDataArrayGenerator >> increment [
	^ increment
]

{ #category : #accessing }
SGPUIntervalDataArrayGenerator >> increment: anObject [
	increment := anObject
]
