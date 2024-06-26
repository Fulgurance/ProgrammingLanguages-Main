class Target < ISM::Software
    
    def configure
        super

        runFile(file:       "src/all.bash",
                path:       buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        exit 1
    end

end
