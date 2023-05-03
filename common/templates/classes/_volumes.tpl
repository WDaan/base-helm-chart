{{- define "common.classes.volumes" -}}
{{- if .Values.volumes }}
{{ toYaml .Values.volumes }}
{{- end }}
{{- if (default false (.Values.configmap).enabled) }}
- name: {{ include "common.helpers.names.fullname" . }}-configmap
  configMap:
    name: {{ include "common.helpers.names.fullname" . }}-configmap
{{- end }}
{{- end }}
