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
                            {"RUSTFLAGS" => "-C link-args=-lffi"})
    end
    
    def prepareInstallation
        super

        runPythonCommand(   ["./x.py","install"],
                            buildDirectoryPath,
                            {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                            "LIBSSH2_SYS_USE_PKG_CONFIG" => "1"})

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/profile.d")

        copyFile("#{Ism.settings.rootPath}etc/ld.so.conf","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/ld.so.conf")
        if File.exists?("#{Ism.settings.rootPath}etc/profile.d/rustc.sh")
            copyFile("#{Ism.settings.rootPath}etc/profile.d/rustc.sh","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/profile.d/rustc.sh")
        end

        ldSoConfData = <<-CODE
        /opt/rustc/lib
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/ld.so.conf",ldSoConfData)

        rustcShData = <<-CODE
        pathprepend /opt/rustc/bin PATH
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/profile.d/rustc.sh",rustcShData)
    end

    def install
        super

        makeLink("rustc-1.52.0","#{Ism.settings.rootPath}opt/rustc",:symbolicLinkByOverwrite)
        runLdconfigCommand
        sourceFile(["#{Ism.settings.rootPath}etc/profile.d/rustc.sh"])
    end

end
