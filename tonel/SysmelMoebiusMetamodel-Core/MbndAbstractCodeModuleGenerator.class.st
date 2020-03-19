Class {
	#name : #MbndAbstractCodeModuleGenerator,
	#superclass : #MbndAbstractModuleVisitor,
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #'as yet unclassified' }
MbndAbstractCodeModuleGenerator >> generateCodeModuleFor: aModule name: codeModuleName [
	self subclassResponsibility
]
