Class {
	#name : #MbndConcreteMacroMessageMethod,
	#superclass : #MbndAbstractConcreteMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndConcreteMacroMessageMethod class >> messagePackTypeName [
	^ #ConcreteMacroMessageMethod
]

{ #category : #visiting }
MbndConcreteMacroMessageMethod >> accept: aVisitor [
	^ aVisitor visitConcreteMacroMessageMethod: self
]

{ #category : #'semantic analysis' }
MbndConcreteMacroMessageMethod >> extraImplicitArguments [
	^ {
		self createExtraImplicitArgument: #SelfType withType: self compilationTarget typeTypeConcept.
		self createExtraImplicitArgument: #__astBuilder withType: (self compilationTarget specificCompilerObjectTypeFor: MbndAstBuilder).
		self createExtraImplicitArgument: #__analyzer withType: (self compilationTarget specificCompilerObjectTypeFor: MbndAstSemanticAnalyzer).
	}
]

{ #category : #testing }
MbndConcreteMacroMessageMethod >> hasAnonymousName [
	^ name isNil
]

{ #category : #testing }
MbndConcreteMacroMessageMethod >> isConcreteMacroMessage [
	^ true
]

{ #category : #testing }
MbndConcreteMacroMessageMethod >> isFallbackMacro [
	^ self hasFlag: #fallback
]

{ #category : #'as yet unclassified' }
MbndConcreteMacroMessageMethod >> programEntityInformationDataClass [
	^ self compilationTarget macroMessageMethodInformationClass
]

{ #category : #printing }
MbndConcreteMacroMessageMethod >> qualifiedName [
	<compileTime>
	parent isMacroMessageMethod ifTrue: [ ^ parent qualifiedName ].
	^ super qualifiedName
]
