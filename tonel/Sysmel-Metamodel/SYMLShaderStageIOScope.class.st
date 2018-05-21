Class {
	#name : #SYMLShaderStageIOScope,
	#superclass : #SYMLAbstractTypeScope,
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #adding }
SYMLShaderStageIOScope >> addShaderStageVariable: variable at: aPosition [
	^ programEntity addShaderStageVariable: variable at: aPosition
]

{ #category : #accessing }
SYMLShaderStageIOScope >> fillSymbols [
	super fillSymbols.
	symbols
		at: #input put: (SYMLMetaBuilder for: SYMLShaderStageInputVariable module: programEntity module parent: programEntity);
		at: #output put: (SYMLMetaBuilder for: SYMLShaderStageOutputVariable module: programEntity module parent: programEntity);
		yourself
]
