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
MbndMacroMetaBuilder >> fallback [
	self addFlag: #fallback
]

{ #category : #'as yet unclassified' }
MbndMacroMetaBuilder >> method [
	^ self delegateToMetaBuilder: (MbndMacroMethodMetaBuilder new
		flags: flags;
		yourself) 

]
