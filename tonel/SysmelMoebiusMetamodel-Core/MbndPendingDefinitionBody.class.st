Class {
	#name : #MbndPendingDefinitionBody,
	#superclass : #MbndPendingDefinitionFragment,
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'public access' }
MbndPendingDefinitionBody >> evaluate [
	MbndAstSemanticAnalyzer new 
		module: module;
		scope: scope;
		evaluateCompileTimeExpression: node
]
