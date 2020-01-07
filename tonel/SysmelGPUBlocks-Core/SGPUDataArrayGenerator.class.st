Class {
	#name : #SGPUDataArrayGenerator,
	#superclass : #Object,
	#category : #'SysmelGPUBlocks-Core-Data'
}

{ #category : #'as yet unclassified' }
SGPUDataArrayGenerator >> generateDataInGPUManagedBuffer: managedBuffer [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SGPUDataArrayGenerator >> generateDataWithSize: arraySize intoCPUBuffer: cpuData [
	self subclassResponsibility
]
