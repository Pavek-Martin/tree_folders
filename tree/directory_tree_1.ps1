cls

$delka_args = $args.length
echo "celkem args $delka_args"
 
if ($delka_args -clike 0) {
echo "zadny argument"
echo "zadej cestu k adresari jako argument 0"
sleep 3
Exit
}

$cesta = $args[0]

#$cesta = "C:\Users\DELL\Documents\Dos\"
#$cesta = "C:\Users\DELL\Documents\ps1\"

function tree {

   [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
   [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

   # create Window
   $Form = New-Object System.Windows.Forms.Form
   $Form.Text = "Files"
   $Form.Size = New-Object System.Drawing.Size(390, 390)
   # create Treeview-Object
   $TreeView = New-Object System.Windows.Forms.TreeView
   $TreeView.Location = New-Object System.Drawing.Point(48, 12)
   $TreeView.Size = New-Object System.Drawing.Size(290, 322)
   $Form.Controls.Add($TreeView)

   ###### Add Nodes to Treeview
   $rootnode = New-Object System.Windows.Forms.TreeNode
   $rootnode.text = "Root"
   $rootnode.name = "Root"
   [void]$TreeView.Nodes.Add($rootnode)

   #here i'm going to import the csv file into an array
   #$array=@(Get-ChildItem -Path D:\personalWorkspace\node)
   $array=@(Get-ChildItem -Path $cesta)
   Write-Host $array
   foreach ( $obj in $array ) {                                                                                                             
        Write-Host $obj
        $subnode = New-Object System.Windows.Forms.TreeNode
        $subnode.text = $obj
        [void]$rootnode.Nodes.Add($subnode)
     }

   # Show Form // this always needs to be at the bottom of the script!
   $Form.Add_Shown({$Form.Activate()})
   [void] $Form.ShowDialog()

   }

   tree
