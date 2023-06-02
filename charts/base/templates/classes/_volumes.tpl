{{- define "base.classes.volumes" -}}
{{- if .Values.volumes }}
{{ toYaml .Values.volumes }}
{{- end }}
{{- if (default false (.Values.configmap).enabled) }}
- name: {{ include "base.helpers.names.fullname" . }}-configmap
  configMap:
    name: {{ include "base.helpers.names.fullname" . }}-configmap
{{- end }}
{{- end }}
