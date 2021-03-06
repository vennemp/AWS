$allSGs=Get-EC2SecurityGroup
$alleni=Get-EC2NetworkInterface
$SGarray = @()
$ExportCSVPath = 'C:\Users\Matt Venne\desktop\sg.csv'
foreach ($sg in $allSGs) {
if ($alleni.groups.groupid -contains $sg.GroupId) #checks if sg is in use
{$InUse = "true"}
else 
{$InUse = "false"}
        foreach ($rule in $sg.IpPermission)
            {
            foreach ($cidr in $rule.Ipv4Ranges){
                if ($rule.ToPort -eq $rule.FromPort) #for single ports 
                {
                    $SGentry= [ordered]@{
                        GroupID = $sg.GroupId;
                        GroupName = $sg.GroupName;
                        Port = $rule.ToPort
                        SourceCidr = $cidr.CidrIp
                        CidrSourceDescription = $cidr.Description
                        InUse = $InUse
                        SourceSG = $rule.UserIdGroupPairs.groupid
                        SGSourceDescription = $rule.UserIdGroupPairs.description

                    }
                }
                if ($rule.ToPort -ne $rule.FromPort) #for port ranges
                {
                    $SGentry= [ordered]@{
                        GroupID = $sg.GroupId;
                        GroupName = $sg.GroupName;
                        Port = $rule.fromPort.ToString() + "-" + $rule.ToPort.ToString()
                        SourceCidr = $cidr.CidrIp
                        CidrSourceDescription = $cidr.Description
                        InUse = $InUse
                        SourceSG = $rule.UserIdGroupPairs.groupid
                        SGSourceDescription = $rule.UserIdGroupPairs.description

                    }
                }
                $sgarray += New-Object -TypeName psobject -property $SGentry
                }

        }
}
$SGarray | export-csv -path $ExportCSVPath -NoTypeInformation
