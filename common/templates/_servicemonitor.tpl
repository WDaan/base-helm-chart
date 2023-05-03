{{- define "common.serviceMonitor" -}}
{{- if ((.Values.metrics).serviceMonitor).enabled }}
{{ $port := include "common.helpers.primary_port_name" . }}
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ template "common.helpers.names.fullname" . }}
  {{- with .Values.metrics.namespace }}
  namespace: {{ . }}
  {{- end }}
  labels: {{- include "common.helpers.labels" . | nindent 4 }}
  annotations: {{- include "common.helpers.annotations" . | nindent 4 }}
spec:
  endpoints:
    - port: {{ default $port .Values.metrics.port | quote }}
      {{- with .Values.metrics.interval }}
      interval: {{ . }}
      {{- end }}
      path: {{ (default "/metrics" .Values.metrics.path) }}
      {{- with .Values.metrics.relabelings }}
      relabelings:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.metrics.metricRelabelings }}
      metricRelabelings:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.metrics.scheme }}
      scheme: {{ . }}
      {{- end }}
      {{- with .Values.metrics.tlsConfig }}
      tlsConfig:
        {{- toYaml . | nindent 8 }}
      {{- end }}
  namespaceSelector:
    matchNames:
      - {{ .Release.Namespace }}
  selector:
    matchLabels:
      {{- include "common.helpers.labels" . | nindent 6 }}
{{- end }}
{{- end }}
