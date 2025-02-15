
#Variables that need to be set for each run

#$startFolder = "C:\Program Files" # The starting folder to analyze

$delka_args = $args.length
#echo "celkem args $delka_args"
 
if ($delka_args -clike 0) {
#echo "zadny argument"
#echo "zadej cestu k adresari jako argument 0"
#echo "napr."
echo 'mytree "C:\Users\DELL\Pictures\Saved Pictures"'
echo 'mytree "C:\GOG Games"'
echo "mytree C:\Users\DELL\Documents\ps1"
sleep 1
Exit
}

$startFolder = $args[0]
#echo $startFolder
#sleep 3
#Exit

#$startFolder = "C:\GOG Games\" # zde meni cestu <<<<<

#$sourceHTMLFile = "C:\work\final.html" # The html source template file
#$destinationHTMLFile = "C:\work\final.html" # The final html file that will be produced, #does not need to exist

#$sourceHTMLFile = "R:\finalTemplate.html" # The html source template file

$sourceHTMLFile = "R:\"
#$sourceHTMLFile += "aaa"

$dat = $startFolder
$d_dat = $dat.Length
$new = ""

for ($aa = 0; $aa -le $d_dat; $aa++){
$znak = $dat[$aa]

if (( $znak -eq "\" ) -or ( $znak -eq ":" ) -or ( $znak -eq " " )) {
$new += "_"
}else{
$new += $znak
}
}

#echo $dat
#echo $new
$sourceHTMLFile += $new
$sourceHTMLFile += ".html"

echo "TREE $startFolder >>> $sourceHTMLFile"

#$destinationHTMLFile = "R:\final.html" # The final html file that will be produced, #does not need to exist
 
$htmlLines = @();
 
#Function that creates a folder detail record
function CreateFolderDetailRecord
{
    param([string]$FolderPath)
    
    #Get the total size of the folder by recursively summing its children
    $subFolderItems = Get-ChildItem $FolderPath -recurse -force | Where-Object {$_.PSIsContainer -eq $false} | Measure-Object -property Length -sum | Select-Object Sum
    $folderSizeRaw = 0;
    $folderSize = 0;
    $units = "";
 
    #Account for no children
    if($subFolderItems.sum -gt 0)
    {
        $folderSizeRaw = $subFolderItems.sum;     
    }    
 
    #Determine units for a more friendly output
    if(($subFolderItems.sum / 1GB) -ge 1)
    {
        $units = "GB"
        $folderSize = [math]::Round(($subFolderItems.sum / 1GB),2)
    }
    else
    {
        if(($subFolderItems.sum / 1MB) -ge 1)
        {
            $units = "MB"
            $folderSize = [math]::Round(($subFolderItems.sum / 1MB),2)
        }
        else
        {
            $units = "KB"
            $folderSize = [math]::Round(($subFolderItems.sum / 1KB),2)
        }
    }
 
    #Create an object with the given properties
    $newFolderRecord = New-Object –TypeName PSObject
    $newFolderRecord | Add-Member –MemberType NoteProperty –Name FolderPath –Value $FolderPath;
    $newFolderRecord | Add-Member –MemberType NoteProperty –Name FolderSizeRaw –Value $folderSizeRaw
    $newFolderRecord | Add-Member –MemberType NoteProperty –Name FolderSizeInUnits –Value $folderSize;
    $newFolderRecord | Add-Member –MemberType NoteProperty –Name Units –Value $units;
 
    return $newFolderRecord;
}
 
#Function that recursively creates the html for the output, given a starting location
function GetAllFolderDetails
{
    param([string]$FolderPath)    
 
    $recursiveHTML = @();
 
    #Get properties used for processing
    $folderItem = Get-Item -Path $FolderPath
    $folderDetails = CreateFolderDetailRecord -FolderPath $FolderPath
    $subFolders = Get-ChildItem $FolderPath | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object
 
    #If has subfolders, create hmtl drilldown. 
    if($subFolders.Count -gt 0)
    {
        $recursiveHTML += "<li><span class='caret'>" + $folderItem.Name + " (<span style='color:red'>" + $folderDetails.FolderSizeInUnits + " " + $folderDetails.Units + "</span>)" + "</span>"
        $recursiveHTML += "<ul class='nested'>"
    }
    else
    {
        $recursiveHTML += "<li>" + $folderItem.Name + " (<span style='color:red'>" + $folderDetails.FolderSizeInUnits + " " + $folderDetails.Units + "</span>)";
    }
 
    #Recursively call this function for all subfolders
    foreach($subFolder in $subFolders)
    {
        $recursiveHTML += GetAllFolderDetails -FolderPath $subFolder.FullName;
    }
 
    #Close up all tags
    if($subFolders.Count -gt 0)
    {
        $recursiveHTML += "</ul>";
    }
 
    $recursiveHTML += "</li>";
    
    return $recursiveHTML
}
 
#Processing Starts Here
 
#Opening html
$htmlLines += "<ul id='myUL'>"
 
#This function call will return all of the recursive html for the startign folder and below
$htmlLines += GetAllFolderDetails -FolderPath $startFolder
 
#Closing html
$htmlLines += "</ul>"

# zde moje radky
#Set-Content -Path $sourceHTMLFile -Encoding ASCII -Value $htmlLines
$htmlLines_2 = "<b>"
$htmlLines_2 = "TREE "
$htmlLines_2 += $startFolder
$htmlLines_2 += "</b>"

$htmlLines_2 += $htmlLines


#Set-Content -Path $sourceHTMLFile -Value $htmlLines
Set-Content -Path $sourceHTMLFile -Value $htmlLines_2
sleep 2

<#
#Get the html template, replace the template with generated code and write to the final html file
$sourceHTML = Get-Content -Path $sourceHTMLFile
$destinationHTML = $sourceHTML.Replace("[FinalHTML]", $htmlLines)
$destinationHTML | Set-Content $destinationHTMLFile
#>

echo "hotovo"
sleep 1

