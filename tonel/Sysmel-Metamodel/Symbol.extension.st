Extension { #name : #Symbol }

{ #category : #'*Sysmel-Metamodel' }
Symbol >> asLiteralObjectProxyWithType: type [
	^ SYMLSymbolLiteralObjectProxy new literal: self; type: type; yourself
]

{ #category : #'*Sysmel-Metamodel' }
Symbol >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget literalSymbolType inEnvironment: anEnvironment
]

{ #category : #'*Sysmel-Metamodel' }
Symbol >> createNonInlineLiteralConstantForSysmelObjectModel: objectModel withCodeGenerator: aCodeGenerator [
	^ objectModel createSymbolNonInlineConstant: self
]
