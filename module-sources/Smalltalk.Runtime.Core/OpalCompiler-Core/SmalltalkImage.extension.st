Extension { #name : #SmalltalkImage }

{ #category : #'*OpalCompiler-Core' }
SmalltalkImage >> compilerClass [
	^ self class compilerClass
]

{ #category : #'*OpalCompiler-Core' }
SmalltalkImage class >> compilerClass [
	^ OpalCompiler
]

{ #category : #'*OpalCompiler-Core' }
SmalltalkImage >> compiler [
	^ self compilerClass new
        environment: self globals
]
