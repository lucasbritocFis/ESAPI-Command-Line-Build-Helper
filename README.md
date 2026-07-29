<p align="center">
  <img src="https://img.shields.io/badge/C%23-.NET%20Framework-green" alt="C# and .NET Framework" />
  <img src="https://img.shields.io/badge/ESAPI-tested%20on%2016.1-blue" alt="Tested on ESAPI 16.1" />
  <img src="https://img.shields.io/badge/platform-Windows-0078D6" alt="Windows" />
  <img src="https://img.shields.io/badge/license-MIT-lightgrey" alt="MIT License" />
</p>

<h1 align="center">ESAPI Command-Line Build Helper</h1>

<p align="center">
  Build small ESAPI plug-ins from the Windows command line without creating a Visual Studio project.
</p>

---

## Why I built this

For a small ESAPI script, creating and configuring a complete Visual Studio project can be more work than the script itself.

The actual compilation step is much simpler. It needs:

* a C# source file;
* the ESAPI assemblies;
* the C# compiler;
* the correct build options.

This repository puts those steps into a small batch script.

It is intended for simple, single-file plug-ins. Visual Studio and MSBuild are still better choices for larger projects.

---

## How it works

The build script calls the C# compiler included with the local .NET Framework installation.

It provides the required ESAPI references, targets x64 and creates a standard .NET class library with the following name:

```text
YourScript.esapi.dll
```

The `.esapi.dll` ending is the filename expected by the ESAPI script workflow. Internally, the file is still a normal managed .NET assembly.

The current script references:

```text
VMS.TPS.Common.Model.API.dll
VMS.TPS.Common.Model.Types.dll
```

Before compiling, it deletes an older DLL with the same name. This prevents an old build from being mistaken for the new one when compilation fails.

---

## Requirements

* 64-bit Windows;
* .NET Framework with the 64-bit C# compiler installed;
* Eclipse/ARIA with the ESAPI assemblies available locally;
* access to the Eclipse script registration workflow.

The project was developed and tested with ESAPI 16.1. Other versions have not yet been tested.

The current compiler path is:

```text
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe
```

---

## Setup

Clone the repository:

```bat
git clone https://github.com/lucasbritocFis/ESAPI-Offline-Compiler.git
cd ESAPI-Offline-Compiler
```

Run the environment checker:

```bat
scripts\check_env.bat
```

The checker searches common Varian installation folders and prints a possible ESAPI API path.

Confirm that the folder contains:

```text
VMS.TPS.Common.Model.API.dll
VMS.TPS.Common.Model.Types.dll
```

Then update `ESAPI_DIR` inside:

```text
scripts\build.bat
```

---

## Compile the example

From the repository root, run:

```bat
scripts\build.bat
```

With no argument, the script compiles:

```text
examples\HelloEsapi.cs
```

The expected output is:

```text
HelloEsapi.esapi.dll
```

---

## Compile another script

Pass the source file as the first argument:

```bat
scripts\build.bat YourScript.cs
```

The output will be:

```text
YourScript.esapi.dll
```

The current version accepts one C# source file at a time.

---

## Repository structure

```text
ESAPI-Offline-Compiler/
├── examples/
│   └── HelloEsapi.cs
├── scripts/
│   ├── check_env.bat
│   └── build.bat
├── LICENSE
└── README.md
```

### `HelloEsapi.cs`

A small read-only example.

It uses the active `ScriptContext`, checks whether a patient and structure set are available and lists the non-empty structures.

### `check_env.bat`

Searches common Varian RTM installation folders for the ESAPI API assembly.

The detected path should be reviewed before use.

### `build.bat`

Checks the source file and required dependencies, calls `csc.exe` and generates the output DLL.

---

## What a successful build means

A successful build means that the C# compiler generated the DLL.

The next steps—registration, loading and execution inside Eclipse—must still be tested in the local environment.

Compilation alone does not validate the behavior or clinical safety of a script.

---

## Current limitations

The project does not currently handle:

* multiple source files;
* NuGet packages;
* automatic assembly version changes;
* automatic Eclipse registration;
* additional external dependencies;
* reproducible builds across different machines.

---

## Clinical use

This is an independent development project and is not affiliated with Varian or Siemens Healthineers.

Any script intended for clinical use should be reviewed, tested, documented and approved according to the institution's local software and quality-assurance procedures.

Do not publish patient-identifiable information in screenshots, logs or GitHub issues.

---

## License

MIT — see [LICENSE](LICENSE).

## Author

**Lucas Brito, PhD**
Clinical Medical Physicist and Software Developer
Rio de Janeiro, Brazil
