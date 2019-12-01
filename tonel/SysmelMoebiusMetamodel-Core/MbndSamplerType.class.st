Class {
	#name : #MbndSamplerType,
	#superclass : #MbndOpaqueHandleType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndSamplerType class >> typeName [
	^ #GPUSampler
]

{ #category : #visiting }
MbndSamplerType >> accept: visitor [
	^ visitor visitSamplerType: self
]

{ #category : #'testing methods' }
MbndSamplerType >> isSamplerType [
	^ true
]

{ #category : #initialization }
MbndSamplerType >> markAsTrait [
]
