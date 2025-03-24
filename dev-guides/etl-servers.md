# ETL Servers
We have three ETL servers that can be accessed using a remote desktop connection with login credentials that have permission to access them.

|Server Name|Environment|Network Drive|
|-----------|-----------|-------------|
|Amleth|Development|\\amleth.idir.bcgov\e$|
|Aurelia|Test|\\aurelia.idir.bcgov\e$|
|Haakon|Production|\\haakon.idir.bcgov\e$|

## Proxies
You must configure your proxy settings on Servers to access the internet. Ask someone who manages the servers for a proxy address and port. Then, Go to: `Settings > Proxy > Manual proxy setup` on the server to set it up.

Turn off your proxy server to login to DataStage using a shared account, like isadmin or CDW_ETL_Admin. You will not be able to login to these accounts if you are using a proxy server.