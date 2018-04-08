Class {
	#name : #SYMLReturnMetaCompilationMethod,
	#superclass : #SYMLMetaCompilationMethod,
	#category : #'Sysmel-Metamodel-MetaCompilationMethod'
}

{ #category : #'as yet unclassified' }
SYMLReturnMetaCompilationMethod >> evaluateMessage: message inEnvironment: anEnvironment [
	| result convertedResult |
	result := message arguments first evaluateInEnvironment: anEnvironment.
	convertedResult := result coercedIntoType: message coercionType at: message.
	SYMLValueReturnException new
		value: convertedResult;
		signal
]

{ #category : #'as yet unclassified' }
SYMLReturnMetaCompilationMethod >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	| expectedReturnType returnValue returnValueType |
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
	(returnValueType canBeCoercedImplicitlyInto: expectedReturnType) ifFalse: [
		self error: 'Cannot coerce value of {1} into {2}.' format: {returnValueType asString . expectedReturnType asString} at: aPosition
	].
	^ message copy
		arguments: { returnValue };
		metaMethod: self;
		coercionType: expectedReturnType;
		valueType: environment compilationTarget voidType;
		yourself
]
