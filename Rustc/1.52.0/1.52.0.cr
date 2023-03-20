class Target < ISM::Software

    def prepare
        super

        configData = <<-CODE
        [llvm]
        targets = "X86"
        link-shared = true

        [build]
        docs = false
        extended = true

        [install]
        prefix = "/opt/rustc-1.52.0"
        docdir = "share/doc/rustc-1.52.0"

        [rust]
        channel = "stable"
        rpath = false
        codegen-tests = false

        [target.x86_64-unknown-linux-gnu]
        llvm-config = "/usr/bin/llvm-config"

        [target.i686-unknown-linux-gnu]
        llvm-config = "/usr/bin/llvm-config"
        CODE
        fileWriteData("#{buildDirectoryPath}/config.toml",configData)
    end
    
    def build
        super

        runPythonCommand(   ["./x.py","build","--exclude","src/tools/miri"],
                            buildDirectoryPath,
                            {"RUSTFLAGS" => "$RUSTFLAGS -C link-args=-lffi"})
    end
    
    def prepareInstallation
        super

        runPythonCommand(   ["./x.py","build","install"],
                            buildDirectoryPath,
                            {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                            "LIBSSH2_SYS_USE_PKG_CONFIG" => 1})
        puts "Check first the files before installations please"
        exit 1
    end

end
