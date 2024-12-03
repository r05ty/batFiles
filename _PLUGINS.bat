CURL -o "mcMMO.jar" "https://popicraft.net/jenkins/job/mcMMO/lastSuccessfulBuild/artifact/target/mcMMO.jar"

IF EXIST "mcMMO.jar" IF EXIST "plugins\mcMMO.jar" DEL "plugins\mcMMO.jar"

IF EXIST "mcMMO.jar" MOVE "mcMMO.jar" "plugins\mcMMO.jar"


PAUSE