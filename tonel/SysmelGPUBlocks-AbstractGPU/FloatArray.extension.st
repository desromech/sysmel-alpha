Extension { #name : #FloatArray }

{ #category : #'*SysmelGPUBlocks-AbstractGPU' }
FloatArray >> pushAsGPUConstantsWithCommandList: computationCommandList at: offset [
	computationCommandList pushConstants: offset size: self size * 4 values: self
]
