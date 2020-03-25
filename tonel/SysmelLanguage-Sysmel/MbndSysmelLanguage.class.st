Class {
	#name : #MbndSysmelLanguage,
	#superclass : #MbndGenericMacroLanguageInterface,
	#category : #'SysmelLanguage-Sysmel-IRAST'
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
		languageName: self languageName;
		yourself
]

{ #category : #parsing }
MbndSysmelLanguage >> parse: sourceCollectionWithContext [
	| ast convertedAST |
	[
		ast := MbndProfiler component: #parseSysmel with: [SysmelParser parse: sourceCollectionWithContext collection].	
	] on: SmaCCParserError do: [ :ex |
		| errorPosition errorMessage |
		errorMessage := 'Parse error' .
		ex tag errorToken ifNotNil: [ :errorToken |
			| errorTokenValue |
			errorTokenValue := errorToken value.
			errorTokenValue ifNotEmpty: [ 
				errorMessage := 'Unexpected token {1}.' format: { errorTokenValue }
			].
		].
	
		errorPosition := MbndSourcePosition new
			collection: sourceCollectionWithContext;
			start: ex tag position;
			stop: ex tag position;
			yourself.
		^ MbndParseError new
			sourcePosition: errorPosition;
			signal: errorMessage
	].

	convertedAST :=  MbndProfiler component: #convertSysmelAST with: [SysmelMoebiusASTBuilder new
		collectionWithContext: sourceCollectionWithContext;
		builder: (MbndAstBuilder forModule: targetModule);
		convertNode: ast].
	^ MbndLanguageParsedSource new
		ast: convertedAST;
		language: self;
		yourself
]
