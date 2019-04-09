Class {
	#name : #MbndSysmelLanguage,
	#superclass : #MbndGenericMacroLanguageInterface,
	#category : #'SysmelLanguage-Parser'
}

{ #category : #accessing }
MbndSysmelLanguage class >> languageFileExtensions [
	^ #(sysmel)
]

{ #category : #accessing }
MbndSysmelLanguage class >> languageName [
	^ #sysmel
]

{ #category : #parsing }
MbndSysmelLanguage >> parse: sourceCollectionWithContext [
	| astOrFailure position |
	astOrFailure := SysmelParser parse: sourceCollectionWithContext.
	astOrFailure isPetit2Failure ifTrue: [
		position := SYMLSourcePosition new
			collection: sourceCollectionWithContext;
			start: astOrFailure position + 1;
			stop: astOrFailure position + 1;
			yourself.
		^ MbndParseError new
			sourcePosition: position;
			signal: astOrFailure message.
	].

	^ MbndLanguageParsedSource new
		ast: (astOrFailure buildMoebiusAST: (MbndAstBuilder forModule: targetModule));
		language: self;
		yourself
]