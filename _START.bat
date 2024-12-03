@ECHO OFF

SET JAVA="C:\Program Files\Java\jdk-21.0.3+9\bin\java.exe"

IF NOT EXIST eula.txt GOTO EULA

:START

FOR %%i IN (.) DO SET "VERSION=%%~nxi"

%JAVA% -jar "spigot-%VERSION%.jar" nogui

EXIT





:EULA
ECHO Do you agree to the Mojang EULA available at https://account.mojang.com/documents/minecraft_eula?
SET /P "EULA=Y/N "
IF /I "%EULA%" EQU "y" (ECHO eula=true>eula.txt) ELSE (GOTO END)
GOTO START

:END
ECHO Somehow you screwed up.
PAUSE