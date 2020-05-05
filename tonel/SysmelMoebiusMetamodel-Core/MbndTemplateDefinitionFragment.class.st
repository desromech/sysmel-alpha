Class {
	#name : #MbndTemplateDefinitionFragment,
	#superclass : #Object,
	#instVars : [
		'node',
		'scope'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Template'
}

{ #category : #serialization }
MbndTemplateDefinitionFragment class >> messagePackTypeName [
	^ #TemplateDefinitionFragment
]

{ #category : #'semantic analysis' }
MbndTemplateDefinitionFragment >> applyToInstance: templateInstance [
	| evaluationScope module |
	module := templateInstance compilationEnvironment currentModule.
	evaluationScope := module moduleScope
		parent: (templateInstance extensionFragmentEvaluationScope parent: scope).
	^ MbndAstSemanticAnalyzerAndEvaluator new
		module: module;
		evaluateNode: node withReturnContextInScope: evaluationScope
]

{ #category : #serialization }
MbndTemplateDefinitionFragment >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#node . node encodeGraphForMessagePackWith: graphEncoder.
		#scope . scope encodeGraphForMessagePackWith: graphEncoder
	}
]

{ #category : #serialization }
MbndTemplateDefinitionFragment >> encodeGraphForMessagePackWith: graphEncoder [
	^ graphEncoder encodeObject: self type: self messagePackTypeName fields: [{
		#node . node encodeGraphForMessagePackWith: graphEncoder.
		#scope . scope encodeGraphForMessagePackWith: graphEncoder
	}]
]

{ #category : #serialization }
MbndTemplateDefinitionFragment >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	node := encodedFields at: #node.
	scope := encodedFields at: #scope.
]

{ #category : #serialization }
MbndTemplateDefinitionFragment >> messagePackTypeName [
	^ self class messagePackTypeName
]

{ #category : #accessing }
MbndTemplateDefinitionFragment >> node [
	^ node
]

{ #category : #accessing }
MbndTemplateDefinitionFragment >> node: anObject [
	node := anObject
]

{ #category : #accessing }
MbndTemplateDefinitionFragment >> scope [
	^ scope
]

{ #category : #accessing }
MbndTemplateDefinitionFragment >> scope: anObject [
	scope := anObject
]
