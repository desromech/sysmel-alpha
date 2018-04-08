Class {
	#name : #SYMLReturnMacro,
	#superclass : #SYMLMacro,
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #'as yet unclassified' }
SYMLReturnMacro >> evaluateMessage: message inEnvironment: anEnvironment [
	| result convertedResult |
	result := message arguments first evaluateInEnvironment: anEnvironment.
	convertedResult := result coercedWithRule: message coercionRule intoType: message coercionType at: message.
	SYMLValueReturnException new
		value: convertedResult;
		signal
]

{ #category : #'as yet unclassified' }
SYMLReturnMacro >> generateMessage: messageNode ssaCodeWith: builder [
	| value valueNode valueType returnType rawValue |
	valueNode := messageNode arguments first.
	valueType := valueNode type.
	
	returnType := messageNode coercionType.
	rawValue := valueNode generateSSACodeWith: builder.

	^ returnType isVoidType ifTrue: [ 
		builder returnVoid
	] ifFalse: [
		value := messageNode coercionRule convertSSAValue: rawValue to: returnType with: builder at: messageNode.
		builder return: value
	]

]

{ #category : #'as yet unclassified' }
SYMLReturnMacro >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	| expectedReturnType returnValue returnValueType coercionRule |
	message arguments size ~= 1 ifTrue: [ 
		self error: '#return: meta-method requires at least one argument.' at: aPosition
	].

	"Get the expected return type."
	expectedReturnType := environment returnType.
	
	"Get the return value"
	returnValue := message arguments first semanticAnalysisInEnvironment: environment.
	returnValue hasIncompleteSemanticAnalysis ifTrue: [ 
		^ message copy
			arguments: { returnValue };
			metaMethod: self;
			hasIncompleteSemanticAnalysis: true;
			yourself
	].

	returnValueType := returnValue evaluateTypeInEnvironment: environment.
		
	"Check the type of the return value."
	coercionRule := returnValueType node: returnValue coercedImplicitlyInto: expectedReturnType at: aPosition.
	^ message copy
		arguments: { returnValue };
		metaMethod: self;
		coercionType: expectedReturnType;
		coercionRule: coercionRule;
		valueType: environment compilationTarget voidType;
		yourself
]
