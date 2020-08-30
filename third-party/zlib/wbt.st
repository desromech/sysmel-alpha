self platform name selectCase: {
    #linux -> [
        self importLibrary: 'z' fromDebianPackage: 'zlib1g-dev'.
    ].
    #osx -> [

    ].
    #windows -> [

    ].
    [true] -> []
}.
