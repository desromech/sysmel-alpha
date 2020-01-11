Class {
	#name : #MbndSysmelLanguage,
	#superclass : #MbndGenericMacroLanguageInterface,
	#instVars : [
		'parser'
	],
	#category : #'SysmelLanguage-Sysmel-Parser'
}

{ #category : #'class initialization' }
MbndSysmelLanguage class >> initialize [
	"This is for ensuring that I am registered."
	MbndLanguageInterface initialize.
]

{ #category : #accessing }
MbndSysmelLanguage class >> languageFileExtensions [
	^ #(sysmel)
]

{ #category : #accessing }
MbndSysmelLanguage class >> languageName [
	^ #sysmel
]

{ #category : #scope }
MbndSysmelLanguage >> constructTopLevelLanguageScopeFor: aModule [
	^ (MbndGenericMacroLanguageTopLevelScope for: aModule)
		addUsedNamespace: (aModule globalNamespace ensureSymbolIsNamespace: #SysmelKernel);
		yourself.
]

{ #category : #parsing }
MbndSysmelLanguage >> parse: sourceCollectionWithContext [
	| astOrFailure position convertedAST |
	astOrFailure := MbndProfiler component: #parseSysmel with: [self parser parse: sourceCollectionWithContext].
	astOrFailure isPetit2Failure ifTrue: [
		position := MbndSourcePosition new
			collection: sourceCollectionWithContext;
			start: astOrFailure position + 1;
			stop: astOrFailure position + 1;
			yourself.
		^ MbndParseError new
			sourcePosition: position;
			signal: astOrFailure message.
	].

	convertedAST :=  MbndProfiler component: #convertSysmelAST with: [astOrFailure buildMoebiusAST: (MbndAstBuilder forModule: targetModule)].
	^ MbndLanguageParsedSource new
		ast: convertedAST;
		language: self;
		yourself
]

{ #category : #accessing }
MbndSysmelLanguage >> parser [
	^ parser ifNil: [parser := SysmelParser optimizedParser ]
]
