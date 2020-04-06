using module "..\ORCA.psm1"

class ORCA108 : ORCACheck
{
    <#
    
        CONSTRUCTOR with Check Header Data
    
    #>

    ORCA108()
    {
        $this.Control="108"
        $this.Area="DKIM"
        $this.Name="Signing Configuration"
        $this.PassText="DKIM signing is set up for all your custom domains"
        $this.FailRecommendation="Set up DKIM signing to sign your emails"
        $this.Importance="DKIM signing can help protect the authenticity of your messages in transit and can assist with deliverability of your email messages."
        $this.ExpandResults=$True
        $this.ItemName="Domain"
        $this.DataType="Signing Setting"
        $this.Links= @{
            "Use DKIM to validate outbound email sent from your custom domain in Office 365"="https://docs.microsoft.com/en-us/microsoft-365/security/office-365-security/use-dkim-to-validate-outbound-email"
        }
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {

        # Check DKIM is enabled
    
        ForEach($AcceptedDomain in $Config["AcceptedDomains"]) 
        {
    
            If($AcceptedDomain.Name -notlike "*.onmicrosoft.com") 
            {
    
                # Check objects
                $ConfigObject = [ORCACheckConfig]::new()
                $ConfigObject.ConfigItem=$($AcceptedDomain.Name)

                # Get matching DKIM signing configuration
                $DkimSigningConfig = $Config["DkimSigningConfig"] | Where-Object {$_.Name -eq $AcceptedDomain.Name}
    
                If($DkimSigningConfig)
                {
                    $ConfigObject.ConfigData=$($DkimSigningConfig.Enabled)

                    if($DkimSigningConfig.Enabled -eq $true)
                    {
                        $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Pass")
                    }
                    Else 
                    {
                        $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
                    }
                }
                Else
                {
                    $ConfigObject.ConfigData="No Configuration"
                    $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
                }

                # Add config to check
                $this.AddConfig($ConfigObject)
    
            }
    
        }           

    }

}