@echo off

set JAVA="C:\Program Files\Java\jdk-17.0.8.1+1-jre\bin\java.exe"
set MINECRAFT_VERSION="1.20.1"
set FORGE_VERSION="47.2.14"
set RESTART="false"
set INSTALL_ONLY="false"

:: To use a specific Java runtime, set an environment variable named JAVA to the full path of java.exe.
:: To disable automatic restarts, set an environment variable named RESTART to false.
:: To install the pack without starting the server, set an environment variable named INSTALL_ONLY to true.

set INSTALLER="%~dp0forge-%MINECRAFT_VERSION%-%FORGE_VERSION%-installer.jar"
set FORGE_URL="http://files.minecraftforge.net/maven/net/minecraftforge/forge/%MINECRAFT_VERSION%-%FORGE_VERSION%/forge-%MINECRAFT_VERSION%-%FORGE_VERSION%-installer.jar"

IF NOT EXIST eula.txt GOTO EULA

:START

:JAVA
if not defined JAVA (
    set JAVA="java"
)

%JAVA% -version 1>nul 2>nul || (
   echo Minecraft %MINECRAFT_VERSION% requires Java 17 - Java not found
   pause
   exit /b 1
)

:FORGE
setlocal
cd /D "%~dp0"
if not exist "libraries" (
    echo Forge not installed, installing now.
    if not exist %INSTALLER% (
        echo No Forge installer found, downloading from %FORGE_URL%
        bitsadmin.exe /rawreturn /nowrap /transfer forgeinstaller /download /priority FOREGROUND %FORGE_URL% %INSTALLER%
    )
    
    echo Running Forge installer.
    %JAVA% -jar %INSTALLER% -installServer
)

if not exist "server.properties" (
    (
        echo allow-flight=true
        echo motd=All the Mods 9
        echo max-tick-time=180000
    )> "server.properties"
)

if %INSTALL_ONLY% == "true" (
    echo INSTALL_ONLY: complete
    goto:EOF
)

for /f tokens^=2-5^ delims^=.-_^" %%j in ('%JAVA% -fullversion 2^>^&1') do set "jver=%%j"
if not %jver% geq 17  (
    echo Minecraft %MINECRAFT_VERSION% requires Java 17 - found Java %jver%
    pause
    exit /b 1
)

:START
%JAVA% @user_jvm_args.txt @libraries/net/minecraftforge/forge/%MINECRAFT_VERSION%-%FORGE_VERSION%/win_args.txt nogui

if %RESTART% == "false" ( 
    goto:EOF 
)

echo Restarting automatically in 10 seconds (press Ctrl + C to cancel)
timeout /t 10 /nobreak > NUL
goto:START

PAUSE
EXIT

:EULA
ECHO Do you agree to the Mojang EULA available at https://account.mojang.com/documents/minecraft_eula?
SET /P "EULA=Y/N "
IF /I "%EULA%" EQU "y" (ECHO eula=true>eula.txt) ELSE (GOTO END)
GOTO START

:END
ECHO Somehow you screwed up.
PAUSE
