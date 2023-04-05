@echo off
if exist "output\hellmutation.pk3" del output\hellmutation.pk3
if not exist "temp" mkdir temp
if not exist "temp\acs" mkdir temp\acs
if not exist "temp\decorate" mkdir temp\decorate
if not exist "output" mkdir output
echo ==============================================================
utility\mcpp "acs\_main.acs" -o temp\acs\processed.acs -D ZDOOM -D IgnoreHash(x)=x -P
echo ==============================================================
utility\zmp -d decorate -a "temp\acs\processed.acs" -o temp\acs\zmp_processed.acs -p temp/decorate/decorate.txt -m zdoom -l HELLMUTATION_ACS
if not errorlevel 0 (
	pause
	exit
)
echo ==============================================================

utility\acc temp\acs\zmp_processed.acs temp\acs\HELLMUTATION_ACS
if exist "temp\acs\acs.err" (
	echo ==============================================================
	move /y temp\acs\acs.err acs_errors_zdoom.log	
	pause
) else (
	move /y temp\acs\HELLMUTATION_ACS.o temp\acs\HELLMUTATION_ACS

	cd data
	..\utility\7z u ..\temp\hellmutation-debug.pk3 * -xr!.svn  -mx0
	cd ..\temp
	..\utility\7z a ..\temp\hellmutation-debug.pk3 acs/HELLMUTATION_ACS -mx0
	cd ..
	gzdoom temp/hellmutation-debug.pk3
	exit
)
