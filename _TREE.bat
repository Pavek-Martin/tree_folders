@echo off
del _TREE_folder__TREE_folder.txt
sleep 1
date /t > C:\Users\DELL\Documents\ps1\_TREE_folder\_TREE_folder__TREE_folder.txt
time /t >> C:\Users\DELL\Documents\ps1\_TREE_folder\_TREE_folder__TREE_folder.txt
tree /F /A C:\Users\DELL\Documents\ps1\_TREE_folder\ >> C:\Users\DELL\Documents\ps1\_TREE_folder\_TREE_folder__TREE_folder.txt
@echo on
REM pause
