Class {
	#name : #MbndConcreteMacroMessageMethod,
	#superclass : #MbndAbstractConcreteMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndConcreteMacroMessageMethod >> accept: aVisitor [
	^ aVisitor visitConcreteMacroMessageMethod: self
]

{ #category : #'semantic analysis' }
MbndConcreteMacroMessageMethod >> extraImplicitArguments [
	^ {
		self createExtraImplicitArgument: #__astBuilder withType: self compilationTarget compilerObjectType.
		self createExtraImplicitArgument: #__analyzer withType: self compilationTarget compilerObjectType.
	}
]
