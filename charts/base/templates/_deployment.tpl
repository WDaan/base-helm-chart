{{- define "base.deployment" -}}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "base.helpers.names.fullname" . }}
  labels: {{- include "base.helpers.labels" $ | nindent 4 }}
  annotations: {{- include "base.helpers.annotations" $ | nindent 4 }}
spec:
  revisionHistoryLimit: {{ default 3 (.Values.general).revisionHistoryLimit }}
  {{- if not (.Values.autoscaling).enabled }}
  replicas: {{ default 1 (.Values.general).replicas }}
  {{- end }}
  strategy:
    type: RollingUpdate 
    rollingUpdate:
      maxUnavailable: {{ default "25%" (.Values.rollingUpdate).unavailable }}
      maxSurge: {{ default "25%" (.Values.rollingUpdate).surge }}
  selector:
    matchLabels:
      {{- include "base.helpers.labels.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      annotations: {{- include "base.classes.podAnnotations" $ | nindent 8 }}
      labels:
        {{- include "base.helpers.labels.selectorLabels" . | nindent 8 }}
        {{- with .Values.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec: {{- include "base.classes.pod" . | nindent 6 }}
{{- end }}
