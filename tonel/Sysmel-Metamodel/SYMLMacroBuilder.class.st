Class {
	#name : #SYMLMacroBuilder,
	#superclass : #SYMLNamedProgramEntity,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLMacroBuilder >> selector: selectorLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| selector macro |
	selector := selectorLazyValue value.
	macro := SYMLDeferredMacro new
			parse: actionRules;
			yourself.

	parent methodDictionary at: selector put: macro
]

{ #category : #'as yet unclassified' }
SYMLMacroBuilder >> selectors: selector doOn: rules [
	<compileTime>
	<lazy>
	self halt
]
