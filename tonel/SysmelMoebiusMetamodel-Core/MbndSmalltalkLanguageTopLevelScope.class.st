Class {
	#name : #MbndSmalltalkLanguageTopLevelScope,
	#superclass : #MbndGenericMacroLanguageTopLevelScope,
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #initialization }
MbndSmalltalkLanguageTopLevelScope >> addTopLevelMetaBuilders [
	{
		MbndLetMetaBuilder.
		MbndThisContextMetaBuilder
	} do: [:each |
		topLevelSymbols at: each globalBindingName put: each metaBuilderFactory
	].
]

{ #category : #initialization }
MbndSmalltalkLanguageTopLevelScope >> addTopLevelSymbols [
	super addTopLevelSymbols.
	topLevelSymbols
		at: #void put: (MbndValue value: nil type: compilationTarget voidType);
		at: #nil put: (MbndValue value: nil type: compilationTarget undefinedType);
		at: #true put: (MbndValue value: true type: compilationTarget literalBooleanTrueType);
		at: #false put: (MbndValue value: false type: compilationTarget literalBooleanFalseType).
]

{ #category : #'as yet unclassified' }
MbndSmalltalkLanguageTopLevelScope >> currentLanguageHasImplicitDynamicObjectBlockEvaluation [
	^ true
]
