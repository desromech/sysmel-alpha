Class {
	#name : #SGPUManagedDataArray,
	#superclass : #SequenceableCollection,
	#instVars : [
		'size',
		'mbndType',
		'cpuData',
		'currentDataLocation',
		'gpuBufferHandle'
	],
	#category : #'SysmelGPUBlocks-Core-Data'
}

{ #category : #adding }
SGPUManagedDataArray >> add: newObject [
	self shouldNotImplement
]

{ #category : #converting }
SGPUManagedDataArray >> asArray [
	self ensureInCPU.
	^ cpuData asArray
]

{ #category : #converting }
SGPUManagedDataArray >> asFloatArray [
	self ensureInCPU.
	^ cpuData asFloatArray
]

{ #category : #accessing }
SGPUManagedDataArray >> at: index [
	self ensureInCPU.
	^ cpuData at: index
]

{ #category : #accessing }
SGPUManagedDataArray >> at: index put: value [
	self ensureInCPU.
	^ cpuData at: index put: value
]

{ #category : #enumerating }
SGPUManagedDataArray >> collect: aBlock [
	aBlock isSGPUBlockClosure ifFalse: [ ^ super collect: aBlock ].
	self halt
]

{ #category : #accessing }
SGPUManagedDataArray >> cpuData [
	^ cpuData
]

{ #category : #accessing }
SGPUManagedDataArray >> currentDataLocation [
	^ currentDataLocation
]

{ #category : #'as yet unclassified' }
SGPUManagedDataArray >> ensureInCPU [
	self isInCPU ifTrue: [ ^ self ].
	self halt
]

{ #category : #accessing }
SGPUManagedDataArray >> gpuBufferHandle [
	^ gpuBufferHandle
]

{ #category : #accessing }
SGPUManagedDataArray >> gpuBufferHandle: anObject [
	gpuBufferHandle := anObject
]

{ #category : #initialization }
SGPUManagedDataArray >> initializeForType: aMbndType withCPUData: theCpuData [
	mbndType := aMbndType.
	cpuData := theCpuData.
	currentDataLocation := #cpu.
	size := theCpuData size.
]

{ #category : #testing }
SGPUManagedDataArray >> isInCPU [
	^ currentDataLocation == #cpu.
]

{ #category : #testing }
SGPUManagedDataArray >> isInGPU [
	^ currentDataLocation == #gpu.
]

{ #category : #accessing }
SGPUManagedDataArray >> mbndType [
	^ mbndType
]

{ #category : #accessing }
SGPUManagedDataArray >> size [
	^ size
]

{ #category : #private }
SGPUManagedDataArray >> species [
	^ Array
]
