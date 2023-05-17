{{- define "common.deployment" -}}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "common.helpers.names.fullname" . }}
  labels: {{- include "common.helpers.labels" $ | nindent 4 }}
  annotations: {{- include "common.helpers.annotations" $ | nindent 4 }}
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
      {{- include "common.helpers.labels.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      annotations: {{- include "common.classes.podAnnotations" $ | nindent 8 }}
      labels:
        {{- include "common.helpers.labels.selectorLabels" . | nindent 8 }}
        {{- with .Values.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec: {{- include "common.classes.pod" . | nindent 6 }}
{{- end }}
