# Sitecore Azure Kudu Tools PowerShell Module [![Inline docs](https://img.shields.io/badge/Version-1.0.1-brightgreen.svg)](#)

![SAKT](https://repository-images.githubusercontent.com/181915830/893fe980-686a-11e9-8ae0-f453d3685f23)


A collection of commands to obtain information from Sitecore instances on Azure PaaS via Kudu.

Open for contributions! [![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/strezag/sitecore-azure-kudu-tools/issues)

[View Docs](https://strezag.github.io/sitecore-azure-kudu-tools/#Get-SitecoreFileBackup)

# Installation  [![Inline docs](https://img.shields.io/badge/Install-%F0%9F%91%8D%20-blue.svg)](#)

## PowerShell Gallery

[PowerShell Gallery](https://www.powershellgallery.com/packages/SitecoreAzureKuduTools/1.0.1)

```sh
Install-Module -Name SitecoreAzureKuduTools
```

# Functions [![Inline docs](https://img.shields.io/badge/Usage-%F0%9F%A4%99-blue.svg)](#)


<div class="col-lg-9 col-md-8 col-sm-7 col-xs-12">
				<div id="Get-SitecoreFileBackup" class="toggle_container check_list_selected" style="display: none;">
					<div class="page-header">
						<h2> Get-SitecoreFileBackup <img src="https://img.shields.io/badge/function-%E2%9C%94-blue.svg" alt="function-badge"></img> </h2> 
						<p>Download full App Service file contents.</p>
						<p>This function will download all files from in a given Resource.</p>
					</div>
                        <div>
                        <h3> Syntax </h3>
                        </div>
						<div class="panel panel-default">
                            <div class="panel-body">
<div><div id="highlighter_126888" class="syntaxhighlighter nogutter  ps"><table border="0" cellpadding="0" cellspacing="0"><tbody><tr><td class="code"><div class="container"><div class="line number1 index0 alt2"><code class="ps plain">Get</code><code class="ps keyword">-SitecoreFileBackup</code> <code class="ps plain">[</code><code class="ps keyword">-ResourceSubscriptionId</code><code class="ps plain">] &lt;String&gt; [</code><code class="ps keyword">-ResourceGroupName</code><code class="ps plain">] &lt;String&gt; [</code><code class="ps keyword">-ResourceName</code><code class="ps plain">] &lt;String&gt; </code></div><div class="line number2 index1 alt1"><code class="ps plain">[&lt;CommonParameters&gt;]</code></div></div></td></tr></tbody></table></div></div>
                            </div>
						</div>
						<div>
							<h3> Parameters </h3>
							<table class="table table-striped table-bordered table-condensed visible-on">
								<thead>
									<tr>
										<th>Name</th>
                                        <th class="visible-lg visible-md">Alias</th>
										<th class="visible-lg visible-md">Required?</th>
										<th class="visible-lg">Pipeline Input</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td><nobr>-ResourceSubscriptionId</nobr></td>
                                        <td class="visible-lg visible-md">ID</td>
										<td class="visible-lg visible-md">true</td>
										<td class="visible-lg">false</td>
									</tr>
									<tr>
										<td><nobr>-ResourceGroupName</nobr></td>
                                        <td class="visible-lg visible-md">Group</td>
										<td class="visible-lg visible-md">true</td>
										<td class="visible-lg">false</td>
									</tr>
									<tr>
										<td><nobr>-ResourceName</nobr></td>
                                        <td class="visible-lg visible-md">Name</td>
										<td class="visible-lg visible-md">true</td>
										<td class="visible-lg">false</td>
									</tr>
								</tbody>
							</table>
						</div>				
                        <div>
                            <h3> Examples </h3>
                        </div>
						<div class="panel panel-default">
                            <div class="panel-body">
							    <strong>EXAMPLE 1</strong>
<div><div id="highlighter_741205" class="syntaxhighlighter nogutter  ps "><table border="0" cellpadding="0" cellspacing="0"><tbody><tr><td class="code"><div class="container"><div class="line number1 index0 alt2"><code class="ps plain">Get</code><code class="ps keyword">-SitecoreFileBackup</code> <code class="ps keyword">-ResourceSubscriptionId</code> <code class="ps string">"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"</code>&nbsp; <code class="ps keyword">-ResourceGroupName</code> <code class="ps string">"xx-xxxxxxxxxx-XP2-SMALL-PRD1"</code> <code class="ps keyword">-ResourceName</code> <code class="ps string">"xx-xxxxxxxxxx-xp2-small-prd1-cd"</code></div></div></td></tr></tbody></table></div></div>
							    <div></div>
							    <strong>EXAMPLE 2</strong>
<div><div id="highlighter_383932" class="syntaxhighlighter nogutter  ps"><table border="0" cellpadding="0" cellspacing="0"><tbody><tr><td class="code"><div class="container"><div class="line number1 index0 alt2"><code class="ps plain">Get</code><code class="ps keyword">-SitecoreFileBackup</code> <code class="ps keyword">-ID</code> <code class="ps string">"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"</code>&nbsp; <code class="ps keyword">-Group</code> <code class="ps string">"xx-xxxxxxxxxx-XP2-SMALL-PRD1"</code> <code class="ps keyword">-Name</code> <code class="ps string">"xx-xxxxxxxxxx-xp2-small-prd1-cd"</code></div></div></td></tr></tbody></table></div></div>
							    <div></div>
                            </div>
						</div>
                        </div>
				<div id="Get-SitecoreSupportPackage" class="toggle_container" style="display: block;">
					<div class="page-header">
						<h2> Get-SitecoreSupportPackage <img src="https://img.shields.io/badge/function-%E2%9C%94-blue.svg" alt="function-badge"></img></h2>
						<p>Remotely generate a Sitecore Support Package</p>
						<p>This function will download and zip files defined for Sitecore Support Packages: <br>https://kb.sitecore.net/articles/406145<br>&gt; \App_Config\*<br>&gt; \Logs\*<br>&gt; eventlog.xml<br>&gt; Global.asax<br>&gt; license.xml<br>&gt; sitecore.version.xml<br>&gt; Web.config</p>
					</div>
                        <div>
                        <h3> Syntax </h3>
                        </div>
						<div class="panel panel-default">
                            <div class="panel-body">
<div><div id="highlighter_341443" class="syntaxhighlighter nogutter  ps"><table border="0" cellpadding="0" cellspacing="0"><tbody><tr><td class="code"><div class="container"><div class="line number1 index0 alt2"><code class="ps plain">Get</code><code class="ps keyword">-SitecoreSupportPackage</code> <code class="ps plain">[</code><code class="ps keyword">-ResourceSubscriptionId</code><code class="ps plain">] &lt;String&gt; [</code><code class="ps keyword">-ResourceGroupName</code><code class="ps plain">] &lt;String&gt; [</code><code class="ps keyword">-ResourceName</code><code class="ps plain">] &lt;String&gt; </code></div><div class="line number2 index1 alt1"><code class="ps plain">[</code><code class="ps keyword">-LogDaysBack</code><code class="ps plain">] &lt;Int32&gt; [&lt;CommonParameters&gt;]</code></div></div></td></tr></tbody></table></div></div>
                            </div>
						</div>
						<div>
							<h3> Parameters </h3>
							<table class="table table-striped table-bordered table-condensed visible-on">
								<thead>
									<tr>
										<th>Name</th>
                                        <th class="visible-lg visible-md">Alias</th>
										<th class="visible-lg visible-md">Required?</th>
										<th class="visible-lg">Pipeline Input</th>
                    <th class="visible-lg">Default Value</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td><nobr>-ResourceSubscriptionId</nobr></td>
                                        <td class="visible-lg visible-md">ID</td>
										<td class="visible-lg visible-md">true</td>
										<td class="visible-lg">false</td>
                    <td class="visible-lg"></td>
									</tr>
									<tr>
										<td><nobr>-ResourceGroupName</nobr></td>
                                        <td class="visible-lg visible-md">Group</td>
										<td class="visible-lg visible-md">true</td>
										<td class="visible-lg">false</td>
                                            <td class="visible-lg"></td>
									</tr>
									<tr>
										<td><nobr>-ResourceName</nobr></td>
                                        <td class="visible-lg visible-md">Name</td>
										<td class="visible-lg visible-md">true</td>
										<td class="visible-lg">false</td>
                    <td class="visible-lg"></td>
									</tr>
									<tr>
										<td><nobr>-LogDaysBack</nobr></td>
                                        <td class="visible-lg visible-md">LogDays</td>
										<td class="visible-lg visible-md">true</td>
										<td class="visible-lg">false</td>
										<td class="visible-lg">0</td>
									</tr>
								</tbody>
							</table>
						</div>				
                        <div>
                            <h3> Examples </h3>
                        </div>
						<div class="panel panel-default">
                            <div class="panel-body">
							    <strong>EXAMPLE 1</strong>
<div><div id="highlighter_528288" class="syntaxhighlighter nogutter  ps"><table border="0" cellpadding="0" cellspacing="0"><tbody><tr><td class="code"><div class="container"><div class="line number1 index0 alt2"><code class="ps plain">Get</code><code class="ps keyword">-SitecoreSupportPackage</code> <code class="ps keyword">-ResourceSubscriptionId</code> <code class="ps string">"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"</code>&nbsp; <code class="ps keyword">-ResourceGroupName</code> <code class="ps string">"xx-xxxxxxxxxx-XP2-SMALL-PRD1"</code> <code class="ps keyword">-ResourceName</code> <code class="ps string">"xx-xxxxxxxxxx-xp2-small-prd1-cd"</code> <code class="ps keyword">-LogDaysBack</code> <code class="ps plain">1</code></div></div></td></tr></tbody></table></div></div>
							    <div></div>
							    <strong>EXAMPLE 2</strong>
<div><div id="highlighter_376227" class="syntaxhighlighter nogutter  ps"><table border="0" cellpadding="0" cellspacing="0"><tbody><tr><td class="code"><div class="container"><div class="line number1 index0 alt2"><code class="ps plain">Get</code><code class="ps keyword">-SitecoreSupportPackage</code> <code class="ps keyword">-ID</code> <code class="ps string">"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"</code>&nbsp; <code class="ps keyword">-Group</code> <code class="ps string">"xx-xxxxxxxxxx-XP2-SMALL-PRD1"</code> <code class="ps keyword">-Name</code> <code class="ps string">"xx-xxxxxxxxxx-xp2-small-prd1-cd"</code> <code class="ps keyword">-LogDays</code> <code class="ps plain">1</code></div></div></td></tr></tbody></table></div></div>
							    <div></div>
                            </div>
                        </div>
                    </div>
				<div id="Invoke-SitecoreThumbprintValidation" class="toggle_container" style="display: none;">
					<div class="page-header">
						<h2> Invoke-SitecoreThumbprintValidation <img src="https://img.shields.io/badge/function-%E2%9C%94-blue.svg" alt="function-badge"></img></h2>
						<p>Verify Certificate Thumbprints across Sitecore Azure PaaS using Kudu</p>
						<p>This function will download ConnectionStrings.config and AppSettings.config files from all App Services in a given <br>Resource Group, then display any certificate thumbprints discrepencies.</p>
					</div>
                        <div>
                        <h3> Syntax </h3>
                        </div>
						<div class="panel panel-default">
                            <div class="panel-body">
<div><div id="highlighter_704008" class="syntaxhighlighter nogutter  ps"><table border="0" cellpadding="0" cellspacing="0"><tbody><tr><td class="code"><div class="container"><div class="line number1 index0 alt2"><code class="ps plain">Invoke</code><code class="ps keyword">-SitecoreThumbprintValidation</code> <code class="ps plain">[</code><code class="ps keyword">-ResourceSubscriptionId</code><code class="ps plain">] &lt;String&gt; [</code><code class="ps keyword">-ResourceGroupName</code><code class="ps plain">] &lt;String&gt; </code></div><div class="line number2 index1 alt1"><code class="ps plain">[&lt;CommonParameters&gt;]</code></div></div></td></tr></tbody></table></div></div>
                            </div>
						</div>
						<div>
							<h3> Parameters </h3>
							<table class="table table-striped table-bordered table-condensed visible-on">
								<thead>
									<tr>
										<th>Name</th>
                                        <th class="visible-lg visible-md">Alias</th>
										<th class="visible-lg visible-md">Required?</th>
										<th class="visible-lg">Pipeline Input</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td><nobr>-ResourceSubscriptionId</nobr></td>
                                        <td class="visible-lg visible-md">ID</td>
										<td class="visible-lg visible-md">true</td>
										<td class="visible-lg">false</td>
                  </tr>
									<tr>
										<td><nobr>-ResourceGroupName</nobr></td>
                                        <td class="visible-lg visible-md">Group</td>
										<td class="visible-lg visible-md">true</td>
										<td class="visible-lg">false</td>
                  </tr>
								</tbody>
							</table>
						</div>				
                        <div>
                            <h3> Examples </h3>
                        </div>
						<div class="panel panel-default">
                            <div class="panel-body">
							    <strong>EXAMPLE 1</strong>
<div><div id="highlighter_190355" class="syntaxhighlighter nogutter  ps"><table border="0" cellpadding="0" cellspacing="0"><tbody><tr><td class="code"><div class="container"><div class="line number1 index0 alt2"><code class="ps plain">Invoke</code><code class="ps keyword">-SitecoreThumbprintValidation</code> <code class="ps keyword">-ResourceSubscriptionId</code> <code class="ps string">"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"</code> <code class="ps keyword">-ResourceGroupName</code> <code class="ps string">"xx-xxxxxxxxxx-XP2-SMALL-PRD1"</code></div></div></td></tr></tbody></table></div></div>
							    <div></div>
							    <strong>EXAMPLE 2</strong>
<div><div id="highlighter_156993" class="syntaxhighlighter nogutter  ps"><table border="0" cellpadding="0" cellspacing="0"><tbody><tr><td class="code"><div class="container"><div class="line number1 index0 alt2"><code class="ps plain">Invoke</code><code class="ps keyword">-SitecoreThumbprintValidation</code> <code class="ps keyword">-ID</code> <code class="ps string">"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"</code> <code class="ps keyword">-Group</code> <code class="ps string">"xx-xxxxxxxxxx-XP2-SMALL-PRD1"</code></div></div></td></tr></tbody></table></div></div>
							    <div></div>
                            </div>
						</div>
</div>
		</div>

# Contribute [![contributions welcome](https://img.shields.io/badge/Contibutions-👩‍💻-blue.svg?style=flat)](https://github.com/strezag/sitecore-azure-kudu-tools/issues) 


## Local Setup
##### 1 - Uninstall the PowerShell Gallery Module
```
Remove-Module SitecoreAzureKuduTools -Force -ErrorAction SilentlyContinue
Uninstall-Module SitecoreAzureKuduTools -Force -ErrorAction SilentlyContinue
```

##### 2 - Clone the repository 

##### 3 - Open PowerShell as an Administrator

##### 4 - Navigate to a PowerShell Environment Path: 
```
cd "$($Env:PSModulePath.split(';')[1])"
```
##### 5 - Create a new folder in your module path directory called: 'saktdev'
``` 
mkdir saktdev
```
##### 6- Create a new folder in your module path directory called: 'saktdev' and navigate to it
```
mkdir saktdev
cd .\saktdev\
```

##### 7 - Create a new folder in your module path directory called: '1.0.1' and navigate to it
```
mkdir 1.0.1
cd .\1.0.1
```

##### 8 - Copy contents of the repository to the .\saktdev\1.0.1\ directory
```
robocopy "C:\gitcode\sitecore-azure-kudu-tools\" "$(Get-Location)"
```

 ##### 9 - Import the module

```
Import-Module .\SitecoreAzureKuduTools.psd1
```

##### 10 - Verify functions are loading 
