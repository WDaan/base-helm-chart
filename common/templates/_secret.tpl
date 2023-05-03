{{- define "common.secret" }}
  {{- if .Values.secret }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ (default (include "common.helpers.names.fullname" .) .Values.secretNameOverride ) }}
  labels: {{- include "common.helpers.labels" $ | nindent 4 }}
  annotations: {{- include "common.helpers.annotations" $ | nindent 4 }}
type: Opaque
{{- with .Values.secret }}
stringData:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
{{- end }}