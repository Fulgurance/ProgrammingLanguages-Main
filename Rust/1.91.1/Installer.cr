class Target < ISM::Software

    def prepare
        super

        architecture = Ism.settings.systemTargetArchitecture
        os = Ism.settings.systemTargetOs
        abi = Ism.settings.systemTargetAbi
        target = "#{architecture}-unknown-#{os}-#{abi}"

        configData = <<-CODE
        change-id = 129295

        [llvm]
        targets = "X86"
        link-shared = true

        [build]
        build = "#{target}"
        target = ["#{target}"]
        docs = false
        extended = true
        locked-deps = true
        tools = ["cargo", "rustdoc"]
        vendor = true

        [install]
        prefix = "/usr"
        docdir = "share/doc/rustc-#{@information.version}"

        [rust]
        channel = "stable"
        lto = "thin"
        codegen-units = 1

        [target.#{target}]
        crt-static = false
        CODE
        fileWriteData("#{buildDirectoryPath}/config.toml",configData)
    end

    def build
        super

        runPythonCommand(   arguments:      "./x.py build library/std --stage 0",
                            path:           buildDirectoryPath,
                            environment:    {   "LIBSSH2_SYS_USE_PKG_CONFIG" => "1",
                                                "LIBSQLITE3_SYS_USE_PKG_CONFIG" => "1"})
    end

    def prepareInstallation
        super

        runPythonCommand(   arguments:      "./x.py install rustc std cargo",
                            path:           buildDirectoryPath,
                            environment:    {   "DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                                                "LIBSSH2_SYS_USE_PKG_CONFIG" => "1}",
                                                "LIBSQLITE3_SYS_USE_PKG_CONFIG" => "1"})

        deleteAllFilesRecursivelyFinishing( path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                                            extensions: ["old"])
    end

end
