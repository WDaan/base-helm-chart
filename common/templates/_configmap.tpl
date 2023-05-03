{{- define "common.configmap" -}}
{{- $values := .Values.configmap }}
{{- if $values.enabled }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.helpers.names.fullname" . }}-configmap
  {{- with (merge ($values.labels | default dict) (include "common.helpers.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($values.annotations | default dict) (include "common.helpers.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
{{- with .Values.configmap.data }}
data:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
{{- end }}
