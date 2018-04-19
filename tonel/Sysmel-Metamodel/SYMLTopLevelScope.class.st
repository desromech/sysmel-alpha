Class {
	#name : #SYMLTopLevelScope,
	#superclass : #SYMLLexicalScope,
	#instVars : [
		'module'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #accessing }
SYMLTopLevelScope >> addMethod: method withSelector: selector [
	metaMethodDictionary at: selector put: method
]

{ #category : #accessing }
SYMLTopLevelScope >> compilationTarget [
	^ module compilationTarget
]

{ #category : #'as yet unclassified' }
SYMLTopLevelScope >> definitionProgramEntity [
	^ module
]

{ #category : #accessing }
SYMLTopLevelScope >> fillSymbols [
	symbols
		at: #Compiler put: module;
		at: #let put: (SYMLMetaBuilder for: SYMLLocalVariable module: module);
		at: #using put: (SYMLMetaBuilder for: SYMLObjectAlias module: module);
		
		at: #function put: (SYMLMetaBuilder for: SYMLFunction module: module);
		at: #trait put: (SYMLMetaBuilder for: SYMLTrait module: module);
		at: #type put: (SYMLMetaBuilder for: SYMLSimpleType module: module);
		at: #macro put: (SYMLMetaBuilder for: SYMLMacroBuilder module: module);
		at: #namespace put: (SYMLMetaBuilder for: SYMLNamespace module: module);
		at: #template put: (SYMLMetaBuilder for: SYMLTemplate module: module);
		
		at: #struct put: (SYMLMetaBuilder for: SYMLStructure module: module);
		at: #class put: (SYMLMetaBuilder for: SYMLClass module: module);
		at: #union put: (SYMLMetaBuilder for: SYMLUnion module: module);

		at: #true put: (SYMLBooleanConstant new value: true; module: module);
		at: #false put: (SYMLBooleanConstant new value: false; module: module);
		
		yourself.
	
]

{ #category : #accessing }
SYMLTopLevelScope >> module [
	^ module
]

{ #category : #accessing }
SYMLTopLevelScope >> module: anObject [
	module := anObject.
	self fillSymbols
	
]
