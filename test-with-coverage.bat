setlocal
if "%BUILD_CONFIGURATION%" == "" set BUILD_CONFIGURATION=Debug
set BUILD_TARGET=%BUILD_CONFIGURATION%
set PATH=%~dp0\.node;%PATH%
set NUNIT=packages\NUnit.ConsoleRunner.3.5.0\tools\nunit3-console.exe
set OPENCOVER=packages\OpenCover.4.6.519\tools\OpenCover.Console.exe
set REPORT_GEN=packages\ReportGenerator.2.4.5.0\tools\ReportGenerator.exe
set TOCOBERTURA=packages\OpenCoverToCoberturaConverter.0.2.4.0\tools\OpenCoverToCoberturaConverter.exe
set TEST_TARGETS=%PACKAGE_NAME%.Tests\bin\%BUILD_TARGET%\%PACKAGE_NAME%.Tests.dll
set NAMESPACE_FILTERS=+[*]* -[FluentAssertions*]* -[FluentValidation*]* -[Microsoft*]*
set ATTRIBUTE_FILTERS=*GeneratedCode*;*ExcludeFromCodeCoverage*
if /I "%1"=="no_ui" set NO_UI=--where:cat!=ui

mkdir Reports\Coverage
del /Q /S Reports

%OPENCOVER% -register:user "-target:%NUNIT%" "-targetargs:%TEST_TARGETS% --result:Reports\TestResults.xml;format=nunit2 %NO_UI%" -output:Reports\OpenCover.xml -filter:"%NAMESPACE_FILTERS%" -excludebyattribute:%ATTRIBUTE_FILTERS%

%TOCOBERTURA% -input:Reports\OpenCover.xml -output:Reports\cobertura.xml -sources:.
%REPORT_GEN% -reports:Reports\OpenCover.xml -targetdir:Reports\Coverage\Server

endlocal