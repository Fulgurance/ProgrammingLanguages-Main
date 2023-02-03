class Target < ISM::Software
    
    def extract
        super
        moveFile("#{workDirectoryPath(false)}/crystal-1.7.2","#{workDirectoryPath(false)}/1.7.2")
    end
    
    def build
        super
        makeSource( [Ism.settings.makeOptions],
                    buildDirectoryPath,
                    {"PATH" => "$PATH:#{workDirectoryPath}/crystal-1.7.2-1/bin"})
    end
    
    def prepareInstallation
        super
        makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        deleteFile("#{Ism.settings.rootPath}/usr/bin/crystal")
    end

end
