Extension { #name : #Symbol }

{ #category : #'*Sysmel-Metamodel' }
Symbol >> asLiteralObjectProxyWithType: type [
	^ (SYMLSymbolLiteralObjectProxy for: self) type: type; yourself
]

{ #category : #'*Sysmel-Metamodel' }
Symbol >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget literalSymbolType inEnvironment: anEnvironment
]

{ #category : #'*Sysmel-Metamodel' }
Symbol >> createNonInlineLiteralObjectForSysmelObjectModel: objectModel [
	^ objectModel createSymbolObjectInstance: self
]
