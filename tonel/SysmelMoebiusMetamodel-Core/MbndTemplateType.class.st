Class {
	#name : #MbndTemplateType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndTemplateType class >> typeName [
	^ #_TemplateType
]

{ #category : #initialization }
MbndTemplateType >> addInstanceMacros [
	self class == MbndTemplateType ifFalse: [ ^ self ].
	self
		onMacroSelector: #applyWithArguments: do: [ :node :builder :analyzer |
			| template |
			template := (analyzer evaluateCompileTimeExpression: node receiver) unwrapMbndValue.
			template isTemplate ifFalse: [ 
				analyzer error: 'Expected a template value for making a template instance.' at: node receiver
			].
		
			template analyzeAndEvaluateApplicationNode: node withAnalyzer: analyzer
		]
]

{ #category : #testing }
MbndTemplateType >> isTemplateType [
	^ true
]
