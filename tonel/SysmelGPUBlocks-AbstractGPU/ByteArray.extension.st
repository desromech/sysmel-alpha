Extension { #name : #ByteArray }

{ #category : #'*SysmelGPUBlocks-AbstractGPU' }
ByteArray >> pushAsGPUConstantsWithCommandList: computationCommandList at: offset [
	computationCommandList pushConstants: offset size: self size values: self
]
