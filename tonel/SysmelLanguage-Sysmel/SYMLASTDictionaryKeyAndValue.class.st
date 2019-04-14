Class {
	#name : #SYMLASTDictionaryKeyAndValue,
	#superclass : #SYMLASTNode,
	#instVars : [
		'key',
		'value'
	],
	#category : #'SysmelLanguage-Sysmel-AST'
}

{ #category : #accessing }
SYMLASTDictionaryKeyAndValue >> buildMoebiusAST: builder [
	^ (builder associationKey: (key buildMoebiusAST: builder) value: (value buildMoebiusAST: builder))
		position: position;
		yourself
]

{ #category : #accessing }
SYMLASTDictionaryKeyAndValue >> children [
	^ { 
		#key -> {key} .
		#value -> {value} .
	}
]

{ #category : #accessing }
SYMLASTDictionaryKeyAndValue >> key [
	^ key
]

{ #category : #accessing }
SYMLASTDictionaryKeyAndValue >> key: anObject [
	key := anObject
]

{ #category : #accessing }
SYMLASTDictionaryKeyAndValue >> printOn: aStream [
	aStream nextPutAll: 'association'
]

{ #category : #accessing }
SYMLASTDictionaryKeyAndValue >> value [
	^ value
]

{ #category : #accessing }
SYMLASTDictionaryKeyAndValue >> value: anObject [
	value := anObject
]
