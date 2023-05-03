{{- define "common.pdb" -}}
{{- if (.Values.pdb).enabled }}
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ template "common.helpers.names.fullname" . }}
  labels: {{- include "common.helpers.labels" . | nindent 4 }}
  annotations: {{- include "common.helpers.annotations" . | nindent 4 }}
spec:
  maxUnavailable: {{ default "25%" .Values.pdb.maxUnavailable }} 
  selector:
    matchLabels:
      {{- include "common.helpers.labels" . | nindent 6 }}
{{- end }}
{{- end }}
