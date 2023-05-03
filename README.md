<h1> Common Chart </h1>

This Helm Chart is a base chart that includes helpers/templates. The main goal is to make it easier to build/maintain Helm Charts of micro-services deployed on k8s. 

<h2> Contents </h2>

- [Getting Started](#getting-started)
- [Development](#development)
- [Chart Testing](#chart-testing)
- [Included Features](#included-features)
  - [Liveness/Readiness Probes](#livenessreadiness-probes)
  - [Autoscaling](#autoscaling)
  - [PodDisruptionBudget](#poddisruptionbudget)
  - [Metrics](#metrics)
  - [SLO](#slo)
  

# Getting Started

1. Create a folder for your chart with a `Chart.yaml`
2. Include this chart as a dependency
    ```yaml
    dependencies:
      - name: common
        version: ~>1.0.0
        repository: oci://ghcr.io/wdaan/common-chart
    ```
3. Copy the following into `templates/manifest.yaml`
   ```
   {{ include "common.all" . }}
   ```
4. Run `helm dep update`
5. Create a `values.yaml`-file and configure as desired, see `charts/myservice/tests/deployment-full.yaml` or the other test files for example configurations.

Take a look at the [example chart](/charts/myservice)

# Development

- `cd CHARTDIR`
- `helm dep build`
- `cd ..`
- `helm template MY_CHARTD_DIR`

# Chart Testing

The `charts/myservice/tests`-folder contains a couple of values files.
All of these are different configurations are tested against the common chart on every PR.

# Included Features

This chart includes most of the basic stuff you'd need when deploying a service to k8s. If you take a look at the `minimal`-configuration, you'll notice that you don't need a lot to get started and most of those are self-explanatory. However there are some components that might require a little explananation

## Liveness/Readiness Probes

Probes are a great way to determine if your service is able to serve traffic, running properly or is safe to be removed/added to a target group (when running on EKS). See an example configuration below.

```yaml
probes:
  liveness:
    enabled: true
    path: /
  readiness:
    enabled: true
    path: /
    initialDelaySeconds: 15
    timeoutSeconds: 10
```

## Autoscaling

You can configure autoscaling with the following properties
```yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 1000
  targetCPUUtilizationPercentage: 80%
  targetMemoryUtilizationPercentage: 80%
```

You can't go below 2 for minReplicas because 1 instance cannot guarantee uptime when rotating nodes of your cluster.

## PodDisruptionBudget
To further guarantee the availability of your service you can enabled the pdb. With `50%` for 2 nodes, 1 instance is guaranteed to be available and nodes will drain accordingly.

```yaml
pdb:
  enabled: true
  maxUnavailable: 50%
```

## Metrics

You can allow Prometheus to discover your service to allow for metric scraping. You can do that by enabling the `serviceMonitor`. This will only work if you're running the Prometheus operator. If you're not, you can use `useAnnotations`, which will annotate the service of your application with `prometheus.io/scrape: "true"` etc.

```yaml
metrics:
  useAnnotations: true # to use legacy annotations on your service
  serviceMonitor:
    enabled: true
  # path: /mypath => defaults t /metrics
  # port: 12345 => defaults to svc port
 
```

## SLO

For generating our SLOs we rely on [sloth.io](https://sloth.dev/). It provides some easy wrapping on generating Prometheus rules/alerts.

```yaml
metrics:
  slo:
  enabled: true
  slos:
  - name: requests-availability
    query: sum(rate(app_request_duration_milliseconds_count{service="myservice",code=~"(5..|429)"}[.window]))
    totalQuery: sum(rate(app_request_duration_milliseconds_count{service="myservice"}[.window]))
    objective: 0.99
    alerting:
      enabled: true
      name: MyServiceHighErrorRate
      labels:
        severity: warning
        owner: myservice
      title: High error rate on request responses
  - name: requests-latency
    query: |
      (
        sum(rate(app_request_duration_milliseconds_count{service="myservice"}[.window]))
        -
        sum(rate(app_request_duration_milliseconds_bucket{le="300",service="myservice"}[.window]))
      )
    totalQuery: sum(rate(app_request_duration_milliseconds_count{service="myservice"}[.window]))
    objective: 0.999
```

This enables the 2 default SLO's:

- request latency
- request availability

Please replace `myservice` with the name of your service.
Enable alerting as desired.

`.window` is a placeholder that will be replaced during templating, replacing `.window` with e.g. `5m` should be a valid and working query!

For non-urgent/critical alerts you can set `disableCritical` to true.

Objective is the percentage of requests that should succeed:

- 0.99 => 99% of requests should succeed, so 10 out of 1000 is allowed to fail
- 0.999 => 99.9% of requests should succeed, so 1 out of 1000 is allowed fail

Feel free to add any other custom SLO's if required.
