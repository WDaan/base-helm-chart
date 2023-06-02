{{- define "base.serviceAccount" }}
{{- if (.Values.serviceAccount).create }}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "base.helpers.names.serviceAccountName" . }}
  labels: {{- include "base.helpers.labels" $ | nindent 4 }}
  {{- with (merge (.Values.serviceAccount.annotations | default dict) (include "base.helpers.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
{{- end }}