Class {
	#name : #MbndPharoDoItLanguage,
	#superclass : #MbndAbstractPharoLanguage,
	#category : #'SysmelLanguage-Pharo'
}

{ #category : #accessing }
MbndPharoDoItLanguage class >> languageName [
	^ #pharo
]

{ #category : #parsing }
MbndPharoDoItLanguage >> parse: sourceCollectionWithContext [
	| ast |
	ast := MbndProfiler component: #parsePharoDoIt with: [RBParser parseExpression: sourceCollectionWithContext onError: [ :message :index |
		^ self convertParseError: message at: index in: sourceCollectionWithContext
	]].
	^ MbndLanguageParsedSource new
		ast: (self generateMoebiusASTFromRBAst: ast parsedFromSourceCollection: sourceCollectionWithContext);
		language: self;
		yourself
]
