Extension { #name : #Interval }

{ #category : #'*SysmelGPUBlocks-Core' }
Interval >> asGPUArrayOfType: type [
	^ SGPUCompilationEnvironment current constructArrayOfType: type withInterval: self
]
