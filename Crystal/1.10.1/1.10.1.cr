class Target < ISM::Software
    
    def build
        super

        makeSource( path: buildDirectoryPath,
                    environment: {"PATH" => "#{ENV["PATH"]}:#{workDirectoryPath}/Crystal-Compiler-1.10.1/bin"})
    end
    
    def prepareInstallation
        super

        makeSource(["PREFIX=/usr","DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
