class Target < ISM::Software
    
    def build
        super

        makeSource( path:           buildDirectoryPath,
                    environment:    {   "PATH" => "#{workDirectoryPath}/Crystal-Compiler-#{version}/bin:/usr/lib/llvm/#{softwareMajorVersion("@ProgrammingLanguages-Main:Llvm")}/bin:$PATH"})
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "PREFIX=/usr DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath,
                    environment:    {   "PATH" => "#{workDirectoryPath}/Crystal-Compiler-#{version}/bin:/usr/lib/llvm/#{softwareMajorVersion("@ProgrammingLanguages-Main:Llvm")}/bin:$PATH"})
    end

end
