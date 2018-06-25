Trait {
	#name : #TSYMLInterpretedCompilationObject,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #parsing }
TSYMLInterpretedCompilationObject >> parse: lazyNodeValue [
	| environment actions actionValue |
	environment := lazyNodeValue environment.
	actions := lazyNodeValue asAPSGNodeValueWithError: 'Expected an apsg node with the rules.'.

	actions isSequenceNode ifFalse: [ 
		self error: 'Expected an apsg sequence node with the type conversion rules.' at: lazyNodeValue position
	].

	actions do: [ :action |
		action isMessageNode ifFalse: [ 
			self error: 'Expected a message node' at: action
		].

		action receiver ifNotNil: [ 
			self error: 'Expected a meta message (message without receiver)' at: action
		].

		action arguments size ~= 1 ifTrue: [ 
			self error: 'Expected a meta message with a single argument.' at: action
		].
	
		actionValue := (action arguments first analyzeAndEvaluateInEnvironment: environment) value asSysmelCompileTimeFunction.
		self perform: action selector with: actionValue
	]

]
