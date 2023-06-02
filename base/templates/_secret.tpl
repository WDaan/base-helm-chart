{{- define "base.secret" }}
  {{- if .Values.secret }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ (default (include "base.helpers.names.fullname" .) .Values.secretNameOverride ) }}
  labels: {{- include "base.helpers.labels" $ | nindent 4 }}
  annotations: {{- include "base.helpers.annotations" $ | nindent 4 }}
type: Opaque
{{- with .Values.secret }}
stringData:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
{{- end }}