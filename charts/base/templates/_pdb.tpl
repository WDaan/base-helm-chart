{{- define "base.pdb" -}}
{{- if (.Values.pdb).enabled }}
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ template "base.helpers.names.fullname" . }}
  labels: {{- include "base.helpers.labels" . | nindent 4 }}
  annotations: {{- include "base.helpers.annotations" . | nindent 4 }}
spec:
  maxUnavailable: {{ default "25%" .Values.pdb.maxUnavailable }} 
  selector:
    matchLabels:
      {{- include "base.helpers.labels" . | nindent 6 }}
{{- end }}
{{- end }}
