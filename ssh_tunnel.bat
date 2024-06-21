::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFBBdXhGOAE+1EbsQ5+n//Najp14UU+w6as+TiP3AKeMcig==
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJhZksaHGQ=
::ZQ05rAF9IBncCkqN+0xwdVsFAlTMbAs=
::ZQ05rAF9IAHYFVzEqQIDBjJrZQqIOWiuCad8
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFBBdXhGOAE+/Fb4I5/jH/OSO70QTXuc8bIDJ5qedKN8H/0vqcJpj02Jf+A==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal enabledelayedexpansion

REM Check if the credentials file exists
if exist "credentials" (
    REM Read the stored username and IP address 
    for /f "tokens=1,2 delims=," %%A in (credentials) do (
        set "server_username=%%A"
        set "server_Public_IP=%%B"
    )

    REM Display stored credentials
    echo Using stored credentials
	echo:
    echo Server username : !server_username!
    echo Server public IP : !server_Public_IP!
	echo: 

) else (
    REM Prompt user for server username and public IP
    echo credentials not found. Prompting user for credentials...
	echo:
    set /p server_username="Please enter your server username: "
    set /p server_Public_IP="Please enter your server public IP: "
    
    REM Store the input values in a file
    echo !server_username!,!server_Public_IP! > "credentials"
	
	REM Make credentials.dat hidden
    attrib +h "credentials" 2>nul
    
    REM Display confirmation
    echo Credentials saved
	echo:
    echo Server username : !server_username!
    echo Server public IP : !server_Public_IP!
	echo: 

)

@echo off
REM Run Python script in the background
start /B python main.py

REM Wait for 3 seconds
timeout /T 3 /NOBREAK > NUL

REM Establish SSH connection
ssh -C -o "ProxyCommand=ncat --verbose --proxy 127.0.0.1:9092 %%h %%p" !server_username!@!server_Public_IP! -p 443 -v -CND 1080 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null

REM Pause to keep the command window open (optional)
pause

endlocal
