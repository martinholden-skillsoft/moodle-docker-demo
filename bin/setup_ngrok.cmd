@ECHO OFF

echo.
echo **************************************************
echo *** Running: %~n0%~x0
echo.

PUSHD %cd%
CD %~dp0..
SET BASEDIR=%cd%
POPD

START ngrok http http://127.0.0.1:8000

TIMEOUT /T 10 /NOBREAK

For /F "Delims=" %%A In ('"curl -s http://localhost:4040/api/tunnels/command_line | jq-win64 .public_url"') Do Set "MOODLE_DOCKER_NGROK_HOST=%%~A"

IF NOT "%MOODLE_DOCKER_NGROK_HOST%"=="" (
    echo.
    echo ***Bring Docker Containers Down
    echo.
    call %BASEDIR%\bin\moodle-docker-compose down
    echo.
    echo ***Bring Docker Containers Up
    echo.
    call %BASEDIR%\bin\moodle-docker-compose up -d
    echo.
    echo.
    echo *** Moodle is available via NGROK. Browse to - %MOODLE_DOCKER_NGROK_HOST%
    echo.
    echo *** Moodle Admin Username: admin
    echo *** Moodle Admin password: test
    echo.
    GOTO FINISH
)

:PROBLEM
echo.
echo *** There was a problem setting up NGROK

:FINISH
