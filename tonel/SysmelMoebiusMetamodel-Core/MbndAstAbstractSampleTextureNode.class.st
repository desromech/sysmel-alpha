Class {
	#name : #MbndAstAbstractSampleTextureNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'sampler',
		'texture',
		'texcoord'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #serialization }
MbndAstAbstractSampleTextureNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#sampler . sampler encodeGraphForMessagePackWith: graphEncoder.
		#texcoord . texcoord encodeGraphForMessagePackWith: graphEncoder.
		#texture . texture encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #serialization }
MbndAstAbstractSampleTextureNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	sampler := encodedFields at: #sampler.
	texcoord := encodedFields at: #texcoord.
	texture := encodedFields at: #texture.
]

{ #category : #accessing }
MbndAstAbstractSampleTextureNode >> sampler [
	^ sampler
]

{ #category : #accessing }
MbndAstAbstractSampleTextureNode >> sampler: anObject [
	sampler := anObject
]

{ #category : #accessing }
MbndAstAbstractSampleTextureNode >> texcoord [
	^ texcoord
]

{ #category : #accessing }
MbndAstAbstractSampleTextureNode >> texcoord: anObject [
	texcoord := anObject
]

{ #category : #accessing }
MbndAstAbstractSampleTextureNode >> texture [
	^ texture
]

{ #category : #accessing }
MbndAstAbstractSampleTextureNode >> texture: anObject [
	texture := anObject
]
