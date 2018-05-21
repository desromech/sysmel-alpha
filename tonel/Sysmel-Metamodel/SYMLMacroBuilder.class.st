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

{ #category : #'as yet unclassified' }
SYMLMacroBuilder >> selector: selectorLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| selector macro |
	selector := selectorLazyValue value.
	macro := SYMLDeferredMacro new
			module: module;
			parse: actionRules;
			yourself.

	parent addMethod: macro withSelector: selector
]

{ #category : #'as yet unclassified' }
SYMLMacroBuilder >> selectors: selectorsLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| selectors macro |
	selectors := selectorsLazyValue value.
	macro := SYMLDeferredMacro new
			module: module;
			parse: actionRules;
			yourself.
			
	selectors do: [ :selector |
		parent addMethod: macro withSelector: selector
	]
]
