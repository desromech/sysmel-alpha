Extension { #name : #SequenceableCollection }

{ #category : #'*SysmelGPUBlocks-Core' }
SequenceableCollection >> asGPUArrayOfType: type [
	^ SGPUCompilationEnvironment current constructArrayOfType: type with: self
]

{ #category : #'*SysmelGPUBlocks-Core' }
SequenceableCollection >> asGPUFloat32Array [
	^ self asGPUArrayOfType: #Float32
]

{ #category : #'*SysmelGPUBlocks-Core' }
SequenceableCollection >> asGPUFloat32x2Array [
	^ self asGPUArrayOfType: #Float32x2
]

{ #category : #'*SysmelGPUBlocks-Core' }
SequenceableCollection >> asGPUFloat32x3Array [
	^ self asGPUArrayOfType: #Float32x3
]

{ #category : #'*SysmelGPUBlocks-Core' }
SequenceableCollection >> asGPUFloat32x4Array [
	^ self asGPUArrayOfType: #Float32x4
]

{ #category : #'*SysmelGPUBlocks-Core' }
SequenceableCollection >> asGPUFloat64Array [
	^ self asGPUArrayOfType: #Float64
]

{ #category : #'*SysmelGPUBlocks-Core' }
SequenceableCollection >> asGPUFloat64x2Array [
	^ self asGPUArrayOfType: #Float64x2
]

{ #category : #'*SysmelGPUBlocks-Core' }
SequenceableCollection >> asGPUFloat64x3Array [
	^ self asGPUArrayOfType: #Float64x3
]

{ #category : #'*SysmelGPUBlocks-Core' }
SequenceableCollection >> asGPUFloat64x4Array [
	^ self asGPUArrayOfType: #Float64x4
]
