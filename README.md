### Deye-exporter
# Deye inverter stats exporter to Prometheus metrics including basic webserver 

What this script does:
 - Gets data from a Deye invertor and provides Prometheus-ready metrics as a webpage, ready for scraping


This script requires installed [deye-controller](https://github.com/githubDante/deye-controller)
 
To create complete Graph, use [Grafana](https://grafana.com/docs/grafana/latest/setup-grafana/installation/) and [Prometheus](https://prometheus.io/docs/prometheus/latest/installation/)

How to configure
 - Edit translator.conf according to your needs

Tested on:
- SUN-12K-SG04LP3 

To find out the SN:
```
deye-scan 192.168.11.103
```

## To start as a service, do:

Edit ExecStart in deye-exporter.service according to your paths:

```vim deye-exporter.service```

Then:
```
cp -rp deye-exporter.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl start deye-exporter.service
sudo systemctl enable deye-exporter.service
sudo systemctl status deye-exporter.service
```

Potential issues:
 - Temp data is gathered from the Battery temperature probe and might be innacurate
