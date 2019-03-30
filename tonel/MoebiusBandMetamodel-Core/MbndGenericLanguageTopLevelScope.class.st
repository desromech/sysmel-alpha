"
I am a generic language top-level scope.

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
	#name : #MbndGenericLanguageTopLevelScope,
	#superclass : #MbndLanguageTopLevelScope,
	#category : #'MoebiusBandMetamodel-Core-Scope'
}
