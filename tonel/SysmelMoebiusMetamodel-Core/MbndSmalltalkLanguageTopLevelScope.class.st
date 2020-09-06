Class {
	#name : #MbndSmalltalkLanguageTopLevelScope,
	#superclass : #MbndLanguageTopLevelScope,
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #initialization }
MbndSmalltalkLanguageTopLevelScope >> addTopLevelSymbols [
	super addTopLevelSymbols.
	topLevelSymbols
		at: #void put: (MbndValue value: nil type: compilationTarget voidType);
		at: #nil put: (MbndValue value: nil type: compilationTarget undefinedType);
		at: #true put: (MbndValue value: true type: compilationTarget literalBooleanTrueType);
		at: #false put: (MbndValue value: false type: compilationTarget literalBooleanFalseType).
]
