@ECHO OFF

SET JAVA="C:\Program Files\Java\jdk-21.0.3+9\bin\java.exe"

FOR %%i IN (.) DO SET "VERSION=%%~nxi"

IF NOT EXIST "_build\" MKDIR "_build"

IF EXIST "_build\BuildTools.jar" DEL "_build\BuildTools.jar"

IF EXIST "spigot-%VERSION%.jar" DEL "spigot-%VERSION%.jar"

CURL -o "BuildTools.jar" "https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"

MOVE "BuildTools.jar" "_build\BuildTools.jar"

CD "_build"

%JAVA% -jar "BuildTools.jar" --rev %VERSION%

CD ..

MOVE "_build\spigot-%VERSION%.jar" "spigot-%VERSION%.jar"


PAUSE