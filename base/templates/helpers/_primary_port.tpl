{{- define "base.helpers.primary_port" -}}
{{ default (index .Values.service.ports 0).port (index .Values.service.ports 0).targetPort }}
{{- end -}}

{{- define "base.helpers.primary_port_name" -}}
{{ default (index .Values.service.ports 0).port (index .Values.service.ports 0).name }}
{{- end -}}
