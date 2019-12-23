Extension { #name : #IntegerArray }

{ #category : #'*SysmelGPUBlocks-AbstractGPU' }
IntegerArray >> pushAsGPUConstantsWithCommandList: computationCommandList at: offset [
	computationCommandList pushConstants: offset size: self size * 4 values: self
]
