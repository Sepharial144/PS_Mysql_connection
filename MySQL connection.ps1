# Connection variables 
$user = 'power' 
$pass = 'Shell!!!' 
$database = 'db_name' 
$MySQLHost = '192.168.0.1'
$Global:connMySQL ="server=" + $MySQLHost + ";port=3306;uid=" + $user + ";pwd=" + $pass + ";database="+$database+";Pooling=FALSE"

#-------------------------------------------------------Functions-----------------------------------------------------------------

# Connection to MySQL Server
function Connect-MySQL([string]$user,[string]$pass,[string]$MySQLHost,[string]$database) {
  # Load MySQL .NET Connector Objects 
  [void][system.reflection.Assembly]::LoadWithPartialName("MySql.Data") 

  # Open Connection 
  $conn = New-Object MySql.Data.MySqlClient.MySqlConnection($connMySQL) 
  $conn.Open() 
  return $conn 
} 

# Erase connect
function Disconnect-MySQL($conn) {
  $conn.Close()
}

# Query
function Execute-MySQLQuery([string]$query) { 
  # NonQuery - Insert/Update/Delete query where no return data is required
  $cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connMySQL)    # Create SQL command
  $dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($cmd)      # Create data adapter from query command
  $dataSet = New-Object System.Data.DataSet                                    # Create dataset
  $dataAdapter.Fill($dataSet, "data")                                          # Fill dataset from data adapter, with name "data"              
  $cmd.Dispose()
  return $dataSet.Tables["data"]                                               # Returns an array of results
}

#-------------------------------------------------------Point of start program----------------------------------------------------

# Initiate connect
$Connection = Connect-MySQL($user, $pass, $MySQLHost, $database)

# Form query
$query = "SELECT id, surname, name, patronymic FROM users;"

# Execute data
$Request = Execute-MySQLQuery $query


# Get count rows of result
$countRows = $Request.Count

# Show result
for ($i = 1; $i -lt $countRows; $i++) {

    Write-host $Request[$i].id
    Write-host $Request[$i].surname
    Write-host $Request[$i].name
    Write-host $Request[$i].patronymic

}

# Disconnect
Disconnect-MySQL($Connection)