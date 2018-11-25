Extension { #name : #PP2FirstSetVisitor }

{ #category : #'*Sysmel-Parser' }
PP2FirstSetVisitor >> visitSysmelScapedLanguage: node [
	(self isTerminal: node) ifTrue: [ ^ self setWithPossible: node ].

	self warn: 'guess you have some issues with your terminal block'
]
