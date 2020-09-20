
[cmdletBinding()]
Param()

function Install-RepositorioRemoto {                 
       
    Write-Verbose "Registrando Repositorio"
    $repo = @{
        Name                 = 'SESUMRepositorio'
        SourceLocation       = '\\10.11.40.30\PowershellRepo'
        ScriptSourceLocation = '\\10.11.40.30\PowershellRepo'
        InstallationPolicy   = 'Trusted'
    }
    Register-PSRepository @repo
           
      
}


function Add-CompartilhamentoRepositorioRemoto { 
    $usuario = 'ZNE-MA001\remoto'
    $secpasswd = ConvertTo-SecureString 'GOLDConecta20' -AsPlainText -Force
    $mycreds = New-Object System.Management.Automation.PSCredential($usuario, $secpasswd)
            
    Write-Verbose "Montando o compartilhamento do Repositorio"
    New-PSDrive -Name G -Root '\\10.11.40.30\PowerShellRepo' -PSProvider FileSystem -Scope Global -Credential $mycreds 
}

Write-Verbose "Inicializando o instalador do repositorio remoto"
Write-Verbose "Verificando repositório SESUMRepositorio"
$repositorio = Get-PSRepository -Name SESUMRepositorio -ErrorAction SilentlyContinue
if (-Not($repositorio)) {
    Write-Verbose "SESUMRepositorio não instalado."
    Write-Verbose "Verificando drive G ..."
    if (-Not(Get-PSDrive -Name G -ErrorAction SilentlyContinue)) {
        Write-Verbose 'Driver G não encontrado'      
        Write-Verbose 'Verificando conexão com 10.11.40.30 ...'
        if (-Not(Test-Connection -ComputerName 10.11.40.30 -ErrorAction SilentlyContinue)) {
            Write-Verbose 'Sem conexão com o servidor 10.11.40.30'
            Write-Host 'Falha na instalação do repositorio'
            exit
        }
        else {
            Write-Verbose "Conexão com 10.11.40.30 OK."
            Write-Verbose 'Montando compartilhamento \\10.11.40.30\PowersehllRemoto'
            Add-CompartilhamentoRepositorioRemoto
        }
    }
    Write-Verbose 'Drive G ok!.'
    Write-Verbose 'Instalando Repositorio remoto'
    Install-RepositorioRemoto
    Write-Host "Repositorio SESUMRepositorio instalado !"

}
else {
    Write-Verbose 'Repositório SESUMRepositorio já instalado.'
    Write-Host 'Repositorio SESUMRepositorio já instalado.'
}


