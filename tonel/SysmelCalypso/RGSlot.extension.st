Extension { #name : #RGSlot }

{ #category : #'*SysmelCalypso' }
RGSlot >> createRefactoring: variableRefactoringClass for: declarationClass [
	^variableRefactoringClass classVariableAnalog
			variable: self name
			class: declarationClass
]
