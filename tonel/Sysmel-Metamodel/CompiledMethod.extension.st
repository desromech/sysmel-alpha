Extension { #name : #CompiledMethod }

{ #category : #'*Sysmel-Metamodel' }
CompiledMethod >> asSysmelCompileTimeFunction [
	^ SYMLCompiledMethodWrapper new method: self
]
