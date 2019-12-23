Extension { #name : #WordArray }

{ #category : #'*SysmelGPUBlocks-AbstractGPU' }
WordArray >> pushAsGPUConstantsWithCommandList: computationCommandList at: offset [
	computationCommandList pushConstants: offset size: self size * 4 values: self
]
