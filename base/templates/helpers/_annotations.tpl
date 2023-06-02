{{- define "base.helpers.annotations" -}}
app.kubernetes.io/name: {{ include "base.helpers.names.name" . }}
  {{- with .Values.annotations -}}
    {{- range $k, $v := . }}
      {{- $name := $k }}
      {{- $value := tpl $v $ }}
{{ $name }}: {{ quote $value }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/* Determine the Pod annotations used in the controller */}}
{{- define "base.classes.podAnnotations" -}}
  {{- if .Values.podAnnotations -}}
    {{- tpl (toYaml .Values.podAnnotations) . | nindent 0 -}}
  {{- end -}}
  {{- if (default false (.Values.configmap).enabled) -}}
  {{- printf "checksum/config: %v" (include ("base.configmap") . | sha256sum) | nindent 0 -}}
  {{- end -}}
  {{- if .Values.secret -}}
  {{- printf "checksum/secret: %v" (include ("base.secret") . | sha256sum) | nindent 0 -}}
  {{- end -}}
{{- end -}}
