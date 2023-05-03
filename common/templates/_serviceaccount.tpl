{{- define "common.serviceAccount" }}
{{- if (.Values.serviceAccount).create }}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "common.helpers.names.serviceAccountName" . }}
  labels: {{- include "common.helpers.labels" $ | nindent 4 }}
  {{- with (merge (.Values.serviceAccount.annotations | default dict) (include "common.helpers.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
{{- end }}