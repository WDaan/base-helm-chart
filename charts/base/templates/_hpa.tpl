{{- define "base.hpa" -}}
  {{- if (.Values.autoscaling).enabled -}}
    {{- $hpaName := include "base.helpers.names.fullname" . -}}
    {{- $targetName := include "base.helpers.names.fullname" . }}

{{ $minReplicas := default 2 .Values.autoscaling.minReplicas }}
{{ if lt (int64 $minReplicas) 2 }} 
 {{ $minReplicas = 2 }}
{{ end }}
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ $hpaName }}
  labels: {{- include "base.helpers.labels" $ | nindent 4 }}
  annotations: {{- include "base.helpers.annotations" $ | nindent 4 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment 
    name: {{ .Values.autoscaling.target | default $targetName }}
  minReplicas: {{ $minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas | default 3 }}
  metrics:
    {{- if .Values.autoscaling.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization 
          averageUtilization: {{ .Values.autoscaling.targetMemoryUtilizationPercentage }}
    {{- end }}
    {{- if .Values.autoscaling.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization 
          averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
    {{- end }}
  {{- end -}}
{{- end -}}
