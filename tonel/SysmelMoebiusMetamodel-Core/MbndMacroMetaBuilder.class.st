Class {
	#name : #MbndMacroMetaBuilder,
	#superclass : #MbndMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndMacroMetaBuilder class >> globalBindingName [
	^ #macro
]

{ #category : #'as yet unclassified' }
MbndMacroMetaBuilder >> expansionRule [
	^ self delegateToMetaBuilder: MbndMacroExpansionRuleMetaBuilder new

]
