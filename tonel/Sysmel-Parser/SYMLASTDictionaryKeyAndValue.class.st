Class {
	#name : #SYMLASTDictionaryKeyAndValue,
	#superclass : #SYMLASTNode,
	#instVars : [
		'key',
		'value'
	],
	#category : #'Sysmel-Parser-AST'
}

{ #category : #accessing }
SYMLASTDictionaryKeyAndValue >> buildAPSG: builder [
	^ (builder associationKey: (key buildAPSG: builder) value: (value buildAPSG: builder))
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
