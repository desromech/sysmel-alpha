"
I am a generic macro language top-level scope. I add some top-level macros.

I introduce the following core control flow top-level macros:

- return:
- if:then:
- if:then:else:
- while:do:
- do:while:

I introduce the following synthesized control-flow macros:
- until:do:
- do:until:

"
Class {
	#name : #MbndGenericMacroLanguageTopLevelScope,
	#superclass : #MbndGenericLanguageTopLevelScope,
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #initialization }
MbndGenericMacroLanguageTopLevelScope >> addTopLevelMacros [
	super addTopLevelMacros.
	
	self
		onMacroSelector: #return: do: [ :node :builder |
			(builder return: node arguments first)
				position: node
		];
	
		onMacroSelector: #if:then: do: [ :node :builder |
			(builder if: node arguments first trueValue: node arguments second falseValue: nil)
				position: node
		];
		onMacroSelector: #if:then:else: do: [ :node :builder |
			(builder if: node arguments first trueValue: node arguments second falseValue: node arguments third)
				position: node
		];
	
		onMacroSelector: #while:do: do: [ :node :builder |
			(builder while: node arguments first do: node arguments second)
				position: node
		];
		onMacroSelector: #do:while: do: [ :node :builder |
			(builder do: node arguments first while: node arguments second)
				position: node
		];
		onMacroSelector: #until:do: do: [ :node :builder |
			(builder while:
				((builder unexpandedSend: #not to: node arguments first withArguments: #())
					position: node arguments first)
				do: node arguments second)
				position: node
		];
		onMacroSelector: #do:until: do: [ :node :builder |
			(builder do: node arguments first
				while: ((node unexpandedSend: #not to: node arguments second withArguments: #())
					position: node arguments second))
				position: node
		]
]
