Class {
	#name : #SYMLMacroBuilder,
	#superclass : #SYMLNamedProgramEntity,
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #accessing }
SYMLMacroBuilder >> expansionRule [
	<compileTime>
	^ SYMLMacroExpansionRule new
		module: module;
		definitionEnvironment: definitionEnvironment;
		definitionNode: definitionNode;
		parent: parent;
		yourself
]

{ #category : #accessing }
SYMLMacroBuilder >> methodGenerator [
	<compileTime>
	^ SYMLMacroMethodGenerator new
		module: module;
		definitionEnvironment: definitionEnvironment;
		definitionNode: definitionNode;
		parent: parent;
		yourself
]

{ #category : #'as yet unclassified' }
SYMLMacroBuilder >> selector: selectorLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| selector macro |
	selector := selectorLazyValue value.
	macro := SYMLDeferredMacro new
			module: module;
			definitionPosition: selectorLazyValue node position;
			parse: actionRules asBlockDictionaryValue;
			yourself.

	parent addMacroMethodPattern: macro withSelector: selector
]

{ #category : #'as yet unclassified' }
SYMLMacroBuilder >> selectors: selectorsLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| selectors macro |
	selectors := selectorsLazyValue value.
	macro := SYMLDeferredMacro new
			module: module;
			definitionPosition: selectorsLazyValue node position;
			parse: actionRules asBlockDictionaryValue;
			yourself.

	selectors do: [ :selector |
		parent addMacroMethodPattern: macro withSelector: selector
	]
]
