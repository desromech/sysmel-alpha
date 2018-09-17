Class {
	#name : #SYMLObjectWithType,
	#superclass : #SYMLObject,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'compile time evaluation' }
SYMLObjectWithType >> __sysmel [
	^ SYMLProxy new __interpreterObject: self
]

{ #category : #'as yet unclassified' }
SYMLObjectWithType >> sysmelPerform: aSelector withArguments: arguments [
	^ self sysmelPerform: aSelector withArguments: arguments fallbackWith: [
		self error: 'Cannot perform sysmel method {1} with receiver of type {2}.' format: { aSelector printString  . self asString }
	]

]

{ #category : #'compile time evaluation' }
SYMLObjectWithType >> sysmelPerform: aSelector withArguments: arguments fallbackWith: fallbackBlock [
	| method result |
	method := (self type lookupSelector: aSelector).
	method ifNil: [
		^ fallbackBlock value
	].

	result := method evaluateWithReceiver: self arguments: (arguments collect: [ :arg | arg asSysmelValueInEnvironment: self definitionEnvironment ]) inEnvironment: self definitionEnvironment at: (SYMLSourcePosition new).
	^ result
]
