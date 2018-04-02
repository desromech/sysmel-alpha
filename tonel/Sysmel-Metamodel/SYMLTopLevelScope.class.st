Class {
	#name : #SYMLTopLevelScope,
	#superclass : #SYMLLexicalScope,
	#instVars : [
		'module'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

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
		at: #function put: (SYMLMetaBuilder for: SYMLFunction module: module);
		at: #trait put: (SYMLMetaBuilder for: SYMLTrait module: module);
		at: #type put: (SYMLMetaBuilder for: SYMLSimpleType module: module);
		at: #namespace put: (SYMLMetaBuilder for: SYMLNamespace module: module);
		at: #template put: (SYMLMetaBuilder for: SYMLTemplate module: module);
		
		at: #structure put: (SYMLMetaBuilder for: SYMLStructure module: module);
		at: #class put: (SYMLMetaBuilder for: SYMLClass module: module);
		at: #union put: (SYMLMetaBuilder for: SYMLUnion module: module);
		yourself
	
]

{ #category : #initialization }
SYMLTopLevelScope >> initialize [
	super initialize.
	symbols := Dictionary new.
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
