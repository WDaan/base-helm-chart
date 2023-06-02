{{- define "base.rbac" }}
{{- if and (.Values.serviceAccount).create (.Values.serviceAccount).rbac }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: '{{ include "base.helpers.names.fullname" . }}-cluster-role'
  labels: {{- include "base.helpers.labels" $ | nindent 4 }}
  annotations: {{- include "base.helpers.annotations" $ | nindent 4 }}
rules:
{{ toYaml .Values.serviceAccount.rbac }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: '{{ include "base.helpers.names.fullname" . }}-cluster-rolebinding'
  namespace: {{ .Release.Namespace }}
  labels: {{- include "base.helpers.labels" $ | nindent 4 }}
  annotations: {{- include "base.helpers.annotations" $ | nindent 4 }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: '{{ include "base.helpers.names.fullname" . }}-cluster-role'
subjects:
- kind: ServiceAccount
  name: {{ include "base.helpers.names.serviceAccountName" . }}
  namespace: {{ .Release.Namespace }}
{{- end }}
{{- end }}