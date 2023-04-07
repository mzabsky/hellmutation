@echo off
if exist "output\hellmutation.pk3" del output\hellmutation.pk3
if not exist "temp" mkdir temp
if not exist "temp\acs" mkdir temp\acs
if not exist "temp\decorate" mkdir temp\decorate
if not exist "output" mkdir output

echo ==============================================================

utility\acc acs\_main.acs temp\acs\HELLMUTATION_ACS
if exist "temp\acs\acs.err" (
	echo ==============================================================
	move /y temp\acs\acs.err acs_errors_zdoom.log	
	pause
) else (
	move /y temp\acs\HELLMUTATION_ACS.o temp\acs-zdoom\acs\HELLMUTATION_ACS

	cd data
	..\utility\7z a ..\output\hellmutation.pk3 * -xr!.svn -mx0
	cd ..\acs
	..\..\utility\7z a ..\..\output\hellmutation.pk3 acs\RGH_ACS -mx0
	cd ..\decorate
	..\..\utility\7z u ..\..\output\hellmutation.pk3 decorate.txt -mx0
	cd  ..\..
	exit
)
