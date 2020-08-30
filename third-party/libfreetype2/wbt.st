self platform name selectCase: {
    #linux -> [
        self importLibrary: 'freetype' fromDebianPackage: 'libfreetype6-dev'.
    ].
    #osx -> [

    ].
    #windows -> [

    ].
    [true] -> []
}.
