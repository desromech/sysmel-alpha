Extension { #name : #BlockClosure }

{ #category : #'*Sysmel-Metamodel' }
BlockClosure >> asSysmelCompileTimeFunction [
	^ SYMLBlockClosureWrapper new blockClosure: self
]
