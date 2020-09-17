Extension { #name : #CompiledCode }

{ #category : #trailer }
CompiledCode >> trailer [
	"Answer the receiver's trailer"
	^ CompiledMethodTrailer new method: self
]

{ #category : #trailer }
CompiledCode >> trailerSize [
	^ self trailer size
]
