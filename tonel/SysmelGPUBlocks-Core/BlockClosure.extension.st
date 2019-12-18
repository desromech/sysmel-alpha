Extension { #name : #BlockClosure }

{ #category : #'*SysmelGPUBlocks-Core' }
BlockClosure >> gpuType: aGPUType [
	^ SGPUBlockClosure for: self withTypeExpression: aGPUType
]
