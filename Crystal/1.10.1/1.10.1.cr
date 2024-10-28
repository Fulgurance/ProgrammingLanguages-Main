class Target < ISM::Software
    
    def build
        super

        makeSource( path:           buildDirectoryPath,
                    environment:    {   "PATH" => "#{workDirectoryPath}/Crystal-Compiler-1.10.1/bin:$PATH",
                                        "LLVM_DIR" => "/usr/lib/llvm/#{softwareMajorVersion("@ProgrammingLanguages-Main:Llvm")}/"})
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "PREFIX=/usr DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath,
                    environment:    {"LLVM_DIR" => "/usr/lib/llvm/#{softwareMajorVersion("@ProgrammingLanguages-Main:Llvm")}/"})
    end

end
