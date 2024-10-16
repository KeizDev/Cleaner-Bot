@echo off
color 0A

echo.
echo ================================
echo         Outil Keiz
echo      Installation des bibliotheques
echo ================================
echo.

echo Verification de l'installation de Python...
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python n'est pas installe. Veuillez installer Python 3.12 ou superieur avant de continuer.
    pause
    exit /b
) else (
    echo Python est installe ! 
)

for /f "tokens=2" %%i in ('python --version') do set PYTHON_VERSION=%%i
echo Version de Python detectee : %PYTHON_VERSION%
echo Verification si Python est a jour...
if "%PYTHON_VERSION:~0,3%" NEQ "3.1" (
    echo Votre version de Python est inferieure a 3.12. Veuillez mettre a jour Python.
    pause
    exit /b
)

echo Verification de l'installation de pip...
where pip >nul 2>nul
if %errorlevel% neq 0 (
    echo Pip n'est pas installe. Installation de pip...
    python -m ensurepip --upgrade
    if %errorlevel% neq 0 (
        echo Impossible d'installer pip. Veuillez l'installer manuellement.
        pause
        exit /b
    )
    echo Pip a ete installe avec succes !
)

for /f "tokens=2" %%i in ('pip --version') do set PIP_VERSION=%%i
echo Version de pip detectee : %PIP_VERSION%
echo Verification si pip est a jour...
pip install --upgrade pip

echo.
echo Installation/Actualisation des bibliotheques necessaires...
pip install --upgrade discord.py colorama

if %errorlevel% neq 0 (
    echo Echec de l'installation des bibliotheques. Veuillez verifier votre connexion Internet et reessayer.
    pause
    exit /b
)

echo.
echo ================================
echo      Installation terminee !
echo ================================
echo Toutes les bibliotheques necessaires ont ete installees ou mises a jour avec succes.
echo Vous pouvez maintenant utiliser l'outil Keiz.
echo.

echo @echo off > runCleaner.bat
echo python cleanerBot.py >> runCleaner.bat
echo Fichier runCleaner.bat cree avec succes.

set SHORTCUT_NAME=Cleaner
set SHORTCUT_PATH="%USERPROFILE%\Desktop\%SHORTCUT_NAME%.lnk"
set TARGET_PATH="%CD%\runCleaner.bat"
set ICON_PATH="%USERPROFILE%\Desktop\Cleaner\pic\icon.ico"  :: Chemin d'accès à l'icône

if not exist "%USERPROFILE%\Desktop\Cleaner\pic" (
    echo Le dossier pic n'existe pas. Veuillez vous assurer qu'il existe et contient l'icône.
    pause
    exit /b
)

if not exist %ICON_PATH% (
    echo L'icône %ICON_PATH% n'existe pas. Veuillez vérifier le chemin d'accès à l'icône.
    pause
    exit /b
)

echo Set oWS = WScript.CreateObject("WScript.Shell") > temp.vbs
echo sLinkFile = %SHORTCUT_PATH% >> temp.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> temp.vbs
echo oLink.TargetPath = %TARGET_PATH% >> temp.vbs
echo oLink.IconLocation = %ICON_PATH% >> temp.vbs
echo oLink.Save >> temp.vbs

cscript //nologo temp.vbs
del temp.vbs

echo Raccourci %SHORTCUT_NAME% cree sur le Bureau.

pause