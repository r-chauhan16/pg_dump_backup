# pg_dump_backup
Take a dump backup of all test and prod environments using single script
Cloud support is on the way - Azure Blob storage using azcopy

The password file
It is required to setup the password file [.pgpass](https://www.postgresql.org/docs/current/libpq-pgpass.html) in order to run this scrit without prompt for each database password.
The file .pgpass in a user's home directory can contain passwords to be used if the connection requires a password (and no password has been specified otherwise). 
