Class {
	#name : #MbndPharoMethodLanguage,
	#superclass : #MbndAbstractPharoLanguage,
	#category : #'SysmelLanguage-Pharo'
}

{ #category : #accessing }
MbndPharoMethodLanguage class >> languageName [
	^ #pharoMethod
]

{ #category : #parsing }
MbndPharoMethodLanguage >> parse: sourceCollectionWithContext [
	| ast |
	ast := MbndProfiler component: #parsePharoMethod with: [RBParser parseMethod: sourceCollectionWithContext onError: [ :message :index |
		^ self convertParseError: message at: index in: sourceCollectionWithContext
	]].
	^ MbndLanguageParsedSource new
		ast: (self generateMoebiusASTFromRBAst: ast parsedFromSourceCollection: sourceCollectionWithContext);
		language: self;
		yourself
]
