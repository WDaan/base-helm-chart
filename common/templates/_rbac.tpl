{{- define "common.rbac" }}
{{- if and (.Values.serviceAccount).create (.Values.serviceAccount).rbac }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: '{{ include "common.helpers.names.fullname" . }}-cluster-role'
  labels: {{- include "common.helpers.labels" $ | nindent 4 }}
  annotations: {{- include "common.helpers.annotations" $ | nindent 4 }}
rules:
{{ toYaml .Values.serviceAccount.rbac }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: '{{ include "common.helpers.names.fullname" . }}-cluster-rolebinding'
  namespace: {{ .Release.Namespace }}
  labels: {{- include "common.helpers.labels" $ | nindent 4 }}
  annotations: {{- include "common.helpers.annotations" $ | nindent 4 }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: '{{ include "common.helpers.names.fullname" . }}-cluster-role'
subjects:
- kind: ServiceAccount
  name: {{ include "common.helpers.names.serviceAccountName" . }}
  namespace: {{ .Release.Namespace }}
{{- end }}
{{- end }}