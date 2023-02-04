class Target < ISM::Software
    
    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super
        runCmakeCommand([   "-DCMAKE_INSTALL_PREFIX=/usr",
                            "-DLLVM_ENABLE_FFI=ON",
                            "-DCMAKE_BUILD_TYPE=Release",
                            "-DLLVM_BUILD_LLVM_DYLIB=ON",
                            "-DLLVM_LINK_LLVM_DYLIB=ON",
                            "-DLLVM_ENABLE_RTTI=ON",
                            "-DLLVM_TARGETS_TO_BUILD=\"host;AMDGPU;BPF\"",
                            "-DLLVM_BUILD_TESTS=ON",
                            "-DLLVM_BINUTILS_INCDIR=/usr/include",
                            "-Wno-dev -G Ninja .."],
                            buildDirectoryPath,
                            {"CC" => "gcc","CXX" => "g++"})
    end

    def build
        super
        runNinjaCommand(Array(String).new,buildDirectoryPath)
    end
    
    def prepareInstallation
        super
        runNinjaCommand(["install"],buildDirectoryPath,{"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})
    end

end
